//
//  JMFileSaveManager.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMFileSaveManager.h"

@implementation JMFileSaveManager
//将图片写入文件
+ (void)saveImage:(NSData *)imageData  imageName:(NSString *)imageName{
    // 取得图片
    UIImage *image = [UIImage imageWithData:imageData];
    NSString *imageFilePath = [self imageName:imageName];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    
    BOOL success =  [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
    
    if (success){
        NSLog(@"写入本地成功");
    }
}
//图片存放路径
+(NSString *)imageName:(NSString *)imageName{
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"image"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *imageFilePath = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]];
    return imageFilePath;
}

//将语音写入文件
+ (void)saveVoice:(NSData *)voiceData  voiceName:(NSString *)voiceName{
    NSString *voiceP = [self voiceName:voiceName];
    [voiceData writeToFile:voiceP atomically:YES];
}
//语音存放路径
+(NSString *)voiceName:(NSString *)voiceName{
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"voices"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *voiceFilePath = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.spx",voiceName]];
    
    return voiceFilePath;
}

+(UIImage *)headerImageName:(NSString *)imageName{
    
    if ([imageName isEqualToString:[MCSessionProcess sharedInstance].sessionManager.peerID.jj_UUID]) {
        return [UIImage imageNamed:@"icon_my_header"];
    }else{
        return [UIImage imageNamed:@"icon_header"];
    }
}

@end
