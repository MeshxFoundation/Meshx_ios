//
//  JMBaseViewController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMBaseViewController.h"
//#import "WRNavigationBar.h"
@interface JMBaseViewController ()

@end

@implementation JMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self wr_setNavBarBarTintColor:[UIColor commonWhiteColor]];
//    [self wr_setNavBarTitleColor:[[UIColor mainThemeColor] colorWithAlphaComponent:1]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (UIButton *)setupRightItemWithImage:(UIImage *)image{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    return rightBtn;
}


- (void)rightBarButtonItemClick:(UIButton *)btn{
    
}
- (void)changeLanguage{
    
}

- (void)dealloc{
    
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
