//
//  JMMyInfo.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/21.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#define UrlDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define UrlDocumentFileName(fileName) [UrlDocument stringByAppendingPathComponent:fileName]

#define FilePathSingleUser @"userInfo.plist"

#import "JMMyInfo.h"
@interface JMMyInfo ()
@property (nonatomic ,strong) XMPPvCardTemp *myCard;
@end

@implementation JMMyInfo

MJExtensionCodingImplementation

+ (NSString *)name{
    return [self jid].user;
}
+ (NSString *)userID{
    return [self getUserIDWithName:[self name]];
}
+ (XMPPJID *)jid{
   return [JMXMPPTool sharedInstance].xmppStream.myJID;
}

+ (UIImage *)headerImage{
    NSData *imageData = [self myCard].photo;
    if (imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        return image;
    }
    return [JMHeaderImageManager readImageWithUserID:[self userID]];
}

+ (XMPPvCardTemp *)myCard{
  return [JMMyInfo readUserInfo].myCard;
}
//性别
+ (NSString *)gender{
    return [JMMyInfo myCard].gender;
}
//是否是男
+ (BOOL)isMale{
    return [[self gender] integerValue];
}

#pragma mark 归档与反归档
#pragma mark - *** 单用户操作 *** -

/**< 归档保存1个(当前)用户数据 */
+(void)saveToFile{
    JMMyInfo *myInfo = [JMMyInfo new];
    myInfo.myCard = [JMXMPPTool sharedInstance].vCardTool.vCardModule.myvCardTemp;
    [NSKeyedArchiver archiveRootObject:myInfo toFile:UrlDocumentFileName(FilePathSingleUser)];
}

/**< 反归档读取用户数据 */
+ (instancetype)readUserInfo{
    XMPPvCardTemp *myvCardTemp = [JMXMPPTool sharedInstance].vCardTool.vCardModule.myvCardTemp;
    if (myvCardTemp) {
        JMMyInfo *myInfo = [JMMyInfo new];
        myInfo.myCard = myvCardTemp;
        return myInfo;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:UrlDocumentFileName(FilePathSingleUser)];
}

/**< 删除单个用户文件 */
+ (void)deleteUserInfo{
    [JMMyInfo deleteFileAtPath:FilePathSingleUser];
    
}
/**< 删除指定路径文件 */
+ (void)deleteFileAtPath:(NSString *)filename {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *delelteFilePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSError *error;
    
    if ([fileManager removeItemAtPath:delelteFilePath error:&error] != YES)
        
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
}

@end
