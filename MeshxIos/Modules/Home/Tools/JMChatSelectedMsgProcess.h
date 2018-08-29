//
//  JMChatSelectedMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
#import "XHMessageTableViewCell.h"

@interface JMChatSelectedMsgProcess : NSObject
- (instancetype)initWithViewController:(UIViewController *)viewController;
//Cell点击
- (void)multiMediaMessageDidSelectedOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell;
//头像点击
- (void)didSelectedAvatarOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath;
@end
