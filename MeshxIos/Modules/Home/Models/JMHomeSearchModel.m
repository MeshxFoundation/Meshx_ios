//
//  JMHomeSearchModel.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMHomeSearchModel.h"

@implementation JMHomeSearchModel
- (instancetype)initWithTitle:(NSString *)title type:(JMHomeSearchType)type dataArray:(NSArray *)dataArray{
    if (self = [super init]) {
        _title = title;
        _dataArray = dataArray;
        _type = type;
    }
    return self;
}
@end
