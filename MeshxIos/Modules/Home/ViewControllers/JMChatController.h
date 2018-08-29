//
//  JMChatController.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTableViewController.h"
#import "JMHomeModel.h"
#import "JMChatMsgProcess.h"
#import "JMChatReadMsgProcess.h"

@interface JMChatController : XHMessageTableViewController
@property (nonatomic ,strong) JMHomeModel *homeModel;
@property (nonatomic ,strong) JMChatMsgProcess *msgProcess;
//好友是否在线
@property (nonatomic ,assign) BOOL isAvailable;
//是否是好友
@property (nonatomic ,assign) BOOL isFriend;
- (void)addAndFinishSendMessage:(XHMessage *)message;
@end
