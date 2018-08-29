//
//  JJTransportEncoder.h
//  MCDemo
//
//  Created by JMZiXun on 2018/5/15.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJTransportProcess;
@interface JJTransportEncoder : NSObject
+ (NSData *)didEncodeWithProcess:(JJTransportProcess *)process;
@end
