//
//  JMXMPPSendMsgProcess.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMHomeModel.h"

@interface JMXMPPSendMsgProcess : NSObject
+ (void)sendTextWithProcess:(JJTransportProcess *)process model:(JMHomeModel *)model;
@end
