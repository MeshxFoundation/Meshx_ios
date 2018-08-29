//
//  ToastTool.m
//  超越团队
//
//  Created by chengw on 16/4/13.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "ToastTool.h"

@implementation ToastTool

+ (void)setCustomStype
{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    style.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    style.titleColor = [UIColor blackColor];
    style.messageColor = [UIColor blackColor];
    [CSToastManager setSharedStyle:style];
}

@end
