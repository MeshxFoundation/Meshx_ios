//
//  JMConstantNotification.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

//自己发送消息通知
NSString *const kJMChatSendMsgNotification = @"JMChatSendMsgNotification";
//自己编写消息，还没有发送，草稿通知
NSString *const kJMDraftMsgNotification = @"JMDraftMsgNotification";
//删除草稿通知
NSString *const kJMDeleteDraftMsgNotification = @"JMDeleteDraftMsgNotification";
//发送消息后，对方是否成功接收到通知
NSString *const kJMChatSendMsgBackSuccessNotification = @"JMChatSendMsgBackSuccessNotification";

NSString *const kJMXMPPDidFailToSendMessageNotification = @"JMXMPPDidFailToSendMessageNotification";

NSString *const kJMFindBluePeripheralsNotification = @"JMFindBluePeripheralsNotification";
