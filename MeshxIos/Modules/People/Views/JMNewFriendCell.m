//
//  JMNewFriendCell.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMNewFriendCell.h"
@interface JMNewFriendCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@end


@implementation JMNewFriendCell


- (IBAction)lookButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(lookNewFriend:)]) {
        [self.delegate lookNewFriend:self.jm_model];
    }
}

- (void)setJm_model:(JMBaseModel *)jm_model{
    [super setJm_model:jm_model];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookButton.layer.masksToBounds = YES;
    self.lookButton.layer.cornerRadius = 2;
    self.lookButton.layer.borderWidth = 1;
    self.lookButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.stateLabel.adjustsFontSizeToFitWidth = YES;
    self.lookButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

+ (CGFloat)jm_cellHeight{
    return 55;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
