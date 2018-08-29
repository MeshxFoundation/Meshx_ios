//
//  JMChatReadMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/23.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatReadMsgProcess.h"
#import "JMChatController.h"
#import "JMChatUpdateMsgProcess.h"

static const NSInteger kChatMsgLimit = 12;

@interface JMChatReadMsgProcess ()

@property (nonatomic ,weak) JMChatController *chatController;
@end

@implementation JMChatReadMsgProcess
- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _chatController = (JMChatController *)viewController;
    }
    return self;
}

/**
 首次从数据库读取数据，根据接收到对方信息的时间读取数据：
 步骤：先根据时间倒序，条数查询数据-->查询得到数据进行倒序处理。
 
 @return 读取数据
 */
- (NSArray <XHMessage *> *)loadDataFromSqlite{
    
    [JMChatUpdateMsgProcess updateSqlMsgSendFail];
     NSString *where = [NSString stringWithFormat:@"where %@ = %@ order by %@ desc limit %@",bg_sqlKey(@"userID"),bg_sqlValue(self.chatController.homeModel.userID),bg_sqlKey(@"bg_createTime"),bg_sqlValue(@(kChatMsgLimit))];
    NSArray <XHMessage *> * array = [self getMessageWithWhere:where];
    if (array.count < kChatMsgLimit) {
        self.isReadComplete = YES;
    }
    return array;
}


- (NSArray <XHMessage *> *)loadDataFromSqliteChatHistory{
   
    XHMessage *message = self.chatController.homeModel.message;
    if (!message) {
        return nil;
    }
    [JMChatUpdateMsgProcess updateSqlMsgSendFail];
    NSInteger index = 0;
    if (message.bg_id) {
        if ([message.bg_id integerValue]>kChatHistoryMsgLimitTop) {
            index = [message.bg_id integerValue] - kChatHistoryMsgLimitTop;
        }
    }
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ >= %@ order by %@ desc",bg_sqlKey(@"userID"),bg_sqlValue(self.chatController.homeModel.userID),bg_sqlKey(@"bg_id"),bg_sqlValue(@(index)),bg_sqlKey(@"bg_createTime")];
    NSArray <XHMessage *> * array = [self getMessageWithWhere:where];
    return array;
}


- (NSArray *)loadMoreMessage:(XHMessage *)message{
    
    if (!message.bg_id.integerValue) {
        self.isReadComplete = YES;
        return nil;
    }
    if (self.isReadComplete) {
        return nil;
    }
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ < %@ order by %@ desc limit %@",bg_sqlKey(@"userID"),bg_sqlValue(self.chatController.homeModel.userID),bg_sqlKey(@"bg_id"),bg_sqlValue(message.bg_id),bg_sqlKey(@"bg_id"),bg_sqlValue(@(kChatMsgLimit))];
    NSArray <XHMessage *> * array = [self getMessageWithWhere:where];
    if (array.count < kChatMsgLimit) {
        self.isReadComplete = YES;
    }
    return array;
}

- (NSArray *)getMessageWithWhere:(NSString *)where{
    NSLog(@"===%ld===",[XHMessage bg_count:nil where:nil]);
    NSArray *messages = [XHMessage bg_find:nil where:where];
    NSMutableArray *newMessage = [NSMutableArray array];
    [messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *msg = (XHMessage *)obj;
        if (msg.bubbleMessageType == XHBubbleMessageTypeSending) {
            msg.avatar =  [JMMyInfo headerImage];;
        }else{
           msg.avatar =  [JMHeaderImageManager imageWithUserID:msg.userID];;
        }
        msg.shouldShowUserName = NO;
        switch (msg.messageMediaType) {
            case XHBubbleMessageMediaTypeText:
            {
                if (msg.isNetwork == 2) {
                    NSLog(@"+++++++++");
                }
            }
                break;
            case XHBubbleMessageMediaTypePhoto:
            {
                msg.photo = [UIImage imageWithContentsOfFile:[JMFileSaveManager imageName:msg.eventID]];
                [self.chatController.msgProcess createPhotoWithMessage:msg atIndex:0];
            }
                break;
            case XHBubbleMessageMediaTypeVoice:
            {
                msg.voicePath = [JMFileSaveManager voiceName:msg.eventID];
            }
                break;
                
            default:
                break;
        }
        [newMessage insertObject:msg atIndex:0];
    }];
  
    return newMessage;
}

- (void)hiddenMoreMessage{
    GCDMainQueue(^{
        self.chatController.loadingMoreMessage = NO;
    });
}

- (void)setIsReadComplete:(BOOL)isReadComplete{
    _isReadComplete = isReadComplete;
    if (isReadComplete) {
        [self hiddenMoreMessage];
    }
}

@end
