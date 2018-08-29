//
//  JMWifiCheck.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/8/15.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMWifiCheck.h"

@implementation JMWifiCheck


static bool isWifi = NO;

/**
 判断当前的网络是否是Wi-Fi，它不一定是联网的

 @return 是否
 */
+ (BOOL)netWorkIsWifiOnline {
    isWifi = NO;
    BOOL netBOOL = NO;
    UIApplication *app = [UIApplication sharedApplication];
    @try{
        UIView *statusBar = [app valueForKey:@"statusBar"];
        if ([NSStringFromClass(statusBar.class) isEqualToString:@"UIStatusBar"]) {
            NSArray *children = [[statusBar valueForKeyPath:@"foregroundView"] subviews];
            //获得到网络返回码
            for (id child in children) {
                if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                    //只知道网络状态，不一定会有网
                    NSInteger  netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
                    switch (netType) {
                        case 1:
                        {
                            //网络2G
                            
                        }
                            break;
                        case 2:
                        {
                            //网络3G
                        }
                            break;
                        case 3:
                        {
                            //网络4G
                        }
                            break;
                        case 5:
                        {
                            // WIFI
                            return YES;
                        }
                            break;
                            
                        default:
                            break;
                    }
                    //            NSLog(@"======%ld======",netType);
                    // 1，2，3，5 分别对应的网络状态是2G、3G、4G及WIFI。(需要判断当前网络类型写个switch 判断就OK)
                }
            }
        }else{
            
            //刘海式状态栏，iPhoneX
            UIView *statusB = [statusBar valueForKey:@"statusBar"];
            UIView *foregroundView = [statusB valueForKeyPath:@"foregroundView"];
            [self isStatusBarWifiSignalView:foregroundView];
            netBOOL = isWifi;
        }
    }@catch(NSException *e){
        NSLog(@"判断状态栏Wi-Fi图标出错：%@",e);
    }@finally{
        
    }
 
    return netBOOL;
}

+ (void)isStatusBarWifiSignalView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:@"_UIStatusBarWifiSignalView"]) {
            isWifi = YES;
            return;
        }else{
            [self isStatusBarWifiSignalView:subView];
        }
    }
}

@end
