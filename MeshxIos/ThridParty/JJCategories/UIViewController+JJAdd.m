//
//  UIViewController+JJAdd.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/30.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "UIViewController+JJAdd.h"

@implementation UIViewController (JJAdd)
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message btnTitles:(NSArray<NSString *> *)btnTitles clickBtn:(void (^)(NSInteger index))clickBtnBlock{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (btnTitles.count == 1) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitles[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickBtnBlock) {
                clickBtnBlock(0);
            }
        }];
        [alert addAction:action];
    }else if (btnTitles.count == 2){
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:btnTitles[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickBtnBlock) {
                clickBtnBlock(0);
            }
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickBtnBlock) {
                clickBtnBlock(1);
            }
        }];
        [alert addAction:cancel];
        [alert addAction:action];
    }else{
        for (int index = 0; index < btnTitles.count; index++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitles[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (clickBtnBlock) {
                    clickBtnBlock(index);
                }
            }];
            [alert addAction:action];
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
