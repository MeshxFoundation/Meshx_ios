//
//  JMXMPPTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPTool.h"
#import "JMTabBarPromptTool.h"
#import "JMPeopleModel.h"
#import "JMUserManager.h"
#import "JMMyInfo.h"
#import "JMXMPPReceiveMsgProcess.h"

//连接服务器类型
typedef NS_ENUM(NSUInteger,ConnectToServerStatus) {
    ConnectToServerStatusLogin,
    ConnectToServerStatusRegist,
};

//NSString *const kJMXMPPHost = @"192.168.137.1";
//static NSInteger const kJMXMPPPort = 5222;
NSString *const kJMXMPPHost = @"58.64.198.59";
static NSInteger const kJMXMPPPort = 5222;
NSString *const kJMXMPPDoMain = @"im.jm.com";
NSString *const kJMXMPPSubDoMain = @"group";
NSString *const kJMXMPPReSource = @"iOS";

NSString *const kJMXMPPLoginResultNotification = @"JMXMPPLoginResultNotification";
NSString *const kJMXMPPRegisterResultNotification = @"JMXMPPRegisterResultNotification";
NSString *const kJMXMPPRosterDidChangeNotification = @"JMXMPPRosterDidChangeNotification";
NSString *const kJMXMPPRosterDidEndPopulatingNotification = @"JMXMPPRosterDidEndPopulatingNotification";
NSString *const kJMXMPPGetGroupNotification = @"JMXMPPGetGroupNotification";

@interface JMXMPPTool()

//注册密码
@property (nonatomic,strong)NSString *registpassword;
//是登入还是注册
@property (nonatomic,assign)ConnectToServerStatus connectToSercerStatus;

@property (nonatomic ,copy)sendElementResultBack resultBack;

@end

@implementation JMXMPPTool

static JMXMPPTool *_instance;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [JMXMPPTool new];
    });
    
    return _instance;
}

- (XMPPStream *)xmppStream
{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        //socket 连接的时候 要知道host port 然后connect
        [self.xmppStream setHostName:kJMXMPPHost];
        [self.xmppStream setHostPort:kJMXMPPPort];
        //为什么是addDelegate? 因为xmppFramework 大量使用了多播代理multicast-delegate ,代理一般是1对1的，但是这个多播代理是一对多得，而且可以在任意时候添加或者删除
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        
        //添加功能模块
        //1.autoPing 发送的时一个stream:ping 对方如果想表示自己是活跃的，应该返回一个pong
        _xmppAutoPing = [[XMPPAutoPing alloc] init];
        //autoPing由于它会定时发送ping,要求对方返回pong,因此这个时间我们需要设置
//        心跳包间隔
        [_xmppAutoPing setPingInterval:20];
        //不仅仅是服务器来得响应;如果是普通的用户，一样会响应
        [_xmppAutoPing setRespondsToQueries:YES];
        //所有的Module模块，都要激活active
        [_xmppAutoPing activate:self.xmppStream];
        //这个过程是C---->S  ;观察 S--->C(需要在服务器设置）
        
        //2.autoReconnect 自动重连，当我们被断开了，自动重新连接上去，并且将上一次的信息自动加上去
        _xmppReconnect = [[XMPPReconnect alloc] init];
        _xmppReconnect.reconnectDelay = 0.f;// 一旦失去连接，立马开始自动重连，不延迟
        _xmppReconnect.reconnectTimerInterval = 3.0f;// 每隔3秒自动重连一次
        [_xmppReconnect setAutoReconnect:YES];
        [_xmppReconnect activate:self.xmppStream];
        [_xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
        _vCardTool = [[JMXMPPvCardTool alloc] init];
        _rosterTool = [[JMXMPPRosterTool alloc] init];
        [_rosterTool xmppRoster];
//        //4.消息模块，这里用单例，不能切换账号登录，否则会出现数据问题。
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
//
//        //5、文件接收
        _xmppIncomingFileTransfer = [[XMPPIncomingFileTransfer alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
        [_xmppIncomingFileTransfer activate:self.xmppStream];
        [_xmppIncomingFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppIncomingFileTransfer setAutoAcceptFileTransfers:YES];
    }
    return _xmppStream;
}



//与服务器建立链接
-(void)connectToServerWithUser:(NSString *)user result:(sendElementResultBack)result{
    //要是正在链接的话那么就先断开连接
    if ([self.xmppStream isConnected]) {
        [self disconnectServer];
    }
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:kJMXMPPDoMain resource:kJMXMPPReSource];
    self.xmppStream.myJID = jid;
    
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:20.0f error:&error];
    if (nil != error) {
        NSLog(@"%s__%d__链接出错：%@",__FUNCTION__,__LINE__,error);
    }
    if (result) {
        self.resultBack = result;
    }
}

//与服务器断开链接
-(void)disconnectServer{
    [self.xmppStream disconnect];
}
//登入
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password result:(sendElementResultBack)result{
    self.connectToSercerStatus = ConnectToServerStatusLogin;
    self.loginpassword = password;//将传进来的password传给self.loginpassword
    self.loginName = userName;
    [self connectToServerWithUser:userName result:result];
}
//注册
- (void)registWithUserName:(NSString *)userName password:(NSString *)password result:(sendElementResultBack)result{
    self.connectToSercerStatus = ConnectToServerStatusRegist;
    self.registpassword = password;
    [self connectToServerWithUser:userName result:result];
}

#pragma mark XMPPStreamDelegate
//与服务器链接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
#pragma mark 判断与服务器建立连接是登陆还是注册
    GCDMainQueue(^{

        switch (self.connectToSercerStatus) {
            case ConnectToServerStatusLogin:
            {
                NSError *error = nil;
                [self.xmppStream authenticateWithPassword:self.loginpassword error:&error];
                if (nil != error) {
                    NSLog(@"%s__%d__验证出错：%@",__FUNCTION__,__LINE__,error);
                    [self setupResultBackFail];
                }
                break;
            }
            case ConnectToServerStatusRegist:
            {
                NSError *err = nil;
                [self.xmppStream registerWithPassword:self.registpassword error:&err];
                if (nil != err) {
                    NSLog(@"%s__%d__注册出错：%@",__FUNCTION__,__LINE__,err);
                    [self setupResultBackFail];
                }
                break;
            }
            default:
                break;
        }
    });

}
//与服务器链接失败
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"😂与服务器链接失败");
    GCDMainQueue(^{
        [self setupResultBackFail];
        self.isSocketState = NO;
    });
    
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    NSLog(@"🔌socket正在连接...");
    self.isSocketState = YES;
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"😂xmpp失去连接。");
    GCDMainQueue(^{
        //如果error == nil 时，说明是你手动调用了disconnect方法进行断开的
        if (error != nil) {
            [self setupResultBackFail];
        }
        self.isSocketState = NO;
    });
    
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    self.isSocketState = YES;
    NSLog(@"🍎socket连接成功");
    // 连接成功之后，由客户端xmpp发送一个stream包给服务器，服务器监听来自客户端的stream包，并返回stream feature包
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    self.isSocketState = NO;
    NSLog(@"😂xmpp授权失败:%@", error.description);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"🍎xmpp授权成功。");
    self.isSocketState = YES;
    GCDMainQueue(^{
        [JMXMPPTool sharedInstance].isLoginSuccess = YES;
        [self saveMyInfo];
        //验证之后默认的状态为离线，需要手动告诉服务器自己的状态,设置为上线
        [self setupPresenceWithType:kJMXMPPAvailable];
        // 只有进入到这里，才算是真正的可以聊天了
    });
  
}

- (void)setupResultBackFail{
    if (self.resultBack) {
        self.resultBack(NO, nil, self.xmppStream);
        self.resultBack = nil;
    }
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags{
   NSLog(@"%s",__FUNCTION__);
//    [self loginWithUserName:self.loginName password:self.loginpassword];

}

- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (void)setupPresenceWithType:(NSString *)type{
    XMPPPresence *presence = [XMPPPresence presenceWithType:type];
    [[JMXMPPTool sharedInstance].xmppStream sendElement:presence];
}

- (void)saveMyInfo{
    
    //保存用户名片
    [JMMyInfo saveToFile];
    //保存用户名和密码
    [JMUserManager addUserWithName:[JMMyInfo name] pwd:[JMXMPPTool sharedInstance].loginpassword];
    
}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
}

/**
 *  退出登录
 */
- (void)logout
{
    
    //设置自己状态为离线
    [self setupPresenceWithType:kJMXMPPUnavailable];
    [self.xmppStream disconnect];
    [self.xmppStream removeDelegate:self];
    self.xmppReconnect.autoReconnect = NO;
    [JMXMPPTool sharedInstance].isLoginSuccess = NO;
    [self.xmppReconnect deactivate];
    [self.xmppAutoPing deactivate];
    [self.rosterTool clearData];
    [self.vCardTool clearData];
    [self.xmppMessageArchiving deactivate];
    [self.xmppIncomingFileTransfer deactivate];
    self.isSocketState = NO;
    self.loginName = nil;
    self.loginpassword = nil;
    self.xmppStream = nil;
    
}


#pragma mark ===== 文件接收=======
/** 是否同意对方发文件给我 */
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didReceiveSIOffer:(XMPPIQ *)offer
{
    NSLog(@"%s",__FUNCTION__);
    //弹出一个是否接收的询问框
    //    [self.xmppIncomingFileTransfer acceptSIOffer:offer];
}

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didSucceedWithData:(NSData *)data named:(NSString *)name
{
    NSLog(@"%s",__FUNCTION__);

}

#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    [JMXMPPReceiveMsgProcess dealReceiveMsg:message];
    NSLog(@"%s--%@",__FUNCTION__, message);
    //XEP--0136 已经用coreData实现了数据的接收和保存
    
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    if ([message.type isEqualToString:kJMXMPPMessageType] &&message.body) {
         NSDictionary *dic = [message.body jsonValueDecoded];
        JJTransportProcess *process = [JJTransportProcess new];
        process.type = kJMChatMsgBackAPI;
        process.msg = @{@"eventID":dic[@"eventID"],@"userID":dic[@"userID"]};
        MCSessionModel *model = [MCSessionModel new];
        model.jid = [JMXMPPUserManager getJidWithName:dic[@"userName"]];
        model.process = process;
        GCDMainQueue(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:model];
        });
        
    }
    NSLog(@"%s--%@",__FUNCTION__, message);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
     NSLog(@"%s--%@",__FUNCTION__, message);
    if ([message.type isEqualToString:kJMXMPPMessageType] &&message.body) {
        NSDictionary *dic = [message.body jsonValueDecoded];
        GCDMainQueue(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kJMXMPPDidFailToSendMessageNotification object:dic[@"eventID"]];
        });
        
    }
   
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//    <iq xmlns="jabber:client" type="result" id="E203DEAB-E818-43E9-AB96-831F109C0000" to="9@localhost/iOS"></iq>
    NSLog(@"%s----iq:%@",__func__,iq);
    GCDMainQueue(^{
        if (self.resultBack) {
            self.resultBack(YES, iq, self.xmppStream);
            self.resultBack = nil;
        }
    });
   
//    if ([iq.type isEqualToString:@"result"]) {
//        
//    }
//    // 以下两个判断其实只需要有一个就够了
//    NSString *elementID = iq.elementID;
//    if (![elementID isEqualToString:@"getMyRooms"]) {
//        return YES;
//    }
//    
//    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
//    if (results.count < 1) {
//        return YES;
//    }
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (DDXMLElement *element in iq.children) {
//        if ([element.name isEqualToString:@"query"]) {
//            for (DDXMLElement *item in element.children) {
//                if ([item.name isEqualToString:@"item"]) {
//                    [array addObject:item];          //array  就是你的群列表
//                    
//                }
//            }
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kJMXMPPGetGroupNotification object:array];
//    
    return YES;
}

+ (void)sendElement:(DDXMLElement *)element result:(sendElementResultBack)result{
    XMPPStream *stream = [JMXMPPTool sharedInstance].xmppStream;
    if ([stream isConnected]) {
        [[JMXMPPTool sharedInstance].xmppStream sendElement:element];
        if (result) {
            [JMXMPPTool sharedInstance].resultBack = [result copy];
        }
    }else{
        if (result) {
            result(NO,nil,stream);
        }
    }
    
    
}

@end
