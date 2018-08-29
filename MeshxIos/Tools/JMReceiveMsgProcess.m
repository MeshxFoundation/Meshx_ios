//
//  JMReceiveMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/24.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMReceiveMsgProcess.h"
#import "JMFileSaveManager.h"
#import "WZLBadgeImport.h"
#import "AppDelegate.h"
#import "JMDateManager.h"

@implementation JMReceiveMsgProcess

+ (void)receiveMsgWithModel:(MCSessionModel *)sessionModel message:(messageBack)message{
     NSInteger  isRefreshTabbarBadge = 0;
       if ([sessionModel.process.type isEqualToString:kJMChatMsgTextAPI]) {
            XHMessage *textMessage = [JMReceiveMsgProcess getTextMessageWithModel:sessionModel];
           isRefreshTabbarBadge = [self dealChatControllerMessageWithType:JMChatMessageTypeText sessionModel:sessionModel message:textMessage msgBack:message];
        }else if ([sessionModel.process.type isEqualToString:kJMChatMsgFileAPI]){
            NSString *fileType = sessionModel.process.msg[@"fileType"];
            if ([fileType isEqualToString:kJMChatMsgFilePhotoType]) {
                
                XHMessage *photoMessage = [JMReceiveMsgProcess getPhotoMessageWithModel:sessionModel];
                isRefreshTabbarBadge = [self dealChatControllerMessageWithType:JMChatMessageTypePhoto sessionModel:sessionModel message:photoMessage msgBack:message];
               
                GCDGlobalQueue(^{
                    [JMFileSaveManager saveImage:sessionModel.process.fileData imageName:photoMessage.eventID];
                });
            }else if ([fileType isEqualToString:kJMChatMsgFileVoiceType]){
                
                NSString *eventID = sessionModel.process.msg[@"eventID"];
                [JMFileSaveManager saveVoice:sessionModel.process.fileData voiceName:eventID];
                XHMessage *voiceMessage = [JMReceiveMsgProcess getVoiceMessageWithModel:sessionModel];
                isRefreshTabbarBadge = [self dealChatControllerMessageWithType:JMChatMessageTypeVoice sessionModel:sessionModel message:voiceMessage msgBack:message];
            }
        }
    
    if (isRefreshTabbarBadge) {
        [self setupTabbarBadgeWithUserID:nil];
    }
}

+ (XHMessage *)getTextMessageWithModel:(MCSessionModel *)sessionModel{
    if (sessionModel.process.msg == nil) {
        return nil;
    }
    NSDate *date = [JMDateManager dateFromString:sessionModel.process.msg[@"time"]];
    XHMessage *textMessage = [[XHMessage alloc] initWithText:sessionModel.process.msg[@"content"] sender:sessionModel.name timestamp:date];
    [self setupMessage:textMessage sessionModel:sessionModel];
    return textMessage;
}

+ (XHMessage *)getPhotoMessageWithModel:(MCSessionModel *)sessionModel{
    
    NSDate *date = [JMDateManager dateFromString:sessionModel.process.msg[@"time"]];;
    UIImage *photo =[UIImage imageWithData:sessionModel.process.fileData];
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sessionModel.name timestamp:date];
    photoMessage.text = @"[图片]";
    [self setupMessage:photoMessage sessionModel:sessionModel];
    return photoMessage;
}

+ (XHMessage *)getVoiceMessageWithModel:(MCSessionModel *)sessionModel{
    
    NSDate *date = [JMDateManager dateFromString:sessionModel.process.msg[@"time"]];
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:nil voiceDuration:sessionModel.process.msg[@"voiceDuration"] sender:sessionModel.name timestamp:date];
    voiceMessage.text = @"[语音]";
    [self setupMessage:voiceMessage sessionModel:sessionModel];
    return voiceMessage;
}

+ (void)setupMessage:(XHMessage *)message sessionModel:(MCSessionModel *)sessionModel{
    message.bubbleMessageType = XHBubbleMessageTypeReceiving;
    message.userID = sessionModel.userID;
    message.isNetwork = 1;
    message.eventID = sessionModel.process.msg[@"eventID"];
    message.avatar = [JMHeaderImageManager imageWithUserID:message.userID];
}

+ (void)saveMessageToSqlite:(XHMessage *)message isSuccess:(void (^)(BOOL isSuccess))isSuccess{
    
    [message bg_saveAsync:isSuccess];
}


+ (void)setupTabbarBadgeWithUserID:(NSString *)userID{
    
    UITabBarController *tabBarController = [self getTabBarController];
    UITabBarItem *firstItem = tabBarController.tabBar.items.firstObject;
    //it is necessary to adjust badge position
    firstItem.badgeCenterOffset = CGPointMake(-5, 6);
    GCDGlobalQueue((^{
        if (userID) {
            //更新数据
            [XHMessage bg_update:nil where:[NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"isReadMsg"),bg_sqlValue(@(YES)),bg_sqlKey(@"userID"),bg_sqlValue(userID)]];
        }
        NSInteger value = [XHMessage bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"isReadMsg"),bg_sqlValue(@(NO))]].count;
        GCDMainQueue(^{
            [firstItem showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeNone];
        });
    }));
    
}

+ (NSInteger)getBadgeBadgeWithUserID:(NSString *)userID{
      NSInteger value = [XHMessage bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"isReadMsg"),bg_sqlValue(@(NO)),bg_sqlKey(@"userID"),bg_sqlValue(userID)]].count;
    return value;
}

+ (NSInteger)dealChatControllerMessageWithType:(JMChatMessageType)type sessionModel:(MCSessionModel *)sessionModel message:(XHMessage *)message msgBack:(messageBack)msgBack{
    NSInteger  isRefreshTabbarBadge = 1;
    NSInteger count = 0;
    JMChatController *chatCon = nil;
    NSArray *chats = [self getChatControllers];
    for (JMChatController *chatController in chats) {
        if ([chatController.homeModel.userID isEqualToString:sessionModel.userID]) {
           
            switch (type) {
                case JMChatMessageTypeText:
                case JMChatMessageTypePhoto:{
                    if (!count) {
                       [chatController.msgProcess createPhotoWithMessage:message];
                    }
                    
                }
                    break;
                case JMChatMessageTypeVoice:{
                    NSString *eventID = sessionModel.process.msg[@"eventID"];
                    message.voicePath = [JMFileSaveManager voiceName:eventID];
                }
                    break;
                    
                default:
                    break;
            }
            isRefreshTabbarBadge = 0;
            message.isReadMsg = YES;
            [chatController addAndFinishSendMessage:message];
            chatCon = chatController;
            count ++;
        }
       
    }
    msgBack(message,chatCon,[message bg_save]);

    return isRefreshTabbarBadge;
}

+ (JMChatController *)getChatController{
    UITabBarController *rootViewController = [self getTabBarController];
    UINavigationController *nav = (UINavigationController *)rootViewController.selectedViewController;
    for (UIViewController *viewController in nav.viewControllers) {
        if ([viewController isKindOfClass:[JMChatController class]]) {
            return (JMChatController *)viewController;
        }
    }
    return nil;
}

+ (NSArray *)getChatControllers{
    UITabBarController *rootViewController = [self getTabBarController];
    UINavigationController *nav = (UINavigationController *)rootViewController.selectedViewController;
    NSMutableArray *chats = [NSMutableArray array];
    for (UIViewController *viewController in nav.viewControllers) {
        if ([viewController isKindOfClass:[JMChatController class]]) {
            [chats addObject:viewController];
        }
    }
    if (!chats.count) {
        return nil;
    }
    return chats;
}

+ (UITabBarController *)getTabBarController{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (UITabBarController *)delegate.window.rootViewController;
}

@end
