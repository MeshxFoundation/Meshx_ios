//
//  JMTabBarPromptTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/19.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMTabBarPromptTool.h"
#import "JMHomeController.h"
#import "JMPeopleController.h"
#import "JMPeopleModel.h"

@implementation JMTabBarPromptTool
+ (void)showHomeItemBadgeWithValue:(NSInteger)value{
    for (JMBaseNavigationController *baseNav in [JMTabBarController viewControllers]) {
        UIViewController *viewController = baseNav.viewControllers.firstObject;
        if ([viewController isKindOfClass:[JMHomeController class]]) {
            [baseNav.tabBarItem showItemBadgeWithStyle:WBadgeStyleNumber value:value];
        }
    }
    
}


+ (void)showPeopleItemDot{
    
    if ([NSThread isMainThread]) {
        GCDGlobalQueue(^{
//            NSInteger count = [JMNewFriendModel getIsNoRead];
//            GCDMainQueue(^{
//                NSLog(@"++++++%ld=====",count);
//                JMBaseNavigationController *peopleNav = [self getPeopleNavigaitonController];
//                [peopleNav.tabBarItem showItemBadgeRedDotValue:count];
//            });
        });
    }else{
//        NSInteger count = [JMNewFriendModel getIsNoRead];
//        GCDMainQueue(^{
//            NSLog(@"++++++%ld=====",count);
//            JMBaseNavigationController *peopleNav = [self getPeopleNavigaitonController];
//            [peopleNav.tabBarItem showItemBadgeRedDotValue:count];
//        });
    }
   
    
}

+ (JMBaseNavigationController *)getPeopleNavigaitonController{
    for (JMBaseNavigationController *baseNav in [JMTabBarController viewControllers]) {
        UIViewController *viewController = baseNav.viewControllers.firstObject;
        if ([viewController isKindOfClass:[JMPeopleController class]]) {
            return baseNav;
        }
    }
    return nil;
}

@end
