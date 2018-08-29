//
//  JMBaseTableViewCell.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMBaseModel.h"
@interface JMBaseTableViewCell : UITableViewCell
@property (nonatomic ,strong) JMBaseModel *jm_model;
+ (CGFloat)jm_cellHeight;
@end
