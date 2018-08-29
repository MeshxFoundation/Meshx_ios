//
//  JMScanResultController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/12.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMScanResultController.h"
#import "YsLabel.h"
@interface JMScanResultController ()
@property (weak, nonatomic) IBOutlet YsLabel *resultLabel;

@end

@implementation JMScanResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultLabel.text = self.scanResult.strScanned;
    self.title = [JMLanguageManager jm_languageQRCodeInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
