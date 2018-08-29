//
//  JMHeaderImageManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMHeaderImageManager.h"

@implementation JMHeaderImageManager
+ (void)saveImageWithData:(NSData *)imageData userID:(NSString *)userID{
    // 取得图片
    UIImage *image = [UIImage imageWithData:imageData];
    NSString *imageFilePath = [self getPath:userID];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    
    BOOL success =  [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
    
    if (success){
        NSLog(@"写入本地成功");
    }
}
+ (UIImage *)readImageWithUserID:(NSString *)userID{
  
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self getPath:userID]];
    if (image) {
        return image;
    }
    
    return [UIImage imageNamed:@"header_icon"];
}

+ (UIImage *)imageWithUserID:(NSString *)userID{
    NSRange range = [userID rangeOfString:kJMXMPPLocalhost];
    if (range.location == NSNotFound) {
        userID = [NSString stringWithFormat:@"%@%@",userID,kJMXMPPLocalhost];
    }
    XMPPJID *jid = [XMPPJID jidWithString:userID];
    NSData *photoData = [[JMXMPPTool sharedInstance].vCardTool.vCardAvatar photoDataForJID:jid];
    if (photoData) {
        return [UIImage imageWithData:photoData];
    }
    return [self readImageWithUserID:userID];
}

+ (NSString *)getPath:(NSString *)userID{
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"headerImage"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *imageFilePath = [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",userID]];
    return imageFilePath;
}

@end
