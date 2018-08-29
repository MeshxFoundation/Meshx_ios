//
//  JMChatTransportModel.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMChatTransportModel : NSObject


@property (nonatomic, copy) NSString *text;
//1、表示图片，2、表示语音
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *voiceDuration;
//事件ID;
@property (nonatomic ,copy) NSString *eventID;
//用户ID
@property (nonatomic ,copy) NSString *userID;

@property (nonatomic ,copy) NSString *sendTime;

@property (nonatomic ,copy) NSString *receiveTime;

@end
