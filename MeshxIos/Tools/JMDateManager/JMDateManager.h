//
//  JMDateManager.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/25.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+LSCore.h"
@interface JMDateManager : NSObject
/**
 *
 *
 *  @param time 给定的日期字符串：@“yyyy-MM-dd HH:mm:ss” 或者Date
 *
 *  @return 得到 ／今天／昨天／星期几字符串
 */

+(NSString *)getStringTime:(id)time;

/**
 *
 *
 *  @param string 给定的日期字符串：@“yyyy-MM-dd HH:mm:ss”
 *
 *  @return 转换过的日期
 */
+(NSDate *)dateFromString:(NSString *)string;



/**
 *
 *
 *  @param date 给定的日期
 *
 *  @return 得到日期字符串：@“yyyy-MM-dd HH:mm:ss”
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 返回时间年月日
 
 @param date 给定的日期
 @return 得到日期字符串：@“yyyy-MM-dd”
 */
+ (NSString *)stringYYYYMMddFrameDate:(NSDate *)date;

/**
 
 @param date 给定的日期
 @return 得到日期字符串：@“HH:mm:ss”
 */
+ (NSString *)stringHHMMSSFrameDate:(NSDate *)date;

+ (NSInteger)getTimetampsWithDate:(NSDate *)date;

@end
