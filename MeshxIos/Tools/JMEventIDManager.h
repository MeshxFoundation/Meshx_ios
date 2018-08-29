//
//  JMEventIDManager.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMEventIDManager : NSObject
+ (NSString *)getEventIDWithDate:(NSDate *)date;
+ (NSString *)getTimeStampWithEventID:(NSString *)eventID;
@end
