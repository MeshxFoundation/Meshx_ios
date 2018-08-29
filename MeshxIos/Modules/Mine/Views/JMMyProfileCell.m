//
//  JMMyProfileCell.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/10.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMyProfileCell.h"
#import "JMMyProfileModel.h"

@interface JMMyProfileCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelRightConstraint;

@end
@implementation JMMyProfileCell

- (void)setJm_model:(JMBaseModel *)jm_model{
    [super setJm_model:jm_model];
    JMMyProfileModel *model = (JMMyProfileModel *)jm_model;
    if (model.icon.length) {
        self.nameLabel.hidden = YES;
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [UIImage imageNamed:model.icon];
    }else{
        self.nameLabel.hidden = NO;
        self.nameLabel.text = model.name;
        self.iconImageView.hidden = YES;
    }
    self.titleLabel.text = model.title;
    if ([model.title isEqualToString:[JMLanguageManager jm_languageName]]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.nameLabelRightConstraint.constant = 35;
    }else{
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.nameLabelRightConstraint.constant = 0;
    }
}

+ (CGFloat)jm_cellHeight{
    return 44;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
