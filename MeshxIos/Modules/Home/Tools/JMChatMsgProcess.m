//
//  JMChatMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatMsgProcess.h"
#import "JMChatController.h"
#import "JMFileSaveManager.h"
#import "JMChatUpdateMsgProcess.h"
#import "JMReceiveMsgProcess.h"
#import "JMMessageResendModel.h"
static NSInteger const kJMChatSendMsgTimeOut = 10;
//重发的最多次数
static NSInteger const kJMChatMessageResendMaxCount = 2;
@interface JMChatMsgProcess ()
@property (nonatomic ,weak) JMChatController *chatController;
@property (nonatomic ,strong) NSMutableArray *sendDataSources;

@property (nonatomic ,strong) dispatch_source_t timer;

@end

@implementation JMChatMsgProcess

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _chatController = (JMChatController *)viewController;
        _sendMsgProcess = [[JMChatSendMsgProcess alloc] initWithViewController:viewController];
        _sendDataSources = [NSMutableArray array];
        _photoSources = [NSMutableArray array];
        _photoMessageSources = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMsgBackSuccess:) name:kJMChatSendMsgBackSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToSendMessage:) name:kJMXMPPDidFailToSendMessageNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    if (_timer) {
        //取消定时器
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startTimer{
    
    if (_timer) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0);
    WEAKSELF
    dispatch_source_set_event_handler(self.timer, ^{
        NSArray *sendDatas = [NSArray arrayWithArray:self.sendDataSources];
        [sendDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XHMessage *message = (XHMessage *)obj;
            if (message.messageMediaType == XHBubbleMessageMediaTypeText) {
                if (message.isNetwork == 0) {
                    NSDate *nowDate = [NSDate date];
                    NSInteger sec = [nowDate timeIntervalSinceDate:message.timestamp];
                    //每次发送的时间间隔
                    NSInteger timeOut = kJMChatSendMsgTimeOut+message.text.length/10;
                    if (sec >timeOut*kJMChatMessageResendMaxCount) {
                        message.isNetwork = 2;
                        [JMChatUpdateMsgProcess updateSqlMsgWithEventID:message.eventID isNetwork:2];
                        //移除发送数据
                  [self.sendMsgProcess.sendMessageCache removeObjectForKey:message.eventID];
                        GCDMainQueue(^{
                                [self.sendDataSources removeObject:message];
                         [self.chatController.messageTableView reloadData];
                        });
                    }else{
                        NSInteger count = sec/timeOut;
                        if (count>0&&count != message.resendCount) {
                            message.resendCount = count;
                            JMMessageResendModel *resendModel = [self.sendMsgProcess.sendMessageCache objectForKey:message.eventID];
                            if (resendModel) {
                                [self.sendMsgProcess messageResend:resendModel];
                            }
                           
                        }
                    }
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!sendDatas.count) {
                if (weakSelf.timer) {
                    //取消定时器
                    dispatch_source_cancel(weakSelf.timer);
                    weakSelf.timer = nil;
                }
            }
        });
    });
    
    dispatch_resume(self.timer);
}

- (void)sendMsgBackSuccess:(NSNotification *)not{
    NSString *eventID = not.object;
    [self setupMessageStateWithEventID:eventID isNetwork:1];
  
}

- (void)didFailToSendMessage:(NSNotification *)not{
    NSString *eventID = not.object;
    [self setupMessageStateWithEventID:eventID isNetwork:2];
}

- (void)setupMessageStateWithEventID:(NSString *)eventID isNetwork:(NSInteger)isNetwork{
    GCDGlobalQueue(^{
        NSArray *sendDatas = [NSArray arrayWithArray:self.sendDataSources];
        [sendDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XHMessage *msg = (XHMessage *)obj;
            if ([msg.eventID isEqualToString:eventID]) {
                msg.isNetwork = isNetwork;
            //移除发送数据
             [self.sendMsgProcess.sendMessageCache removeObjectForKey:eventID];
                GCDMainQueue(^{
                    [self.sendDataSources removeObject:msg];
                    [self.chatController.messageTableView reloadData];
                });
                *stop = YES;
            }
        }];
    });
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date{
   
    NSString *eventID = [JMEventIDManager getEventIDWithDate:date];
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
    [self setupMessage:textMessage eventID:eventID];
    //先保存信息
    [textMessage bg_saveAsync:^(BOOL isSuccess) {
        
    }];
    GCDGlobalQueue(^{
        //发送信息
        [self.sendMsgProcess sendTextMessage:textMessage model:self.chatController.homeModel];
    });
  
}
/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date{
     NSString *eventID = [JMEventIDManager getEventIDWithDate:date];
    
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    [self setupMessage:photoMessage eventID:eventID];
    [self createPhotoWithMessage:photoMessage];
    [photoMessage bg_saveAsync:^(BOOL isSuccess) {
        
    }];
    GCDGlobalQueue(^{
        [self.sendMsgProcess sendPhotoMessage:photoMessage model:self.chatController.homeModel];
    });
}
- (void)createPhotoWithMessage:(XHMessage *)message {
    
    [self createPhotoWithMessage:message atIndex:self.photoMessageSources.count];

}

- (void)createPhotoWithMessage:(XHMessage *)message atIndex:(NSInteger )index{
        [self.photoMessageSources insertObject:message atIndex:index];
        MWPhoto *mwPhoto = [MWPhoto photoWithImage:message.photo];
        [self.photoSources insertObject:mwPhoto atIndex:index];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date{
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    [self.chatController addAndFinishSendMessage:videoMessage];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date{
    
     NSString *eventID = [JMEventIDManager getEventIDWithDate:date];
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    [self setupMessage:voiceMessage eventID:eventID];
    voiceMessage.isReadVoice = YES;
    [voiceMessage bg_saveAsync:^(BOOL isSuccess) {
        
    }];
    GCDGlobalQueue(^{
        [self.sendMsgProcess sendVoiceMessage:voiceMessage model:self.chatController.homeModel];
    });
}

- (void)setupMessage:(XHMessage *)message eventID:(NSString *)eventID{
    message.isNetwork = 0;
    message.isReadMsg = YES;
    message.eventID = eventID;
    message.userID = self.chatController.homeModel.userID;
    message.avatar = [JMMyInfo headerImage];
    [self.sendDataSources addObject:message];
    [self startTimer];
    [self sendMessage:message];
  
}

- (void)sendMessage:(XHMessage *)message{
    NSArray *chats = [JMReceiveMsgProcess getChatControllers];
    for (JMChatController *chatController in chats) {
        if ([chatController.homeModel.userID isEqualToString:self.chatController.homeModel.userID]) {
            [chatController addAndFinishSendMessage:message];
        }
    }
}


@end
