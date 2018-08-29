//
//  JMMyQRCodeController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/10.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMyQRCodeController.h"
#import "LBXScanNative.h"
#import "LBXPermissionSetting.h"


@interface JMMyQRCodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myQRImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) UIImageView* logoImgView;

@end

@implementation JMMyQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    self.nameLabel.text = [JMMyInfo name];
    [self setupHeaderImage];
    [self.saveButton setTitle:[JMLanguageManager jm_languageSaveQRCodeToAlbum] forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 5;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = JMCustomTableViewBackgroundColor;
//    self.bgView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.bgView.layer.shadowRadius = 5;
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bgView.layer.shadowOpacity = 0.5;
    [self createQR];
}

- (IBAction)saveButtonClick:(UIButton *)sender {
    [self savePhotoToAlbum];
}

- (void)savePhotoToAlbum{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[JMLanguageManager jm_languageSaveQRCodeToAlbum] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[JMLanguageManager jm_languageOK] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       UIImage *image = [self.bgView snapshotImage];
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[JMLanguageManager jm_languageCancel] style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    
    if (error == nil) {
        
        [LCProgressHUD showSuccess:[JMLanguageManager jm_languageSuccess]];
        
    }else {
         [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:nil msg:[JMLanguageManager jm_languagePermissionSettingPrompt] cancel:[JMLanguageManager jm_languageCancel] setting:[JMLanguageManager jm_languageSettings]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createQR
{
    NSString *myQR = [NSString stringWithFormat:@"%@%@%@",[JMMyInfo name],kJMMyQRIdentifier,[JMMyInfo name]];
    self.myQRImageView.image = [LBXScanNative createQRWithString:myQR QRSize:self.myQRImageView.bounds.size];
}

- (void)setupHeaderImage{
    CGSize size = self.headImageView.frame.size;
    CGFloat radius = size.width/2.0;
    UIImage *image = [[JMMyInfo headerImage] jj_imageAddCornerWithRadius:radius size:size];
    self.headImageView.image = [image jj_circleRadius:radius borderWidth:2 borderColor:[UIColor whiteColor]];
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        CGSize logoSize=CGSizeMake(38, 38);
        CGFloat radius = 5;
        _logoImgView = [UIImageView new];
        UIImage *image = [[JMMyInfo headerImage] jj_imageAddCornerWithRadius:radius size:logoSize];
        _logoImgView.image =image;
        _logoImgView.frame = CGRectMake(0, 0, logoSize.width, logoSize.height);
        _logoImgView.center = CGPointMake(CGRectGetWidth(self.myQRImageView.frame)/2, CGRectGetHeight(self.myQRImageView.frame)/2);
    }
    return _logoImgView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
