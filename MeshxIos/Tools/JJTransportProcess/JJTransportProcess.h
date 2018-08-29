//
//  JJTransportProcess.h
//  MCDemo
//
//  Created by JMZiXun on 2018/5/15.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTransportDecoder.h"
#import "JJTransportEncoder.h"
@interface JJTransportProcess : NSObject

@property (nonatomic ,strong)NSString* type;
//文本数据
@property (nonatomic ,strong)NSDictionary *msg;
//图片／音频／文件
@property (nonatomic ,strong)NSData *fileData;



@end
