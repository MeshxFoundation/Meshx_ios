//
//  JMPeopleModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMPeopleModel.h"

@implementation JMPeopleModel

- (void)setJid:(XMPPJID *)jid{
    [super setJid:jid];
    _name = jid.user;
}

- (instancetype)initWithJid:(XMPPJID *)jid type:(JMPeopleType)type{
    if (self = [super init]) {
        [self setJid:jid];
        _type = type;
    }
    return self;
}

/**
 如果需要指定“唯一约束”字段,就实现该函数,这里指定 userID为“唯一约束”.
 */
+(NSArray *)bg_uniqueKeys{
    return @[@"userID"];
}

+ (void)updatePeople:(JMPeopleModel *)model type:(JMPeopleType)type{
    
    NSString *where = [NSString stringWithFormat:@"set %@ = %@ where %@ = %@",bg_sqlKey(@"type"),bg_sqlValue(@(type)),bg_sqlKey(@"userID"),bg_sqlValue(model.userID)];
    [JMPeopleModel bg_update:nil where:where];
    [model bg_coverAsync:^(BOOL isSuccess) {
        
    }];
}

+ (void)setupPeople:(NSString *)userID type:(JMPeopleType)type{
    NSString *where = [NSString stringWithFormat:@"set %@ = %@ where %@ = %@",bg_sqlKey(@"type"),bg_sqlValue(@(type)),bg_sqlKey(@"userID"),bg_sqlValue(userID)];
    [JMPeopleModel bg_update:nil where:where];
}

+ (NSArray *)findAllFriend{
     NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"type"),bg_sqlValue(@(1))];
    return [JMPeopleModel bg_find:nil where:where];
}

/**
 删除全部好友
 
 @return 是否删除成功
 */
+ (BOOL)deleteAllFriend{
    NSString *where = [NSString stringWithFormat:@"set %@ = %@",bg_sqlKey(@"type"),bg_sqlValue(@(0))];
   return [JMPeopleModel bg_update:nil where:where];
}

+ (JMPeopleModel *)findFriendWithUserID:(NSString *)userID{
     NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ = %@",bg_sqlKey(@"userID"),bg_sqlValue(userID),bg_sqlKey(@"type"),bg_sqlValue(@(1))];
    return [JMPeopleModel bg_find:nil where:where].firstObject;
}

+ (JMPeopleModel *)findPeopleWithUserID:(NSString *)userID{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"userID"),bg_sqlValue(userID)];
    return [JMPeopleModel bg_find:nil where:where].firstObject;
}

@end
