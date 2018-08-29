//
//  JMMacro.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//
#import "JMBaseTabBarController.h"
#import <UIKit/UIKit.h>

#define JMCustomTableViewBackgroundColor [[UIColor alloc] initWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

//获取tabBarController
#define JMTabBarController (JMBaseTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController

//是否显示tabBar
#define JMHiddenTabBar(isHidden) [JMTabBarController tabBar].hidden = isHidden

