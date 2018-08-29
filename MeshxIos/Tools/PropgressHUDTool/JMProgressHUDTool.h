//
//  JMProgressHUDTool.h
//  超越团队
//
//  Created by xiaozhu on 2017/6/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShowToastActivite  [JMProgressHUDTool showCanInteract]
#define HideToastActivite  [JMProgressHUDTool hidden]

@interface JMProgressHUDTool : NSObject
//加载时，禁止用户有其他交互
+ (void)show;
//隐藏加载提示
+ (void)hidden;
//加载时，允许用户有其他交互
+ (void)showCanInteract;

@end
