//
//  JMChatMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMChatSendMsgProcess.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"
#import "XHMessage.h"

@interface JMChatMsgProcess : NSObject
@property (nonatomic ,strong) JMChatSendMsgProcess *sendMsgProcess;
@property (nonatomic ,strong) NSMutableArray *photoSources;
@property (nonatomic ,strong) NSMutableArray *photoMessageSources;

- (instancetype)initWithViewController:(UIViewController *)viewController;
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date;
/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date;
/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date;

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date;

- (void)createPhotoWithMessage:(XHMessage *)messag;
- (void)createPhotoWithMessage:(XHMessage *)message atIndex:(NSInteger )index;

@end
