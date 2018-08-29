//
//  ZJJNetwork.h
//  XiaoMi
//
//  Created by xiaozhu on 16/4/29.
//  Copyright © 2016年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJJNetwork : NSObject

@property (nonatomic ,assign) BOOL isNetwork;

+(instancetype)sharedInstance;

@end
