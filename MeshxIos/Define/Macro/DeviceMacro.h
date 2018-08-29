//
//  DeviceMacro.h
//  MacroDemo
//
//  Created by xiaozhu on 2017/6/10.
//  Copyright © 2017年 xiaozhu. All rights reserved.
//

#ifndef DeviceMacro_h
#define DeviceMacro_h

//--------判断是模拟器，还是真机-----
#if TARGET_IPHONE_SIMULATOR

#define SIMULATOR 1

#elif TARGET_OS_IPHONE

#define SIMULATOR 0

#endif

// iPhone X 宏定义
#define  iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)
// 适配iPhone X 状态栏高度
#define  kStatusBarHeight      (iPhoneX ? 44.f : 20.f)
// 适配iPhone X Tabbar高度
#define  kTabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// 适配iPhone X Tabbar距离底部的距离
#define  kTabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// 适配iPhone X 导航栏高度
#define  kNavHeight  (iPhoneX ? 88.f : 64.f)



//设备屏幕尺寸
//----------------------备屏幕尺寸----------------------------
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

#pragma mark- 屏幕
//----------------------屏幕----------------------------
// Retina屏幕判断
#define isRetina ([[UIScreen mainScreen] scale]==2)
// Pad设备判断--Xib或Storyboard
#define isDevicePad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 3.5屏幕判断
#define isR3_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

// 4.0屏幕判断
#define isR4_0 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// 4.7屏幕判断
#define isR4_7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 5.5屏幕判断
#define isR5_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//----------------------屏幕----------------------------

#pragma mark- 系统版本
//----------------------系统版本----------------------------
// 系统版本号
#define isIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]==6)
#define isIOS6 ([[[UIDevice currentDevice] systemVersion] intValue]==6)
#define isIOS8 ([[[UIDevice currentDevice] systemVersion] intValue]==8)
#define isIOS9 ([[[UIDevice currentDevice] systemVersion] intValue]==9)
#define isIOS10 ([[[UIDevice currentDevice] systemVersion] intValue]==10)

#define IsAfterIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
#define IsAfterIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)
#define isAfterIOS8 ([[[UIDevice currentDevice] systemVersion] intValue] >= 8)
#define isAfterIOS9 ([[[UIDevice currentDevice] systemVersion] intValue] >= 9)
#define isAfterIOS10 ([[[UIDevice currentDevice] systemVersion] intValue] >= 10)



#define iOSCurrentVersion ([[UIDevice currentDevice] systemVersion])

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统版本----------------------------

#endif /* DeviceMacro_h */
