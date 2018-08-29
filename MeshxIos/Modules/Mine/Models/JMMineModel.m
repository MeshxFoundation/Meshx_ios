//
//  JMMineModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/6.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMineModel.h"

@implementation JMMineModel
- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon{
    if (self = [super init]) {
        _name = name;
        _icon = icon;
    }
    return self;
}
@end
