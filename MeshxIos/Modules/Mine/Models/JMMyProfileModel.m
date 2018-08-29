//
//  JMMyProfileModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/10.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMyProfileModel.h"

@implementation JMMyProfileModel
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon{
    if (self = [super init]) {
        _name = nil;
        _icon = icon;
        _title = title;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name{
    if (self = [super init]) {
        _name = name;
        _icon = nil;
        _title = title;
    }
    return self;
}

@end
