//
//  JMDAProcess.h
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
//分包发送的最少数据量
static NSInteger const kJMDAMaxLength = 20;
//验证数据完整性，通过MD5加密，取前四位进行比较
static NSInteger const kJMSendMsgMD5HeadLength = 4;

static NSInteger const kJMSendMsgHeadTypeLength = 1;

@interface JMDAProcess : NSObject

/**
 数据拆包，默认长度kJMDAMaxLength，将一个长的数据拆成几段

 @param data 数据源
 @return 拆包后的数据组
 */
+ (NSArray *)disassembleWithData:(NSData *)data;

/**
 数据拆包

 @param data  数据源
 @param length 每段数据长度
 @return 拆包后的数据组
 */
+ (NSArray *)disassembleWithData:(NSData *)data maximumUpdateValueLength:(NSInteger)length;

/**
 数据组装

 @param data 原始数据
 @param addData 在原始数据上在后面添加的数据
 @return 组装数据
 */
+ (NSData *)assemblyWithData:(NSData *)data addData:(NSData *)addData;

/**
 获取数据的第一Byte，转化成数据，0表示只有一条数据，
 1表示分段的第一段数据，2表示分段中间数据，3表示分段的最后数据

 @param data 数据源
 @return 第一Byte数字表示
 */
+ (NSInteger)firstByteWithData:(NSData *)data;

/**
 将接收到组装后到数据，进行处理，得到最终需要数据

 @param data 组装后到数据
 @return 最终数据
 */
+ (NSData *)getContentData:(NSData *)data;

/**
 只有一个数据时，对数据进行处理，得到最终需要数据

 @param data 数据
 @return 最终数据
 */
+ (NSData *)oneData:(NSData *)data;
+ (NSData *)getMD5_4WithData:(NSData *)data;
@end
