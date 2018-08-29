//
//  JMBaseTabBarController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMBaseTabBarController.h"
#import "JMBaseNavigationController.h"
#import "JMHomeController.h"
#import "JMPeopleController.h"
#import "JMWalletController.h"
#import "JMDiscoverController.h"
#import "JMMineController.h"


@interface JMBaseTabBarController ()

@end

@implementation JMBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabBar上的字体
    [self setupItemWithTitleColor];
    [self setupChildVcs];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/**
 * 添加所有的子控制器
 */
- (void)setupChildVcs
{
    
    NSArray *childVCs = @[
                          @[[[JMHomeController alloc] init],
                              [JMLanguageManager jm_languageHome],
                            NSLocalizedStringFromTable(@"home_normal", nil, nil),
                            NSLocalizedStringFromTable(@"home_highlight", nil, nil)],
                          @[[[JMPeopleController alloc] init],
                            [JMLanguageManager jm_languagePeople],
                            NSLocalizedStringFromTable(@"contacts_normal", nil, nil),
                            NSLocalizedStringFromTable(@"contacts_highlight", nil, nil)
                            ],
                          @[[[JMWalletController alloc] init],
                            [JMLanguageManager jm_languageWallet],
                            NSLocalizedStringFromTable(@"wallet_normal", nil, nil),
                            NSLocalizedStringFromTable(@"wallet_highlight", nil, nil)
                            ],
                          @[[[JMDiscoverController alloc] init],
                            [JMLanguageManager jm_languageDiscover],
                            NSLocalizedStringFromTable(@"find_normal", nil, nil),
                            NSLocalizedStringFromTable(@"find_highlight", nil, nil)
                            ],
                          @[VCFromSBWithIdentifier(@"JMMineController", @"JMMineController"),
                            [JMLanguageManager jm_languageMe],
                            NSLocalizedStringFromTable(@"mine_normal", nil, nil),
                            NSLocalizedStringFromTable(@"mine_highlight", nil, nil)
                            ],
                          ];
    
    [childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *child = (NSArray *)obj;
        [self setupChildVc:child[0] title:child[1] image:child[2] selectedImage:child[3]];
    }];
    
}

/**
 * 添加一个子控制器
 * @param title 文字
 * @param image 图片
 * @param selectedImage 选中时的图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    // 包装一个导航控制器
    JMBaseNavigationController *nav = [[JMBaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[self imageNamedWithOriginal:image] selectedImage:[self imageNamedWithOriginal:selectedImage]];
    nav.tabBarItem = item;
    //设置字体的偏移
    UIOffset titleOffset=UIOffsetMake(0, 0);
    [nav.tabBarItem setTitlePositionAdjustment:titleOffset];
    
    
}
//不对图片进行渲染
- (UIImage *)imageNamedWithOriginal:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
  
    CGFloat scale = 0.55;
    image = [image jj_scaleToSize:CGSizeMake(image.width*scale, image.height*scale)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

/**
 * 设置item属性
 */
- (void)setupItemWithTitleColor;
{
    
      UIColor  *titleColor = [UIColor colorWithHexString:kJMGrayColorHexString];
     UIColor  * selectColor = [UIColor colorWithHexString:kJMMainColorHexString];
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = titleColor;
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = selectColor;
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}

- (JMBaseNavigationController *)getNavigationControllerWithClass:(Class)cls{
    for (JMBaseNavigationController *nav in self.viewControllers) {
        if ([nav.viewControllers.firstObject isKindOfClass:cls]) {
            return nav;
        }
    }
    return nil;
}
- (UIViewController *)getControllerWithClass:(Class)cls{
    return [self getNavigationControllerWithClass:cls].viewControllers.firstObject;
}


- (void)changeLanguage{
    for (JMBaseNavigationController *nav in self.viewControllers) {
        JMBaseViewController *firstViewController = nav.viewControllers.firstObject;
        if([firstViewController isKindOfClass:[JMHomeController class]]){
            firstViewController.title = [JMLanguageManager jm_languageHome];
            nav.tabBarItem.title = firstViewController.title;
            [firstViewController changeLanguage];
        }else if ([firstViewController isKindOfClass:JMPeopleController.class]){
            firstViewController.title = [JMLanguageManager jm_languagePeople];
            nav.tabBarItem.title = firstViewController.title;
            [firstViewController changeLanguage];
        }else if ([firstViewController isKindOfClass:JMWalletController.class]){
            firstViewController.title = [JMLanguageManager jm_languageWallet];
            nav.tabBarItem.title = firstViewController.title;
            [firstViewController changeLanguage];
        }else if ([firstViewController isKindOfClass:JMDiscoverController.class]){
            firstViewController.title = [JMLanguageManager jm_languageDiscover];
            nav.tabBarItem.title = firstViewController.title;
            [firstViewController changeLanguage];
        }else if ([firstViewController isKindOfClass:JMMineController.class]){
            firstViewController.title = [JMLanguageManager jm_languageMe];
            nav.tabBarItem.title = firstViewController.title;
        }
    }
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
