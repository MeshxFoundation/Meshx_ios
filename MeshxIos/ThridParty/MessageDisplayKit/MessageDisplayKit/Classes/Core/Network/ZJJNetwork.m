//
//  ZJJNetwork.m
//  XiaoMi
//
//  Created by xiaozhu on 16/4/29.
//  Copyright © 2016年 xiaozhu. All rights reserved.
//

#import "ZJJNetwork.h"

@implementation ZJJNetwork

+(instancetype)sharedInstance{
    
    
    static ZJJNetwork *network = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        network = [[ZJJNetwork alloc] init];
        
    });
    
    return network;
}

- (id)init{

    if (self = [super init]) {
        
        _isNetwork = YES;
    }
    return self;
}

@end
