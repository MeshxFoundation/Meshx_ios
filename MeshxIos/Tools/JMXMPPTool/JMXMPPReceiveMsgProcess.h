//
//  JMXMPPReceiveMsgProcess.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMXMPPReceiveMsgProcess : NSObject
+ (void)dealReceiveMsg:(XMPPMessage *)message;
@end
