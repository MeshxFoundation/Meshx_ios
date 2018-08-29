//
//  JMHomeCell.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/25.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMHomeCell.h"
#import "WZLBadgeImport.h"
#import "JMReceiveMsgProcess.h"
#import "JMDateManager.h"

@interface JMHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptLabelWidth;

@end

@implementation JMHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.hidden = YES;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setModel:(JMHomeModel *)model{
    _model = model;
    [self setupCellWithModel:model];
}

- (void)setupCellWithModel:(JMHomeModel *)model{
    CGSize size =self.headImageView.frame.size;
    self.headImageView.image = [[JMHeaderImageManager imageWithUserID:model.userID] jj_imageAddCornerWithRadius:size.width size:size];
    self.nameLabel.text = model.name;
    [self setupMsg:model];
    [self setupPrompt];
}

- (void)setupMsg:(JMHomeModel *)model{
    if (model.draftModel.text.length) {
        [self setupDraftText:model];
        self.timeLabel.text = [JMDateManager getStringTime:model.draftModel.timestamp];
    }else{
        self.msgLabel.attributedText = [[NSAttributedString alloc] initWithString:model.message.text];
        self.timeLabel.text = [JMDateManager getStringTime:model.message.timestamp];
    }
}

- (void)setupDraftText:(JMHomeModel *)model{
    
    NSString *dra = @"[草稿]";
   NSString *text = [NSString stringWithFormat:@"%@%@",dra,model.draftModel.text];
    UIColor *addColor = [UIColor redColor];
    NSMutableAttributedString * aAttributedString =[[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:dra options:NSCaseInsensitiveSearch];
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:addColor
                              range:range];
    self.msgLabel.attributedText = aAttributedString;
    
}

- (void)setupPrompt{
    GCDGlobalQueue(^{
        NSInteger count = [JMReceiveMsgProcess getBadgeBadgeWithUserID:self.model.userID];
//        count = 100;
        GCDMainQueue((^{
            if (count) {
                NSString *promptText = [NSString stringWithFormat:@"%@",@(count)];
                CGRect rect = self.promptLabel.frame;
                if (count>99) {
                    promptText = @"99+";
                    self.promptLabelWidth.constant = rect.size.height*2;
                }else{
                    self.promptLabelWidth.constant = rect.size.height;
                }
                self.promptLabel.hidden = NO;
                self.promptLabel.layer.cornerRadius = CGRectGetHeight(self.promptLabel.frame)/2.0;
                self.promptLabel.text = promptText;
            }else{
                self.promptLabel.hidden = YES;
            }
        }));
    });
}

+ (CGFloat)jm_cellHeight{
    return 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
