//
//  JMReceiveMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/24.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
#import "JMChatController.h"

typedef void(^messageBack)(XHMessage *message,JMChatController *chatController ,BOOL isSuccess);

@interface JMReceiveMsgProcess : NSObject

typedef NS_ENUM(NSInteger, JMChatMessageType) {
    
    JMChatMessageTypeText = 0,//文本
    JMChatMessageTypePhoto,//图片
    JMChatMessageTypeVoice,//语言
};

+ (void)receiveMsgWithModel:(MCSessionModel *)sessionModel message:(messageBack)message;

+ (XHMessage *)getTextMessageWithModel:(MCSessionModel *)sessionModel;
+ (XHMessage *)getPhotoMessageWithModel:(MCSessionModel *)sessionModel;
+ (XHMessage *)getVoiceMessageWithModel:(MCSessionModel *)sessionModel;
+ (void)setupTabbarBadgeWithUserID:(NSString *)userID;
+ (NSInteger)getBadgeBadgeWithUserID:(NSString *)userID;
+ (JMChatController *)getChatController;
+ (NSArray *)getChatControllers;
@end
