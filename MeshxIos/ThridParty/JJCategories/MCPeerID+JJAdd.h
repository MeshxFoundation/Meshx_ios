//
//  MCPeerID+JJAdd.h
//  MCDemo
//
//  Created by JMZiXun on 2018/4/4.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#define JJDeviceIdentifierForVendorUUID [UIDevice currentDevice].identifierForVendor.UUIDString

@interface MCPeerID (JJAdd)
+ (NSString *)jj_UUIDDisplayName;
- (NSString *)jj_UUID;
- (NSString *)jj_displayName;
@end
