//
//  JJTransportDecoder.m
//  MCDemo
//
//  Created by JMZiXun on 2018/5/15.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JJTransportDecoder.h"
#import "RHSocketUtils.h"
#import "JJTransportProcess.h"
@implementation JJTransportDecoder

+ (JJTransportProcess *)decoderWithData:(NSData *)data{
    
    JJTransportProcess *process = [JJTransportProcess new];
    //要取服务类型
    NSData *serviceTypeLengthData = [data subdataWithRange:NSMakeRange(0, 1)];
    //取服务类型的长度
    NSUInteger serviceTypeLength = [RHSocketUtils int8FromBytes:serviceTypeLengthData];
    
    NSData *serviceTypeData = [data subdataWithRange:NSMakeRange(1, serviceTypeLength) ];
    
    NSString *serviceTypeStr = [[NSString alloc] initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
    
    NSLog(@"===========serviceType:%@=======",serviceTypeStr);
    //===================主体处理＝＝＝＝＝＝＝＝＝＝＝＝
    
    NSData *serviceContentLengthData = [data subdataWithRange:NSMakeRange(1+serviceTypeLength, 4)];
    int serviceContentLength = CFSwapInt32BigToHost(*(int*)([serviceContentLengthData bytes]));
    NSData *serviceContentData = [data subdataWithRange:NSMakeRange(5+serviceTypeLength, serviceContentLength)];
    NSDictionary *msg = [NSJSONSerialization JSONObjectWithData:serviceContentData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"===========msg:%@=======",msg);
    process.type = serviceTypeStr;
    process.msg = msg;
 
    if ([kJMChatMsgFileAPI isEqualToString:process.type]) {
        NSInteger fileLengthIndex = 5+serviceTypeLength+serviceContentLength;
        //文件内容
        NSData *fileData = [data subdataWithRange:NSMakeRange(fileLengthIndex, data.length-fileLengthIndex)];
        process.fileData = fileData;
    }
    return process;
}

@end
