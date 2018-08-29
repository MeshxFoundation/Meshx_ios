//
//  JMBaseModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseModel.h"

@implementation JMBaseModel
+ (NSString *)getUserIDWithName:(NSString *)name{
    NSRange range = [name rangeOfString:kJMXMPPLocalhost];
    if (range.length>0) {
        return name;
    }else{
    return  [NSString stringWithFormat:@"%@%@",name,kJMXMPPLocalhost];
    }
}
@end
