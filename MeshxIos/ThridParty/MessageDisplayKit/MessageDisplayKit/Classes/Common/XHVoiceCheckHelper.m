//
//  XHVoiceCheckHelper.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "XHVoiceCheckHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation XHVoiceCheckHelper

+ (BOOL)recordCheck{
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL reCheck = YES;
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            
            if (available) {
                
                
            }
            else
            {
                
                if (![NSThread isMainThread]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许茶馆访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    });
                }

                reCheck = NO;
            }
        }];
        
    }
    
    return reCheck;
}

@end
