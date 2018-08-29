//
//  XHDateManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "XHDateManager.h"
#import "NSDate+LSCore.h"

@implementation XHDateManager
+ (NSString *)getTimeWithDate:(NSDate *)date{
 
    /**
     *  10:48
     *
     *
     */
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"HH:mm"];//需转换的格式
    NSString *dateStr = [dateFormater stringFromDate:date];
    //是否是今天
    if ([date isToday]) {
        
        return dateStr;
    }
    //昨天
    if ([date isYesterday]){
        
        return [self getTime:[JMLanguageManager jm_languageYesterday] addTime:dateStr];
//         return [self getTime:@"昨天" addTime:dateStr];
    }
    //本周
    if ([date isThisWeek]) {
        
        //星期天
        if ([date weekday]==1) {
            
            return [self getTime:[JMLanguageManager jm_languageSunday] addTime:dateStr];
//            return [self getTime:@"星期天" addTime:dateStr];
        }
        if ([date weekday] == 2) {
             return [self getTime:[JMLanguageManager jm_languageMonday] addTime:dateStr];
//            return [self getTime:@"星期一" addTime:dateStr];
        }
        if ([date weekday] == 3) {
             return [self getTime:[JMLanguageManager jm_languageTuesday] addTime:dateStr];
//            return [self getTime:@"星期二" addTime:dateStr];
        }
        if ([date weekday] == 4) {
             return [self getTime:[JMLanguageManager jm_languageWednesday] addTime:dateStr];
//             return [self getTime:@"星期三" addTime:dateStr];
        }
        if ([date weekday] == 5) {
             return [self getTime:[JMLanguageManager jm_languageThursday] addTime:dateStr];
//            return [self getTime:@"星期四" addTime:dateStr];
        }
        if ([date weekday] == 6) {
             return [self getTime:[JMLanguageManager jm_languageFriday] addTime:dateStr];
//            return [self getTime:@"星期五" addTime:dateStr];
        }
        if ([date weekday] == 7) {
             return [self getTime:[JMLanguageManager jm_languageSaturday] addTime:dateStr];
//            return [self getTime:@"星期六" addTime:dateStr];
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
                NSString *dateStr1 = [dateFormater stringFromDate:date];
                return [self getTime:dateStr1 addTime:dateStr];
            }
                break;
            case 2:
                return[self getTime:[JMLanguageManager jm_languageMonday] addTime:dateStr];
//                return[self getTime:@"星期一" addTime:dateStr];
                break;
            case 3:
                return[self getTime:[JMLanguageManager jm_languageTuesday] addTime:dateStr];
//                 return[self getTime:@"星期二" addTime:dateStr];
                break;
            case 4:
                return[self getTime:[JMLanguageManager jm_languageWednesday] addTime:dateStr];
//                 return[self getTime:@"星期三" addTime:dateStr];
                break;
            case 5:
                return[self getTime:[JMLanguageManager jm_languageThursday] addTime:dateStr];
//                 return[self getTime:@"星期四" addTime:dateStr];
                break;
            case 6:
                return [self getTime:[JMLanguageManager jm_languageFriday] addTime:dateStr];
//                return [self getTime:@"星期五" addTime:dateStr];
                break;
            case 7:
                return[self getTime:[JMLanguageManager jm_languageSaturday] addTime:dateStr];
//                return[self getTime:@"星期六" addTime:dateStr];
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
        NSString *dateStr1 = [dateFormater stringFromDate:date];
       return [self getTime:dateStr1 addTime:dateStr];
    }
    return nil;
}

+ (NSString *)getTime:(NSString *)time addTime:(NSString *)addTime{
    
    return [NSString stringWithFormat:@"%@ %@",time,addTime];
}

@end
