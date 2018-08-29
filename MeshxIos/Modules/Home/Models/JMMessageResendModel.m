//
//  JMMessageResendModel.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/8/1.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMMessageResendModel.h"

@implementation JMMessageResendModel
- (instancetype)initWithMessage:(XHMessage *)message process:(JJTransportProcess *)process homeModel:(JMHomeModel *)homeModel{
    if (self = [super init]) {
        _message = message;
        _process = process;
        _homeModel = homeModel;
    }
    return self;
}
@end
