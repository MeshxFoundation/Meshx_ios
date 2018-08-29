//
//  JMMyInfo.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/21.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPvCardTemp.h"

@interface JMMyInfo : JMBaseModel

+ (NSString *)name;
+ (NSString *)userID;
+ (XMPPJID *)jid;
+ (UIImage *)headerImage;
+ (XMPPvCardTemp *)myCard;
//性别
+ (NSString *)gender;
//是否是男
+ (BOOL)isMale;
#pragma mark - 单用户操作 userInfo.plist
+ (void)saveToFile;/**< 保存用户数据 */
+ (instancetype)readUserInfo;/**< 读取用户数据 */
+ (void)deleteUserInfo;/**< 删除用户数据 */

@end
