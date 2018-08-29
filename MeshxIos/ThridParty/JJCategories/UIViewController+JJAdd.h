//
//  UIViewController+JJAdd.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/30.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JJAdd)
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray<NSString *> *)btnTitles clickBtn:(void (^)(NSInteger index))clickBtnBlock;
@end
