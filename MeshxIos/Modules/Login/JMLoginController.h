//
//  JMLoginController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JMLoginControllerType) {
    JMLoginControllerTypeNormal = 0,
    JMLoginControllerTypeSignOut,//退出登录时进入登录页面
    JMLoginControllerTypeChangUser,//切换账号时进入登录界面
};
@interface JMLoginController : UITableViewController
//是否是用户选择退出登录
@property (nonatomic ,assign) JMLoginControllerType type;

@end
