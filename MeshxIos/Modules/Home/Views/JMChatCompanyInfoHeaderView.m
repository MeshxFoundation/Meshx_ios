//
//  JMChatCompanyInfoHeaderView.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMChatCompanyInfoHeaderView.h"
@interface JMChatCompanyInfoHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation JMChatCompanyInfoHeaderView

- (void)setModel:(JMBaseModel *)model{
    _model = model;
    [self setupViewWithModel:model];
}

- (void)setupViewWithModel:(JMBaseModel *)model{
    NSString *name = [model valueForKey:kJMSearchPropertyName];
    self.nameLabel.text = name;
    UIImage *image = [JMHeaderImageManager imageWithUserID:[model valueForKey:@"userID"]];
    self.headImageView.image = [image jj_imageAddCornerWithRadius:CGRectGetWidth(self.headImageView.frame)/2.0 size:self.headImageView.size];
}

@end
