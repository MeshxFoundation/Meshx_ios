//
//  UITabBarItem+JMAdd.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "UITabBarItem+JMAdd.h"

@implementation UITabBarItem (JMAdd)

- (void)showItemBadgeWithStyle:(WBadgeStyle)style
                         value:(NSInteger)value{
    self.badgeCenterOffset = CGPointMake(-8, 8);
    [self showBadgeWithStyle:style value:value animationType:WBadgeAnimTypeNone];
}

- (void)showItemBadgeNumberValue:(NSInteger)value{
    [self showItemBadgeWithStyle:WBadgeStyleNumber value:value];
}

- (void)showItemBadgeRedDotValue:(NSInteger)value{
    if (!value) {
        self.badge.hidden = YES;
        return;
    }
    [self showItemBadgeWithStyle:WBadgeStyleRedDot value:value];
}

@end
