//
//  JMScanController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/11.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#define LBXScan_Define_Native  //包含native库
#define LBXScan_Define_ZXing   //包含ZXing库
#define LBXScan_Define_ZBar   //包含ZBar库
#define LBXScan_Define_UI     //包含界面库

#import <UIKit/UIKit.h>
#import "LBXScanViewController.h"
#import "JMImageTextButton.h"
@interface JMScanController : LBXScanViewController
/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark --增加拉近/远视频界面
@property (nonatomic, assign) BOOL isVideoZoom;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) JMImageTextButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) JMImageTextButton *btnFlash;
//我的二维码
@property (nonatomic, strong) JMImageTextButton *btnMyQR;

@end
