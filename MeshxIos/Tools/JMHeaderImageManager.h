//
//  JMHeaderImageManager.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHeaderImageManager : NSObject
+ (void)saveImageWithData:(NSData *)imageData userID:(NSString *)userID;
+ (UIImage *)readImageWithUserID:(NSString *)userID;
+ (UIImage *)imageWithUserID:(NSString *)userID;

@end
