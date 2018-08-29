//
//  JMFileSaveManager.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFileSaveManager : NSObject
//将图片写入文件
+ (void)saveImage:(NSData *)imageData  imageName:(NSString *)imageName;
//图片存放路径
+(NSString *)imageName:(NSString *)imageName;

//将语音写入文件
+ (void)saveVoice:(NSData *)voiceData  voiceName:(NSString *)voiceName;
//语音存放路径
+(NSString *)voiceName:(NSString *)voiceName;

+(UIImage *)headerImageName:(NSString *)imageName;

@end
