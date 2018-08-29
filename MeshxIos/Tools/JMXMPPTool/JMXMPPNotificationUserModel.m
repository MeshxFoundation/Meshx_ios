//
//  JMXMPPNotificationUserModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/22.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPNotificationUserModel.h"
NSString *const kJMXMPPUserNotification = @"JMXMPPUserNotification";
@implementation JMXMPPNotificationUserModel
+ (void)postNotificationWithJid:(XMPPJID *)jid type:(JMXMPPNotificationUserModelType )type{
    JMXMPPNotificationUserModel *model = [JMXMPPNotificationUserModel new];
    model.jid = jid;
    model.type = type;
    GCDMainQueue(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJMXMPPUserNotification object:model];
    });
}
@end
