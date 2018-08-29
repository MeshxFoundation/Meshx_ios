//
//  JMHomeSearchChatModel.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMHomeSearchChatModel.h"

@implementation JMHomeSearchChatModel
- (instancetype)initWithUserID:(NSString *)userID messages:(NSArray<XHMessage *>*)messages{
    if (self = [super init]) {
        _userID = userID;
        NSArray *arr = [userID componentsSeparatedByString:kJMXMPPLocalhost];
        _name = arr.firstObject;
        _messages = messages;
    }
    return self;
}

@end
