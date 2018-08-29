//
//  JMChatSendMsgBackProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/3.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMChatSendMsgBackProcess.h"
#import "JMChatUpdateMsgProcess.h"
#import "JMBLSendMsgProcess.h"

@implementation JMChatSendMsgBackProcess
- (instancetype)init{
    if ([super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionReceiveData:) name:kMCSessionReceiveDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToSendMessage:) name:kJMXMPPDidFailToSendMessageNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToSendMessage:) name:kJMBLSendMsgFailNotification object:nil];
        
    }
    return self;
}

- (void)sessionReceiveData:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    if ([sessionModel.process.type isEqualToString:kJMChatMsgBackAPI]) {
        NSString *userID = sessionModel.process.msg[@"userID"];
        if ([userID isEqualToString:[JMMyInfo userID]]) {
            NSString *eventID = sessionModel.process.msg[@"eventID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJMChatSendMsgBackSuccessNotification object:eventID];
            [JMChatUpdateMsgProcess updateSqlMsgWithEventID:eventID isNetwork:1];
        }
    }
}

- (void)didFailToSendMessage:(NSNotification *)not{
    NSString *eventID = not.object;
    //设置为发送失败
   [JMChatUpdateMsgProcess updateSqlMsgWithEventID:eventID isNetwork:2];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
