//
//  JMNetworkConnectionProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/3.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMNetworkConnectionProcess.h"
#import "RealReachability.h"

@interface JMNetworkConnectionProcess()
@property (nonatomic ,strong) dispatch_source_t timer;

@end

@implementation JMNetworkConnectionProcess
- (instancetype)init{
    if ([super init]) {
        [self reachability];
        [self connection];
    }
    return self;
}

//网络检测
- (void)reachability{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    NSLog(@"Initial reachability status:%@",@(status));
    [self realReachability:status];
    
}

- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    //判断网络
    [self realReachability:status];
    
}
/**
 网络切换，获取网络状态
 
 @param status 网络状态
 */
- (void)realReachability:(ReachabilityStatus)status{

    switch (status)
    {    //没有网络
        case RealStatusNotReachable:
        {
            [self disconnect];
            NSLog(@"Network unreachable!");
            break;
        }
        //wifi
        case RealStatusViaWiFi:
        {
            NSLog(@"Network wifi! Free!");
            [self realReachabilityConnection];
            break;
        }
            //2G/3G/4G
        case RealStatusViaWWAN:
        {
            NSLog(@"WWAN in charge!");
             [self realReachabilityConnection];
            break;
        }
            
        case RealStatusUnknown:
        { [self disconnect];
            NSLog(@"Unknown status! Needs debugging!");
            break;
        }
            
        default:
        {  [self disconnect];
            NSLog(@"Status error! Needs debugging!");
            break;
        }
    }
    
}

- (void)disconnect{
    [[JMXMPPTool sharedInstance].xmppStream disconnect];
}

- (void)realReachabilityConnection{
    //断开连接
    [self disconnect];
    //说明已经成功获取过花名册
    if ([JMXMPPTool sharedInstance].rosterTool.rosterType == JMXMPPRosterToolPopulatingTypeEnd) {
        //设置不自动获取好友
       [[JMXMPPTool sharedInstance].rosterTool.xmppRoster setAutoFetchRoster:NO];
        
    }else{
        //设置为自动获取好友
        [[JMXMPPTool sharedInstance].rosterTool.xmppRoster setAutoFetchRoster:YES];
    }
    [JMXMPPTool sharedInstance].isLoginSuccess = NO;
    [self connection];
}

- (void)connection{
    
    if ([JMXMPPTool sharedInstance].isLoginSuccess) {
        return;
    }
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),5.0*NSEC_PER_SEC, 0);
        WEAKSELF
        dispatch_source_set_event_handler(self.timer, ^{
            
            NSString *userName = [JMXMPPTool sharedInstance].loginName;
            NSString *password = [JMXMPPTool sharedInstance].loginpassword;
            if (!userName.length || !password.length) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([JMXMPPTool sharedInstance].isLoginSuccess) {
                    if (weakSelf.timer) {
                        //取消定时器
                        dispatch_source_cancel(weakSelf.timer);
                        weakSelf.timer = nil;
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
        
        dispatch_resume(self.timer);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
