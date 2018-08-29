//
//  ToastTool.h
//  超越团队
//
//  Created by chengw on 16/4/13.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Toast.h"
/**封装的使用宏**/
//视图上显示
#define JMShowToastView(Message)  [self.view makeToast:Message duration:1 position:CSToastPositionCenter];

//Window上显示
#define JMShowToast(Message)      [[UIApplication sharedApplication].keyWindow makeToast:Message duration:1.5 position:CSToastPositionCenter]
#define JMShowToastWindow(Message)       [[UIApplication sharedApplication].keyWindow makeToast:Message duration:1.5 position:CSToastPositionCenter]
//#define ShowToastActivite   [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter]
//#define HideToastActivite [[UIApplication sharedApplication].keyWindow hideToastActivity]
#define JMShowToastNetWorkError        ShowToast(@"网络异常,请稍后再试")

@interface ToastTool : NSObject

/**
 *  @brief 统一设置taost
 */
+ (void)setCustomStype;

@end
