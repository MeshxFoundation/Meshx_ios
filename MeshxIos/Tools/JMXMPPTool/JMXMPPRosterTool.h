//
//  JMXMPPRosterTool.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/20.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "JMXMPPNotificationUserModel.h"
#import "JMXMPPUserManager.h"
typedef NS_ENUM(NSInteger, JMXMPPRosterToolPopulatingType) {
    JMXMPPRosterToolPopulatingTypeNormal = 0,
    JMXMPPRosterToolPopulatingTypeBegin,//好友类别开始同步
    JMXMPPRosterToolPopulatingTypeDo,//正在接受好友列表数据
    JMXMPPRosterToolPopulatingTypeEnd,//已经接受全部的好友数据
};
@interface JMXMPPRosterTool : NSObject<XMPPRosterMemoryStorageDelegate>

@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;
//获取花名册的状态
@property (nonatomic ,assign) JMXMPPRosterToolPopulatingType rosterType;
@property (nonatomic ,strong) NSMutableArray *rosterDataSource;
/**
 获取在线好友
 
 @return 在线好友
 */
- (NSArray <XMPPUserMemoryStorageObject *>*)allAvailableFriends;
/**
 获取离线好友
 
 @return 离线好友
 */
- (NSArray <XMPPUserMemoryStorageObject *>*)allUnavailableFriends;
/**
 判断用户是否在线
 
 @param jid 用户
 @return 是否在线
 */
- (BOOL)isAvailableWithJid:(XMPPJID *)jid;
- (void)clearData;
@end
