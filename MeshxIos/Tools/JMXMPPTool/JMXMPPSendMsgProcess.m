//
//  JMXMPPSendMsgProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPSendMsgProcess.h"

@implementation JMXMPPSendMsgProcess
+ (void)sendTextWithProcess:(JJTransportProcess *)process model:(JMHomeModel *)model{
    
     XMPPMessage *message = [XMPPMessage messageWithType:kJMXMPPMessageType to:[JMXMPPUserManager getJidWithName:model.name]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:process.msg];
    NSString *sendText = [dic jsonStringEncoded];
    //要发送的消息添加到Body
    [message addBody:sendText];
    //发送消息
    [[JMXMPPTool sharedInstance].xmppStream sendElement:message];
}



@end
