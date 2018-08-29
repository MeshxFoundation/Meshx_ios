//
//  JMLoginConnectionTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/21.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMLoginConnectionTool.h"
#import "JMUserManager.h"

@interface JMLoginConnectionTool()
@end

@implementation JMLoginConnectionTool

+ (void)connection{
    if ([JMXMPPTool sharedInstance].isLoginSuccess) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),5.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
         NSString *userName = [JMXMPPTool sharedInstance].loginName;
         NSString *password = [JMXMPPTool sharedInstance].loginpassword;
        if (!userName.length || !password.length) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([JMXMPPTool sharedInstance].isLoginSuccess) {
                if (timer) {
                    //取消定时器
                    dispatch_source_cancel(timer);
                    timer = nil;
                }
            }else{
                //说明还没有连接
                if (![JMXMPPTool sharedInstance].isSocketState) {
                    //连接用户
                    [[JMXMPPTool sharedInstance] loginWithUserName:userName    password:password result:nil];
                }
                
            }
            
        });
    });
    
    dispatch_resume(timer);
    
}

@end
