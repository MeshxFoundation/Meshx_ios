//
//  MCPeerID+JJAdd.m
//  MCDemo
//
//  Created by JMZiXun on 2018/4/4.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "MCPeerID+JJAdd.h"
#define JJDeviceIdentifierForVendorUUID [UIDevice currentDevice].identifierForVendor.UUIDString
static NSString *const JJMCPeerIntervalString = @"8--**--8";
@implementation MCPeerID (JJAdd)
+ (NSString *)jj_UUIDDisplayName{
    
    return [NSString stringWithFormat:@"%@%@%@",[JMMyInfo name],JJMCPeerIntervalString,[JMMyInfo name]];
}
- (NSString *)jj_UUID{
    
    NSArray *arr = [self.displayName componentsSeparatedByString:JJMCPeerIntervalString];
    return arr.firstObject;
}
- (NSString *)jj_displayName{
    NSArray *arr = [self.displayName componentsSeparatedByString:JJMCPeerIntervalString];
    return arr.lastObject;
}
@end
