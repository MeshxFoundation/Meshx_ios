//
//  JJTransportDecoder.h
//  MCDemo
//
//  Created by JMZiXun on 2018/5/15.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JJTransportProcess.h"
@class JJTransportProcess;


@interface JJTransportDecoder : NSObject

+ (JJTransportProcess *)decoderWithData:(NSData *)data;

@end
