//
//  JMDateManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMDateTool.h"

@implementation JMDateTool
+ (NSString *)getCurrentBeijingTimeString{
  
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //东八区，北京时间
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
//    return strDate;
    
    return [self dateToString:[NSDate date]];
}
//+ (NSDate *)getCurrentBeijingTimeDate{
//    
//}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8000"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    //    [dateFormatter release];
    return strDate;
}

+ (NSDate *)stringToDate:(NSString *)strdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *retdate = [dateFormatter dateFromString:strdate];
    //    [dateFormatter release];
    return retdate;
}
+ (NSString *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0900"];//或GMT
    //东八区，北京时间
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    //设置转换后的目标日期时区
    
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    NSString * dateStr = [JMDateTool dateToString:destinationDateNow];
    return dateStr;
    
}
@end
