//
//  JMEventIDManager.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMEventIDManager.h"

static NSString *const kJMEventIDIntervalSymbols=@"$";

@implementation JMEventIDManager


+ (NSString *)getEventIDWithDate:(NSDate *)date{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    //事件ID
     NSString *eventID = [NSString stringWithFormat:@"%@%@%.0f",[JMMyInfo userID],kJMEventIDIntervalSymbols,timeInterval];
    return eventID;
}

+ (NSString *)getTimeStampWithEventID:(NSString *)eventID{
    NSArray *array = [eventID componentsSeparatedByString:kJMEventIDIntervalSymbols];
    return array.lastObject;
}

@end
