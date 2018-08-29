//
//  JMXMPPUserDataProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPUserDataProcess.h"
#import "JMTabBarPromptTool.h"
#import "JMReceiveMsgProcess.h"

@implementation JMXMPPUserDataProcess
+ (void)deleteWithJid:(XMPPJID *)jid{
    
    NSString *userID = [JMBaseModel getUserIDWithName:jid.user];
    //删除好友，只是修改状态
    [JMPeopleModel setupPeople:userID type:JMPeopleTypeNoFriend];
    //重新显示人脉的TabBar提示语
    [JMTabBarPromptTool showPeopleItemDot];
    //设置聊天信息为已读，并设置首页的TabBar提示
    [JMReceiveMsgProcess setupTabbarBadgeWithUserID:userID];
    [JMXMPPNotificationUserModel postNotificationWithJid:jid type:JMXMPPNotificationUserModelTypeRemove];
}

+ (JMPeopleModel *)savePeople:(XMPPJID *)jid{
    JMPeopleModel *model = [[JMPeopleModel alloc] initWithJid:jid type:JMPeopleTypeFriend];
    model.vCardTemp = [[JMXMPPTool sharedInstance].vCardTool.vCardModule vCardTempForJID:jid shouldFetch:YES];
    [model bg_saveOrUpdate];
    return model;
}

+ (void)showTabBarPrompt:(XMPPJID *)jid{
    GCDMainQueue(^{
    });
}

@end
