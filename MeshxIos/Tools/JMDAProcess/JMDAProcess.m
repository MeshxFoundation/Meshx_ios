//
//  JMDAProcess.m
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import "JMDAProcess.h"
#import "RHSocketUtils.h"




@implementation JMDAProcess

+ (NSArray *)disassembleWithData:(NSData *)data{
    NSLog(@"==发送的信息======%@========%ld",data,data.length);
    return [self disassembleWithData:data maximumUpdateValueLength:kJMDAMaxLength];
}

/**
 数据拆包，拆包思路：
 1、只有一条数据时：第一个Byte用来存储数字0，
 后面四个Byte用来存储整条数据经过MD5加密后的前四个Byte。
 2、分段拆包，一共分三段标识，第一段：第一个Byte用来存储数字1，
 后面四个Byte用来存储整条数据经过MD5加密后的前四个Byte，
 第二段（中间数据）第一个Byte用来存储数字2，第三段（最后一段，表示这个数据结束）第一个Byte用来存储数字3
 @param data  数据源
 @param length 每段数据长度
 @return 拆包后的数据组
 */
+ (NSArray *)disassembleWithData:(NSData *)data maximumUpdateValueLength:(NSInteger)length{
    
    if (!data.length) {
        return nil;
    }
    if (length > kJMDAMaxLength) {
        length = length-3;
    }else{
        length = kJMDAMaxLength;
    }
//    length = kJMDAMaxLength;
   
    if (data.length < length-kJMSendMsgMD5HeadLength) {
        return @[[self oneData:data headerType:0]];
    }
    NSInteger nowLength = length-kJMSendMsgHeadTypeLength;
    NSMutableArray *disArray = [NSMutableArray array];
    NSInteger headLength = nowLength-kJMSendMsgMD5HeadLength;
    NSMutableData *muData = [NSMutableData data];
    NSInteger headerType = 1;
    [muData appendBytes:&headerType length:kJMSendMsgHeadTypeLength];
    [muData appendData:[self getMD5_4WithData:data]];
    NSData *firstData = [data subdataWithRange:NSMakeRange(0, headLength)];
    [muData appendData:firstData];
    [disArray addObject:muData];
    
    NSData *lastData = [data subdataWithRange:NSMakeRange(headLength, data.length-headLength)];
    //向上取整
    NSInteger count = (NSInteger)ceilf((float)lastData.length/nowLength);
    
    NSInteger index = 0;
    for (int i = 0; i < count; i++) {
        NSMutableData *muData = [NSMutableData data];
      if (i == count-1) {
            NSInteger headerType = 3;
            [muData appendBytes:&headerType length:kJMSendMsgHeadTypeLength];
        }else{
            NSInteger headerType = 2;
            [muData appendBytes:&headerType length:kJMSendMsgHeadTypeLength];
        }
        NSInteger length = nowLength;
        if (i == count-1) {
            length = lastData.length - index;
        }
        NSData *subData = [lastData subdataWithRange:NSMakeRange(index, length)];
        [muData appendData:subData];
        [disArray addObject:muData];
        index = nowLength*(i+1);
    }
    return disArray;
}



+ (NSData *)assemblyWithData:(NSData *)data addData:(NSData *)addData{
    NSMutableData *muData = [[NSMutableData alloc] initWithData:data];
    if (addData.length>1) {
        NSData *contentData = [addData subdataWithRange:NSMakeRange(kJMSendMsgHeadTypeLength, addData.length-kJMSendMsgHeadTypeLength)];
        [muData appendData:contentData];
    }
    return muData;
}

+ (NSData *)oneData:(NSData *)data headerType:(NSInteger)type{
    
    NSMutableData *muData = [NSMutableData data];
    NSInteger headerType = type;
    [muData appendBytes:&headerType length:kJMSendMsgHeadTypeLength];
    [muData appendData:[self getMD5_4WithData:data]];
    [muData appendData:data];
    return muData;
}

+ (NSData *)getMD5_4WithData:(NSData *)data{
    
    NSMutableData *md5_4Data = [NSMutableData data];
    Byte bytes[4];
    NSString *string = [data md5String];
    NSString *subStr = [string substringWithRange:NSMakeRange(8, 4)];
    for (int i = 0; i < [subStr length]; i ++) {
      unichar charc = [subStr characterAtIndex:i];
        bytes[i] = charc;
    }
    [md5_4Data appendBytes:bytes length:4];
//    NSData *md5_4_Data= [[data md5Data] subdataWithRange:NSMakeRange(8, kJMSendMsgMD5HeadLength)];
    return md5_4Data;
}

+ (NSInteger)firstByteWithData:(NSData *)data{
    
    NSUInteger length = 2;
    NSData *lengthData = [data subdataWithRange:NSMakeRange(0, 1)];
    length = [RHSocketUtils int8FromBytes:lengthData];
    return length;
}

+ (NSData *)getContentData:(NSData *)data{
    NSInteger headLength = kJMSendMsgHeadTypeLength+kJMSendMsgMD5HeadLength;
    if (data.length>headLength) {
        NSData *contentData = [data subdataWithRange:NSMakeRange(headLength, data.length-headLength)];
        return contentData;
    }else{
        return nil;
    }
}


@end
