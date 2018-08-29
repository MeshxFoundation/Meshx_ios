//
//  JMXMPPUserManager.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/25.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMXMPPUserManager : NSObject

+ (XMPPJID *)getJidWithName:(NSString *)name;
+ (XMPPJID *)getJidWithUserID:(NSString *)userID;
+ (void)addFriend:(NSString *)friendName;
+ (void)deleteFriend:(NSString *)friendName;

//agree
@end
