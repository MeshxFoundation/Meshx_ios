//
//  JMXMPPUserDataProcess.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMPeopleModel.h"
@interface JMXMPPUserDataProcess : NSObject
//保存好友
+ (JMPeopleModel *)savePeople:(XMPPJID *)jid;
//删除好友
+ (void)deleteWithJid:(XMPPJID *)jid;
+ (void)showTabBarPrompt:(XMPPJID *)jid;
@end
