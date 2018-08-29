//
//  JMHomeAddMenuView.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/11.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMHomeAddMenuView.h"
#import "JMHomeController.h"
#import "XHPopMenu.h"
#import "JMScanController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"


@interface JMHomeAddMenuView ()
@end

@implementation JMHomeAddMenuView



- (void)showWithSender:(id)sender viewController:(UIViewController *)viewController{
    NSMutableArray<__kindof XHPopMenuItem *> *tempArr = [NSMutableArray array];
    
    UIImage *addFriendImage = [UIImage imageNamed:@"addFriend"];
  XHPopMenuItem *addFriendItem =  [[XHPopMenuItem alloc] initWithTitle:[JMLanguageManager jm_languageAddPeople] image:addFriendImage block:^(XHPopMenuItem * _Nullable item) {

    }];
    UIImage *scanImage= [UIImage imageNamed:@"scan_icon"];
    XHPopMenuItem *scanItem =  [[XHPopMenuItem alloc] initWithTitle:[JMLanguageManager jm_languageScan] image:scanImage block:^(XHPopMenuItem * _Nullable item) {
        //添加一些扫码或相册结果处理
        JMScanController *vc = [JMScanController new];
        vc.libraryType = SLT_Native;
        vc.scanCodeType =SCT_QRCode;
        vc.style = [JMHomeAddMenuView qqStyle];
        //镜头拉远拉近功能
        vc.isVideoZoom = YES;
        [viewController.navigationController pushViewController:vc animated:YES];
    }];
    [tempArr addObject:addFriendItem];
    [tempArr addObject:scanItem];

    XHPopMenuConfiguration *options = [XHPopMenuConfiguration defaultConfiguration];
    options.style               = XHPopMenuAnimationStyleScale;
    options.menuMaxHeight       = 200; // 菜单最大高度
    options.itemHeight          = 44;
    options.itemMaxWidth        = 175;
//    options.arrowSize           = 15; //指示箭头大小
    options.arrowMargin         = 12; // 手动设置箭头和目标view的距离
    options.marginXSpacing      = 10; //MenuItem左右边距
    options.marginYSpacing      = 12; //MenuItem上下边距
    options.intervalSpacing     = 15; //MenuItemImage与MenuItemTitle的间距
    options.menuCornerRadius    = 3; //菜单圆角半径
//    options.shadowOfMenu        = YES; //是否添加菜单阴影
    options.hasSeparatorLine    = YES; //是否设置分割线
    options.separatorInsetLeft  = 10; //分割线左侧Insets
    options.separatorInsetRight = 10; //分割线右侧Insets
    options.separatorHeight     = 1.0 / [UIScreen mainScreen].scale;//分割线高度
    options.titleColor          = [UIColor whiteColor];//menuItem字体颜色
    options.separatorColor      = [[UIColor alloc] initWithWhite:0.6 alpha:0.3];//分割线颜色
    options.menuBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];//菜单的底色
    options.selectedColor       = [UIColor grayColor];// menuItem选中颜色
    
//    // 设置menu距离屏幕左右两边的最小间距
//    options.menuScreenMinLeftRightMargin = 10;
//
//    // 设置menu距离屏幕底部的最小间距
//    options.menuScreenMinBottomMargin = 49;
//
//    // 设置自动转屏不消失
//    options.dismissWhenRotationScreen = false;
//
//    // 新增方法 设置点击背景消失
//    options.dismissWhenClickBackground = true;
//
//    // 新增方法 设置点击背景不消失
//    [options setDismissBlock:^{
//        NSLog(@"点击背景自动消失");
//    }];
    
    [XHPopMenu showMenuWithView:sender menuItems:tempArr withOptions:options];
}


+ (LBXScanViewStyle*)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    return style;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
