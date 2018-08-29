//
//  JMSettingPermissionsTool.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/30.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMSettingPermissionsTool.h"

@implementation JMSettingPermissionsTool
+ (void)goToBluetooth{
    NSString *string = @"prefs:root=Bluetooth";
    NSString *appstring = @"App-Prefs:root=Bluetooth";
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 10.0) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]]) {
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstring] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }
        
    }else{
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstring]];
        }
    }
}

@end
