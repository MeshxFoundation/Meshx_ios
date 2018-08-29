//
//  JMScanController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/11.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMScanController.h"
#import "JMMyQRCodeController.h"
#import "LBXScanVideoZoomView.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "JMPeopleModel.h"
#import "JMSearchPeopleTool.h"
#import "JMScanResultController.h"

@interface JMScanController ()

@end

@implementation JMScanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    self.title = [JMLanguageManager jm_languageScan];
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self drawBottomItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
    
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        CGFloat scanWidth = frame.size.width - XRetangleLeft*2-XRetangleLeft;
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(20, 0, CGRectGetWidth(self.view.frame)-40, 44);
       CGFloat _topTitleCenterY = CGRectGetHeight(frame)/2.0+scanWidth/2.0+22;
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, _topTitleCenterY);
        
        _topTitle.font = [UIFont systemFontOfSize:15];
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = [JMLanguageManager jm_languageAlignQRCodeScan];
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}


- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    CGFloat imgTextDistance = 2;
    CGSize size = CGSizeMake(80, 76);
    self.btnFlash = [[JMImageTextButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) image:[UIImage imageNamed:@"qrcode_scan_flash_nor"] title:[JMLanguageManager jm_languageFlash]];
    self.btnFlash.titleLabel.font = [UIFont systemFontOfSize:13.5];
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    _btnFlash.imgTextDistance = imgTextDistance;
    _btnFlash.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
    self.btnPhoto = [[JMImageTextButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) image:[UIImage imageNamed:@"qrcode_scan_photo_nor"] title:[JMLanguageManager jm_languageAlbum]];
    _btnPhoto.titleLabel.font = self.btnFlash.titleLabel.font;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    _btnPhoto.imgTextDistance = imgTextDistance;
    _btnPhoto.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
    self.btnMyQR = [[JMImageTextButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) image:[UIImage imageNamed:@"qrcode_scan_myqrcode_nor"] title:[JMLanguageManager jm_languageMyQRCode]];
    _btnMyQR.titleLabel.font = self.btnFlash.titleLabel.font;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"qrcode_scan_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR setTitle:[JMLanguageManager jm_languageMyQRCode] forState:UIControlStateNormal];
    _btnMyQR.imgTextDistance = imgTextDistance;
    _btnMyQR.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentUp;
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnMyQR];
    
}

- (void)showError:(NSString*)str
{
//    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
     NSLog(@"====Result=%@====",strResult);
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{

}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    
    NSString *stringResult = strResult.strScanned;
    NSRange range = [stringResult rangeOfString:kJMMyQRIdentifier];
    
    //说明是我们应用的二维码
    if (range.length>0) {
        NSArray *array = [stringResult componentsSeparatedByString:kJMMyQRIdentifier];
        NSString *userID = array.firstObject;
        GCDGlobalQueue(^{
            JMPeopleModel *model = [JMPeopleModel findPeopleWithUserID:userID];
            //说明数据库存在该用户
            if (model) {
                [self pushViewControllerWithModel:model];
            }else{
                
                    [JMSearchPeopleTool searchWithString:userID result:^(BOOL isSuccess, NSArray<JMPeopleModel *> *dataArray) {
                        if (isSuccess&&dataArray.count) {
                            for (JMPeopleModel *mod in dataArray) {
                                if ([mod.name isEqualToString:userID]) {
                                   
                                    [self pushViewControllerWithModel:mod];
                                   
                                    return ;
                                }
                            }
                            
                        }else{
                            GCDMainQueue(^{
                                [self enterScanResultControler:strResult];
                            });
                        }
                    }];
            }
           
        });
        return;
    }
    
    [self enterScanResultControler:strResult];
}

- (void)enterScanResultControler:(LBXScanResult *)result{
    JMScanResultController *scanResultController = VCFromSBWithIdentifier(ClassStringFromClassName(JMScanResultController), ClassStringFromClassName(JMScanResultController));
    scanResultController.scanResult =result;
    [self.navigationController pushViewController:scanResultController animated:YES];
}

- (void)pushViewControllerWithModel:(JMPeopleModel *)model{
    
    GCDMainQueue(^{
        
    });
}

#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:nil msg:[JMLanguageManager jm_languagePermissionSettingPrompt] cancel:[JMLanguageManager jm_languageCancel] setting:[JMLanguageManager jm_languageSettings]];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode
{
    JMMyQRCodeController *myQRCode =  VCFromSBWithIdentifier(ClassStringFromClassName(JMMyQRCodeController), ClassStringFromClassName(JMMyQRCodeController));
    myQRCode.title = [JMLanguageManager jm_languageMyQRCode];
    [self.navigationController pushViewController:myQRCode animated:YES];
}


@end
