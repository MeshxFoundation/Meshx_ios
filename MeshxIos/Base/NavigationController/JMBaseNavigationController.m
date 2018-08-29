//
//  JMBaseNavigationController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMBaseNavigationController.h"

@interface JMBaseNavigationController ()

@end

@implementation JMBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //设置导航栏上的字体
//    [self.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreen_Width, 64)] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.shadowImage = [UIImage jj_imageWithColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.05] size:CGSizeMake(kScreenWidth, 0.8)];
//    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = YES;
//  self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }else{
        
        viewController.navigationController.navigationBar.hidden = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)getControllerWithClass:(Class)cls{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:cls]) {
            return viewController;
        }
    }
    return nil;
}

- (UIViewController *)getLastControllerWithClass:(Class)cls{
    UIViewController *lastViewController = self.viewControllers.lastObject;
    if ([lastViewController isKindOfClass:cls]) {
        return lastViewController;
    }
    return nil;
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
