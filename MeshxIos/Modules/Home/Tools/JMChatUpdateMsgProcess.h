//
//  JMChatUpdateMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/24.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
@interface JMChatUpdateMsgProcess : NSObject
+ (void)updateSqlMsgWithEventID:(NSString *)eventID isNetwork:(NSInteger)isNetwork;
//设置发送消息失败
+ (void)updateSqlMsgSendFail;
@end
