//
//  JMUserManager.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/21.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMUserManager : NSObject
+ (instancetype)sharedInstance;/**< 单例 */

#pragma mark - 多用户操作 user.plist
//@"name"用户名 @"pwd"密码
/**
 *  @brief 登录成功，保存用户
 */
+ (void)addUserWithName:(NSString *)name pwd:(NSString *)pwd;

/**< 删除指定帐号 */
+ (void)deleteUser:(NSDictionary *)user;

/**< 获取所有的用户 */
+ (NSMutableArray *)getAllUsers;

/**< 获取所有用户名 */
+ (NSArray *)getAllUserNames;

/**< 获取最近登录的用户 */
+ (NSDictionary *)getLastUser;
+ (NSString *)getLastUserName;
+ (NSString *)getPasswordWithUserName:(NSString *)userName;

@end
