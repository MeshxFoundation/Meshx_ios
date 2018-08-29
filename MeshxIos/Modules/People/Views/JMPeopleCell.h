//
//  JMPeopleCell.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPeopleCell;

@interface JMPeopleFirstSectionModel : NSObject

@property (nonatomic ,strong) JMPeopleCell *cell;
@property (nonatomic ,strong)NSString *title;
@property (strong, nonatomic) UIImage *img;
@property (nonatomic ,assign) NSInteger num;
+ (NSArray *)getFirstSectionData;

@end

@interface JMPeopleCell : JMBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

- (void)setupFirstSectionCellWithModel:(JMPeopleFirstSectionModel *)model;
@end
