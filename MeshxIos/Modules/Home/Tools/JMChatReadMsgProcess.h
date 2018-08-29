//
//  JMChatReadMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/23.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
static const NSInteger kChatHistoryMsgLimitTop = 3;
@interface JMChatReadMsgProcess : NSObject
@property (nonatomic ,assign) BOOL isReadComplete;
- (instancetype)initWithViewController:(UIViewController *)viewController;

/**
 首次从数据库读取数据，根据接收到对方信息的时间读取数据：
 步骤：先根据时间倒序，条数查询数据-->查询得到数据进行倒序处理。

 @return 读取数据
 */
- (NSArray <XHMessage *> *)loadDataFromSqlite;

/**
 加载更多数据

 @param message 数据模型
 @return 读取数据
 */
- (NSArray *)loadMoreMessage:(XHMessage *)message;

- (NSArray <XHMessage *> *)loadDataFromSqliteChatHistory;

@end
