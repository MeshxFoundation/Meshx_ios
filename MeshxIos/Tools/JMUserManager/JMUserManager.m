//
//  JMUserManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/21.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMUserManager.h"
#import "SAMKeychain.h"

static NSString *const kJMCurrentUserName = @"JMCurrentUserName";

@implementation JMUserManager
MJExtensionCodingImplementation

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JMUserManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#pragma mark - *** 多用户操作 *** -
/**< 向表中添加用户 */
+ (void)addUserWithName:(NSString *)name pwd:(NSString *)pwd
{
    if (!name.length) {
        return;
    }
    if (pwd == nil) pwd = @"";
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kJMCurrentUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //Service 获取指定ID的pwd
    [SAMKeychain setPassword:pwd forService:kBundleIdentifier account:name];
    
}

/**< 多用户表中删除用户 */
+ (void)deleteUser:(NSDictionary *)user
{
    //删除
    [SAMKeychain deletePasswordForService:kBundleIdentifier account:user[@"name"]];
}

+ (NSArray *)getAllUserNames
{
    return [SAMKeychain allAccountsNames];
}

//封装用户字典，供登录使用
+ (NSMutableArray *)getAllUsers
{
    
    NSMutableArray *dict = [NSMutableArray array];
    for (NSString *account in [JMUserManager getAllUserNames]) {
        [dict addObject:@{@"name":account,@"pwd":[SAMKeychain passwordForService:kBundleIdentifier account:account]}];
    }
    return dict;
}

/**< 获取最近登录的用户 */
+ (NSDictionary *)getLastUser
{
    if([SAMKeychain LastLoginName].length > 0){
        return @{@"name":[SAMKeychain LastLoginName],@"pwd":[SAMKeychain passwordForService:kBundleIdentifier account:[SAMKeychain LastLoginName]]};
    }else{
        return @{@"name":@"",@"pwd":@""};
    }
}

+ (NSString *)getLastUserName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJMCurrentUserName];
}

+ (NSString *)getPasswordWithUserName:(NSString *)userName{
    if (userName.length>0) {
       return [SAMKeychain passwordForService:kBundleIdentifier account:userName];
    }
    return nil;
}

@end
