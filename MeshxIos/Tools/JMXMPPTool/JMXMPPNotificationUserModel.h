//
//  JMXMPPNotificationUserModel.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/22.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kJMXMPPUserNotification;

typedef NS_ENUM(NSInteger, JMXMPPNotificationUserModelType) {
    JMXMPPNotificationUserModelTypeNormal = 0,
    JMXMPPNotificationUserModelTypeAdd,//表示添加
    JMXMPPNotificationUserModelTypeRemove, //表示移除
    JMXMPPNotificationUserModelTypeFail, //链接失败
    JMXMPPNotificationUserModelTypeAvailable,//在线好友
    JMXMPPNotificationUserModelTypeUnavailable,//离线好友
};
@interface JMXMPPNotificationUserModel : NSObject

@property (nonatomic ,strong) XMPPJID *jid;
@property (nonatomic ,assign) JMXMPPNotificationUserModelType type;
+ (void)postNotificationWithJid:(XMPPJID *)jid type:(JMXMPPNotificationUserModelType)type;
@end
