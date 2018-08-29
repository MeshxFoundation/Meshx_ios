//
//  JMChatSendMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMHomeModel.h"
#import "JJTransportProcess.h"
#import "JMMessageResendModel.h"
typedef NS_ENUM(NSInteger, JMSendMsgType) {
    JMSendMsgTypeText = 0,
    JMSendMsgTypePhoto,
    JMSendMsgTypeVoice
};

@interface JMChatSendMsgProcess : NSObject

@property (nonatomic ,strong)NSCache *sendMessageCache;
- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)sendTextMessage:(XHMessage *)message model:(JMHomeModel *)model;
- (void)sendPhotoMessage:(XHMessage *)message model:(JMHomeModel *)model;
- (void)sendVoiceMessage:(XHMessage *)message model:(JMHomeModel *)model;
/**
 消息重发
 
 @param model 消息重发模型
 */
- (void)messageResend:(JMMessageResendModel *)model;
@end
