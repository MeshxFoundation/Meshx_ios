//
//  JMXMPPRosterTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/20.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPRosterTool.h"
#import "JMPeopleModel.h"
#import "JMTabBarPromptTool.h"
#import "JMXMPPUserDataProcess.h"


@implementation JMXMPPRosterTool{
   
}
- (instancetype)init{
    if (self = [super init]) {
       
        
    }
    return self;
}

- (XMPPRoster *)xmppRoster{
    if (!_xmppRoster) {
        _rosterDataSource = [NSMutableArray array];
        _rosterType = JMXMPPRosterToolPopulatingTypeNormal;
        // 3.好友模块 支持我们管理、同步、申请、删除好友
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
        [_xmppRoster activate:[JMXMPPTool sharedInstance].xmppStream];
        //同时给_xmppRosterMemoryStorage 和 _xmppRoster都添加了代理
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
        [_xmppRoster setAutoFetchRoster:YES]; //自动同步，从服务器取出好友
        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:NO];
        
        [[JMXMPPTool sharedInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    return _xmppRoster;
}

#pragma mark ===== 好友模块 委托=======
/** 收到出席订阅请求（代表对方想添加自己为好友) */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{

    [[JMXMPPTool sharedInstance].rosterTool.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:NO];
    NSLog(@"收到%@添加好友请求",presence.from.user);
   
    
}

/**
 * 开始同步服务器发送过来的自己的好友列表
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    self.rosterType = JMXMPPRosterToolPopulatingTypeBegin;
    [self.rosterDataSource removeAllObjects];
}

//收到每一个好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
  
    self.rosterType = JMXMPPRosterToolPopulatingTypeDo;
    [self.rosterDataSource addObject:item];
}

/**
 * 同步结束
 **/
//收到好友列表IQ会进入的方法，并且已经存入我的存储器
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"%s",__FUNCTION__);
    //如果获取不是等于JMXMPPRosterToolPopulatingTypeDo，那说获取花名册超时，未能获取好友列表，才走的这个方法的
    if (self.rosterType != JMXMPPRosterToolPopulatingTypeDo) {
        if (self.rosterType != JMXMPPRosterToolPopulatingTypeEnd) {
            [self.xmppRoster fetchRoster];
        }
        return;
    }
    @synchronized(self) {

        self.rosterType = JMXMPPRosterToolPopulatingTypeEnd;
        NSArray *array = [self dealData];
        //说明好友列表已经全部接收完成
        [[NSNotificationCenter defaultCenter] postNotificationName:kJMXMPPRosterDidEndPopulatingNotification object:array];
    }
    
}

- (NSArray *)dealData{
    
    //删除全部好友
    [JMPeopleModel deleteAllFriend];
    //设置新好友的状态为查看
    NSMutableArray *peopleDatas = [NSMutableArray array];
    NSMutableArray *rosterArray = [self.rosterDataSource mutableCopy];
    for (NSXMLElement *item in rosterArray) {
        NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
        NSString *jidStr = [[item attributeForName:@"jid"]stringValue];
        XMPPJID *jid =[XMPPJID jidWithString:jidStr];
        
        // 双方都是好友
        if ([subscription isEqualToString:@"both"]) {
            [peopleDatas addObject:[JMXMPPUserDataProcess savePeople:jid]];
        
        }else if ([subscription isEqualToString:@"to"]){
        
        }else if ([subscription isEqualToString:@"from"]){
        }
    }

    return peopleDatas;
}

// 如果不是初始化同步来的roster,那么会自动存入我的好友存储器
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJMXMPPRosterDidChangeNotification object:nil];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"=====%@====",presence);
    XMPPJID *from =  presence.from;
    XMPPJID *to = presence.to;
     NSString *presenceType = [presence type];
    if ([presenceType isEqualToString:@"unsubscribed"]) {
        //说明对方删除我
        if ([to.user isEqualToString:[JMMyInfo name]]) {
             [JMXMPPUserDataProcess deleteWithJid:from];
        }
        
    }
}

/**
 获取在线好友
 
 @return 在线好友
 */
- (NSArray <XMPPUserMemoryStorageObject *>*)allAvailableFriends{
    return [_xmppRosterMemoryStorage sortedAvailableUsersByName];
}
/**
 获取离线好友
 
 @return 离线好友
 */
- (NSArray <XMPPUserMemoryStorageObject *>*)allUnavailableFriends{
    return [_xmppRosterMemoryStorage sortedUnavailableUsersByName];
}


/**
 判断用户是否在线
 
 @param jid 用户
 @return 是否在线
 */
- (BOOL)isAvailableWithJid:(XMPPJID *)jid{
    __block BOOL isAvailable = NO;
    [[self.xmppRosterMemoryStorage sortedAvailableUsersByName] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XMPPUserMemoryStorageObject *user = (XMPPUserMemoryStorageObject *)obj;
        if ([user.jid.user isEqualToString:jid.user]) {
            isAvailable = YES;
            *stop = YES;
        }
    }];
    return isAvailable;
}

// 添加好友同意后，会进入到此代理
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq {
    
    NSLog(@"===添加好友同意后，会进入到此代理=%@+==iq===",iq);
    @synchronized(self) {
       [self dealReceiveRosterPush:iq];
    }
    
}

- (void)dealReceiveRosterPush:(XMPPIQ *)iq{
    DDXMLElement *query = [iq elementsForName:@"query"][0];
    DDXMLElement *item = [query elementsForName:@"item"][0];
    
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    NSString *jidString = [[item attributeForName:@"jid"] stringValue];
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    // 说明双方成为好友
    if ([subscription isEqualToString:@"both"]) {
        [JMXMPPUserDataProcess savePeople:jid];
        //广播添加用户
        [JMXMPPNotificationUserModel postNotificationWithJid:jid type:JMXMPPNotificationUserModelTypeAdd];
        
    }else if ([subscription isEqualToString:@"remove"]) {
        
        [JMXMPPUserDataProcess deleteWithJid:jid];
        
    }else if ([subscription isEqualToString:@"none"]){
        
        
    }else if ([subscription isEqualToString:@"to"]){
        NSLog(@"我成功添加对方为好友，即对方已经同意我添加好友的请求");
        
    }else if ([subscription isEqualToString:@"from"]){
        NSLog(@"我已同意对方添加我为好友的请求");
        //对方添加我为好友，我已经同意添加（即我是对方好友，但对方不是我的好友）
        [JMXMPPUserDataProcess showTabBarPrompt:jid];
    }
    
}

//在线时会回调该方法
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender
    didAddResource:(XMPPResourceMemoryStorageObject *)resource
          withUser:(XMPPUserMemoryStorageObject *)user{
    //发送在线通知
    [JMXMPPNotificationUserModel postNotificationWithJid:user.jid type:JMXMPPNotificationUserModelTypeAvailable];
}

//离线是会回调该方法
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender
 didRemoveResource:(XMPPResourceMemoryStorageObject *)resource
          withUser:(XMPPUserMemoryStorageObject *)user{
    //发送离线通知
     [JMXMPPNotificationUserModel postNotificationWithJid:user.jid type:JMXMPPNotificationUserModelTypeUnavailable];
}

- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didAddUser:(XMPPUserMemoryStorageObject *)user{
    NSLog(@"%s",__FUNCTION__);
}
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didUpdateUser:(XMPPUserMemoryStorageObject *)user{
    NSLog(@"%s",__FUNCTION__);
}
- (void)xmppRoster:(XMPPRosterMemoryStorage *)sender didRemoveUser:(XMPPUserMemoryStorageObject *)user{
    NSLog(@"%s",__FUNCTION__);
}

- (void)clearData{
    self.rosterType = JMXMPPRosterToolPopulatingTypeNormal;
    [self.rosterDataSource removeAllObjects];
    [self.xmppRoster deactivate];
    [self.xmppRoster removeDelegate:self];
    self.xmppRoster = nil;
}


@end
