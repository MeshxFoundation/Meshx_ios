//
//  JMPeopleModel.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseModel.h"
#import "BGFMDB.h"
#import "JMBaseUserModel.h"
@class JMPeopleModel;
typedef NS_ENUM(NSInteger, JMPeopleType) {
    JMPeopleTypeNoFriend = 0,//非好友
    JMPeopleTypeFriend,//好友
};
@interface JMPeopleModel : JMBaseUserModel
@property (nonatomic ,strong) NSString *name;
//0、表示非好友，1、表示好友
@property (nonatomic ,assign) JMPeopleType type;

@property (nonatomic ,strong) XMPPvCardTemp *vCardTemp;

- (instancetype)initWithJid:(XMPPJID *)jid type:(JMPeopleType)type;

/**
 转变用户角色
 type：0表示非用户，1表示好友
 @param userID 用户ID
 @param type 用户标记
 */
+ (void)setupPeople:(NSString *)userID type:(JMPeopleType)type;

/**
 查询所有的好友

 @return 好友数据
 */
+ (NSArray *)findAllFriend;

/**
 删除全部好友

 @return 是否删除成功
 */
+ (BOOL)deleteAllFriend;

/**
 查询单个好友

 @param userID 好友名字
 @return 好友
 */
+ (JMPeopleModel *)findFriendWithUserID:(NSString *)userID;

/**
 查询当个用户，可以是好友，也可以是非好友

 @param userID 用户ID
 @return 用户
 */
+ (JMPeopleModel *)findPeopleWithUserID:(NSString *)userID;

@end
