//
//  UITabBarItem+JMAdd.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLBadgeImport.h"
@interface UITabBarItem (JMAdd)

- (void)showItemBadgeNumberValue:(NSInteger)value;
- (void)showItemBadgeRedDotValue:(NSInteger)value;
- (void)showItemBadgeWithStyle:(WBadgeStyle)style
                         value:(NSInteger)value;
@end
