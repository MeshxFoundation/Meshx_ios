//
//  JMBaseTableViewController.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseTableViewController : UITableViewController
- (void)setupRightItemWithImage:(UIImage *)image;
- (void)rightBarButtonItemClick:(UIButton *)btn;
- (void)changeLanguage;
@end
