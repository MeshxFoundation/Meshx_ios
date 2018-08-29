//
//  JMBaseTabBarController.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseTabBarController : UITabBarController
- (JMBaseNavigationController *)getNavigationControllerWithClass:(Class)cls;
- (UIViewController *)getControllerWithClass:(Class)cls;
- (void)changeLanguage;
@end
