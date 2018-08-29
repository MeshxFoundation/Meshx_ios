//
//  JJTransportEncoder.m
//  MCDemo
//
//  Created by JMZiXun on 2018/5/15.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JJTransportEncoder.h"
#import "JJTransportProcess.h"

@implementation JJTransportEncoder

+ (NSData *)didEncodeWithProcess:(JJTransportProcess *)process{
    NSMutableData *sendData = [[NSMutableData alloc] init];
    if (process.fileData) {
        [sendData appendData:[self fileUploadWithMsgType:process.type fileData:process.fileData msg:process.msg ]];
    }else{
        [sendData appendData:[self encodeWithMsgType:process.type msg:process.msg]];
    }
    return sendData;
}



+(NSMutableData *)encodeWithMsgType:(NSString *)msgType msg:(NSDictionary *)msg {
    
    if (msg == nil) {
        msg = @{@"type":msgType};
    }
    NSMutableData *mubytes = [NSMutableData data];
    NSData *msgTypeData = [msgType dataUsingEncoding:NSUTF8StringEncoding];
    Byte *msgTypeByte = (Byte *)[msgTypeData bytes];
    NSInteger msgTypeLength = msgTypeData.length;
    [mubytes appendBytes:&msgTypeLength length:1];
    for (int i=0 ; i<msgTypeLength; i++) {
        
        [mubytes appendBytes:&msgTypeByte[i] length:1];
    }
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strservicecontent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *datacontent = [strservicecontent dataUsingEncoding:NSUTF8StringEncoding];
    Byte *contentByte = (Byte *)[datacontent bytes];
    int  lengthcontent = CFSwapInt32HostToBig((int)[datacontent length]);
    [mubytes appendBytes:&lengthcontent length:4];
    for (int i=0 ; i<[datacontent length]; i++) {
        
        [mubytes appendBytes:&contentByte[i] length:1];
    }
    return mubytes;
}

+ (NSData *)fileUploadWithMsgType:(NSString *)msgType fileData:(NSData *)fileData msg:(NSDictionary *)msg{
    
    NSMutableData *mubytes = [self encodeWithMsgType:msgType msg:msg];
    [mubytes appendData:fileData];
    return mubytes;
}

@end
