//
//  JMProgressHUDTool.m
//  超越团队
//
//  Created by xiaozhu on 2017/6/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "JMProgressHUDTool.h"
#import "SVProgressHUD.h"



@implementation JMProgressHUDTool
//加载时，禁止用户有其他交互
+ (void)show{
    
    [self showCanInteract];
    //状态加载时，禁止用户有其他交互
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
}
//隐藏加载提示
+ (void)hidden{

   [SVProgressHUD dismiss];
}

//加载时，允许用户有其他交互
+ (void)showCanInteract{

    //自定义风格
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    //设置转圈的颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //设置加载背景颜色
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.718 green:0.361 blue:0.349 alpha:1.000]];
   
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.85]];
    //显示加载页面
    [SVProgressHUD show];
}


@end
