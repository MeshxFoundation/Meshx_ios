//
//  JMMineCell.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/23.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMMineCell.h"
#import "JMMineModel.h"
#import "JMLanguageTool.h"
@interface JMMineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *tLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
@implementation JMMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setJm_model:(JMBaseModel *)jm_model{
    [super setJm_model:jm_model];
    JMMineModel *model = (JMMineModel *)jm_model;
    self.subLabel.text = @"";
    if ([model.name isEqualToString:[JMLanguageManager jm_languageLanguage]]) {
//        self.subLabel.hidden = NO;
        self.subLabel.text = [JMLanguageTool currentCountryLanguage:kLanguageManager.currentLanguage];
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }else if ([model.name isEqualToString:[JMLanguageManager jm_languageLogOut]]){
//        self.subLabel.hidden = YES;
        self.accessoryType =  UITableViewCellAccessoryNone;
    }else if ([model.name isEqualToString:[JMLanguageManager jm_languageAboutUs]]){
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//        self.subLabel.hidden = YES;
    }else if ([model.name isEqualToString:[JMLanguageManager jm_languageCurrencyUnit]]){
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//        self.subLabel.hidden = NO;
    }else{
        self.accessoryType =  UITableViewCellAccessoryNone;
//        self.subLabel.hidden = YES;
    }
    self.tLabel.text = model.name;
    self.iconImageView.image = [UIImage imageNamed:model.icon];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
