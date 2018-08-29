//
//  JMChatUpdateMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/24.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatUpdateMsgProcess.h"

@implementation JMChatUpdateMsgProcess
+ (void)updateSqlMsgWithEventID:(NSString *)eventID isNetwork:(NSInteger)isNetwork{
    NSString *where = [NSString stringWithFormat:@"set %@ = %@ where %@ = %@",bg_sqlKey(@"isNetwork"),bg_sqlValue(@(isNetwork)),bg_sqlKey(@"eventID"),bg_sqlValue(eventID)];
    GCDGlobalQueue(^{
       [XHMessage bg_update:nil where:where];
    });
    
}

+ (void)updateSqlMsgSendFail{
    NSString *where = [NSString stringWithFormat:@"set %@ = %@ where %@ = %@",bg_sqlKey(@"isNetwork"),bg_sqlValue(@(2)),bg_sqlKey(@"isNetwork"),bg_sqlValue(@(0))];
    [XHMessage bg_update:nil where:where];
}

@end
