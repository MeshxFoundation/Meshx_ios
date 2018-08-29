//
//  JMXMPPReceiveMsgProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPReceiveMsgProcess.h"

@implementation JMXMPPReceiveMsgProcess
+ (void)dealReceiveMsg:(XMPPMessage *)message{
    
    if ([message.type isEqualToString:kJMXMPPMessageType] &&message.body) {
        //说明是离线消息
        if (message.delayedDeliveryDate) {
            [self dealMessage:message];
        }else{
           //在线消息
            [self dealMessage:message];
        }
        
    }
    
}

+ (void)dealMessage:(XMPPMessage *)message{
    NSDictionary *dic = [message.body jsonValueDecoded];
    JJTransportProcess *process = [JJTransportProcess new];
    process.type = dic[@"type"];
    process.msg = dic;
    MCSessionModel *model = [MCSessionModel new];
    model.jid = [JMXMPPUserManager getJidWithName:dic[@"userName"]];
    model.receiveDataType = JMReceiveDataTypeXMPP;
    model.process = process;
    GCDMainQueue(^{
         [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:model];
    });
   
}


@end
