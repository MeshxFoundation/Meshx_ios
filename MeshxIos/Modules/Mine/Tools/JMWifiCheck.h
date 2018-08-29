//
//  JMWifiCheck.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/8/15.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMWifiCheck : NSObject
/**
 判断当前的网络是否是Wi-Fi，它不一定是联网的
 
 @return 是否
 */
+ (BOOL)netWorkIsWifiOnline;
@end
