//
//  JMBaseNavigationController.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarItem+JMAdd.h"
@interface JMBaseNavigationController : UINavigationController
- (UIViewController *)getControllerWithClass:(Class)cls;
- (UIViewController *)getLastControllerWithClass:(Class)cls;
@end
