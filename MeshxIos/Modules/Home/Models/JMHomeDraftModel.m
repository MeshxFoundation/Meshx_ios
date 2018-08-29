//
//  JMHomeDraftModel.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/25.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMHomeDraftModel.h"

@implementation JMHomeDraftModel
- (instancetype)initWithText:(NSString *)text timestamp:(NSDate *)timestamp{
    if (self = [super init]) {
        _text = text;
        _timestamp = timestamp;
    }
    return self;
}
@end
