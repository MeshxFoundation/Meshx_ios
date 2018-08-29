//
//  SAMKeychain.m
//  SAMKeychain
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright (c) 2010-2014 Sam Soffes. All rights reserved.
//

#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"

NSString *const kSAMKeychainErrorDomain = @"com.samsoffes.samkeychain";
NSString *const kSAMKeychainAccountKey = @"acct";
NSString *const kSAMKeychainCreatedAtKey = @"cdat";
NSString *const kSAMKeychainClassKey = @"labl";
NSString *const kSAMKeychainDescriptionKey = @"desc";
NSString *const kSAMKeychainLabelKey = @"labl";
NSString *const kSAMKeychainLastModifiedKey = @"mdat";
NSString *const kSAMKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
static CFTypeRef SAMKeychainAccessibilityType = NULL;
#endif

@implementation SAMKeychain

+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordForService:serviceName account:account error:nil];
}


+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    return query.password;
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordDataForService:serviceName account:account error:nil];
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    
    return query.passwordData;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    return [query deleteItem:error];
}


/**
 设置或更改用户密码

 @param password 密码
 @param serviceName 一般使用bunderID
 @param account 帐号
 */
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.password = password;
    return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPasswordData:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.passwordData = password;
    return [query save:error];
}

+ (nullable NSArray *)allAccounts {
    return [self allAccounts:nil];
}


+ (nullable NSArray *)allAccounts:(NSError *__autoreleasing *)error {
    return [self accountsForService:nil error:error];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName {
    return [self accountsForService:serviceName error:nil];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error {
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = serviceName;
    return [query fetchAll:error];
}

/**
 原来的allAccounts方法返回的是字典，包含修改时间等信息，为方便使用，在些基础上封装直接返回用户名数组
 
 @return 用户名数组（根据时间排列）
 */

+ (NSArray<NSString *> *)allAccountsNames{
    
    NSMutableArray *nameArray = [NSMutableArray array];
    
    for (NSDictionary *accountDict in [SAMKeychain sortUsrArray:[SAMKeychain accountsForService:kBundleIdentifier]]) {
        //上面方法拿到的只是一个字典
        [nameArray addObject:accountDict[kSAMKeychainAccountKey]];
    }
    return nameArray;
}

/**
 最后一次登录用户的用户名
 */
+ (NSString *)LastLoginName{
    
    //时间排序
    NSMutableArray * userSortArray =[SAMKeychain sortUsrArray:[SAMKeychain accountsForService:kBundleIdentifier]];
    if ([userSortArray.firstObject[kSAMKeychainAccountKey] length] < 1) {
        return @"";
    }
    return userSortArray.firstObject[kSAMKeychainAccountKey];
}

/**< 根据登录时间排序 */
+ (NSMutableArray *)sortUsrArray:(NSArray *)soureceArray
{
    NSArray *outputArray = [soureceArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return  [obj1[kSAMKeychainLastModifiedKey] compare:obj2[kSAMKeychainLastModifiedKey]];
        
    }];
    NSMutableArray *reverseArray = [NSMutableArray arrayWithArray:outputArray];
//    [reverseArray sortReverse];
    return reverseArray;
}

#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
    return SAMKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    CFRetain(accessibilityType);
    if (SAMKeychainAccessibilityType) {
        CFRelease(SAMKeychainAccessibilityType);
    }
    SAMKeychainAccessibilityType = accessibilityType;
}
#endif

@end
