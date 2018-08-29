//
//  JMDateManager.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/25.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMDateManager.h"

@implementation JMDateManager
/**
 *
 *
 *  @param time 给定的日期字符串：@“yyyy-MM-dd HH:mm:ss” 或者Date
 *
 *  @return 得到 ／今天／昨天／星期几字符串
 */

+(NSString *)getStringTime:(id)time{
    
    if (!time) {
        return nil;
    }
    NSDate *date = nil;
    if ([time isKindOfClass:[NSString class]]) {
        date = [self dateFromString:time];
    }else if ([time isKindOfClass:[NSDate class]]){
        date = time;
    }else{
        return nil;
    }
    
    //是否是今天
    if ([date isToday]) {
        
        /**
         *  10:48
         *
         *
         */
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"HH:mm"];//需转换的格式
        NSString *dateStr = [dateFormater stringFromDate:date];
        return dateStr;
    }
    //昨天
    if ([date isYesterday]){
        
//        return @"昨天";
        return [JMLanguageManager jm_languageYesterday];
    }
    //本周
    if ([date isThisWeek]) {
        
        //星期天
        if ([date weekday]==1) {
            
            return [JMLanguageManager jm_languageSunday];
//             return @"星期天";
        }
        if ([date weekday] == 2) {
            
            return [JMLanguageManager jm_languageMonday];
//            return @"星期一";
        }
        if ([date weekday] == 3) {
            
            return [JMLanguageManager jm_languageTuesday];
//            return @"星期二";
        }
        if ([date weekday] == 4) {
            
            return [JMLanguageManager jm_languageWednesday];
//             return @"星期三";
        }
        if ([date weekday] == 5) {
            
            return [JMLanguageManager jm_languageThursday];
//            return @"星期四";
        }
        if ([date weekday] == 6) {
            
            return [JMLanguageManager jm_languageFriday];
//            return @"星期五";
        }
        if ([date weekday] == 7) {
            
            return [JMLanguageManager jm_languageSaturday];
//             return @"星期六";
        }
    }
    //上一周
    if ([date isLastWeek]) {
        
        NSLog(@"====%ld===",[date weekday]);
        switch ([date weekday]) {
                
            case 1:{
                
                /**
                 *  2016/05/05
                 *
                 */
                
                NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
                [dateFormater setDateFormat:@"yyyy/MM/dd"];//需转换的格式
                NSString *dateStr = [dateFormater stringFromDate:date];
                return dateStr;
            }
                break;
            case 2:
                return [JMLanguageManager jm_languageMonday];
//                return @"星期一";
                break;
            case 3:
                return [JMLanguageManager jm_languageTuesday];
//                return @"星期二";
                break;
            case 4:
                return [JMLanguageManager jm_languageWednesday];
//                return @"星期三";
                break;
            case 5:
                return [JMLanguageManager jm_languageThursday];
//                return @"星期四";
                break;
            case 6:
                return [JMLanguageManager jm_languageFriday];
//                return @"星期五";
                break;
            case 7:
                return [JMLanguageManager jm_languageSaturday];
//                return @"星期六";
                break;
                
                
            default:
                break;
        }
        
    }else{
        
        /**
         *  2016/05/05
         *
         */
        
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy/MM/dd"];//需转换的格式
        NSString *dateStr = [dateFormater stringFromDate:date];
        return dateStr;
    }
    return nil;
}

/**
 *
 *
 *  @param string 给定的日期字符串：@“yyyy-MM-dd HH:mm:ss”
 *
 *  @return 转换过的日期
 */
+(NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}



/**
 *
 *
 *  @param date 给定的日期
 *
 *  @return 得到日期字符串：@“yyyy-MM-dd HH:mm:ss”
 */
+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/**
 返回时间年月日
 
 @param date 给定的日期
 @return 得到日期字符串：@“yyyy-MM-dd”
 */
+ (NSString *)stringYYYYMMddFrameDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

/**
 
 @param date 给定的日期
 @return 得到日期字符串：@“HH:mm:ss”
 */
+ (NSString *)stringHHMMSSFrameDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSInteger)getTimetampsWithDate:(NSDate *)date{
    return [date timeIntervalSince1970];
}

@end
