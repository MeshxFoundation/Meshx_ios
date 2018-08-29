//
//  JMSearchChatContentCell.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMSearchChatContentCell.h"
#import "JMDateManager.h"

@interface JMSearchChatContentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation JMSearchChatContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    // Initialization code
}

- (void)setupViewWithMessage:(XHMessage *)message searchText:(NSString *)searchText{
    _message = message;
    [self setupHeadImageViewWithMessage:message];
    self.nameLabel.text = message.sender;
    
    self.timeLabel.text = [JMDateManager getStringTime:message.timestamp];
    [self setupContentTextWithMessage:message searchText:searchText];
}

- (void)setupViewWithChatModel:(JMHomeSearchChatModel *)chatModel searchText:(NSString *)searchText{
    self.jm_model = chatModel;
    XHMessage *message = chatModel.messages.firstObject;
    UIImage *image = [JMHeaderImageManager imageWithUserID:message.userID];
    self.headImageView.image = [image jj_imageAddCornerWithRadius:CGRectGetWidth(self.headImageView.frame)/2.0 size:self.headImageView.size];
    
    self.nameLabel.text = chatModel.name;
    if (chatModel.messages.count == 1) {
        [self setupContentTextWithMessage:message searchText:searchText];
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"%ld%@",chatModel.messages.count,[JMLanguageManager jm_languageRelatedMessage]];
    }
    self.timeLabel.hidden = YES;
    
}

- (void)setupHeadImageViewWithMessage:(XHMessage *)message{
    UIImage *image = nil;
    if (message.bubbleMessageType == XHBubbleMessageTypeSending) {
        image = [JMMyInfo headerImage];
        
    }else {
        image = [JMHeaderImageManager imageWithUserID:message.userID];
    }
    self.headImageView.image = [image jj_imageAddCornerWithRadius:CGRectGetWidth(self.headImageView.frame)/2.0 size:self.headImageView.size];
}

- (void)setupContentTextWithMessage:(XHMessage *)message searchText:(NSString *)searchText{
    
    UIColor *addColor = [UIColor colorWithHexString:kJMMainColorHexString];
    NSMutableAttributedString * aAttributedString =[[NSMutableAttributedString alloc] initWithString:message.text];
    NSRange range = [message.text rangeOfString:searchText options:NSCaseInsensitiveSearch];
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:addColor
                              range:range];
    self.contentLabel.attributedText = aAttributedString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
