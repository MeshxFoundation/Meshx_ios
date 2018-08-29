//
//  JMPeopleCell.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMPeopleCell.h"

@implementation JMPeopleFirstSectionModel

+ (NSArray *)getFirstSectionData{
    JMPeopleFirstSectionModel *addFriend = [JMPeopleFirstSectionModel new];
    addFriend.title = [JMLanguageManager jm_languageNewFreinds];
    addFriend.img = [UIImage imageNamed:@"new_friend"];
    
    return @[addFriend];
}

@end

@interface JMPeopleCell()



@end

@implementation JMPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.promptLabel.hidden = YES;
    // Initialization code
}

- (void)setJm_model:(JMBaseModel *)jm_model{
    [super setJm_model:jm_model];
    UIImage *image = [JMHeaderImageManager imageWithUserID:[jm_model valueForKey:@"userID"]];
    self.headImageView.image = [image jj_imageAddCornerWithRadius:CGRectGetWidth(self.headImageView.frame)/2.0 size:self.headImageView.size];
    self.titleLabel.text = [jm_model valueForKey:kJMSearchPropertyName];
    self.promptLabel.hidden = YES;
}

- (void)setupFirstSectionCellWithModel:(JMPeopleFirstSectionModel *)model{
    model.cell = self;
    self.headImageView.image = [[model.img jj_scaleToSize:self.headImageView.frame.size]  jj_imageAddCornerWithRadius:CGRectGetWidth(self.headImageView.frame)/2.0 size:self.headImageView.size];
    self.titleLabel.text = model.title;
    GCDGlobalQueue(^{
        GCDMainQueue((^{
            if (model.num) {
                self.promptLabel.text = [NSString stringWithFormat:@"%ld",model.num];
                self.promptLabel.hidden = NO;
                self.promptLabel.layer.masksToBounds = YES;
                self.promptLabel.layer.cornerRadius = CGRectGetHeight(self.promptLabel.frame)/2.0;
            }else{
                self.promptLabel.hidden = YES;
            }
        }));
    });
}

- (void)setupNumber{
    
}

+ (CGFloat)jm_cellHeight{
    return 55.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
