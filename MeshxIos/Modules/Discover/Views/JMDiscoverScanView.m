//
//  JMDiscoverScanView.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/24.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMDiscoverScanView.h"
@interface JMDiscoverScanView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;
@end

@implementation JMDiscoverScanView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self changeLanguage];
}

- (void)changeLanguage{
    self.titleLabel.text = [JMLanguageManager jm_languageDiscover];
    self.promptLabel.text = [JMLanguageManager jm_languageSearching];
}

- (void)stop{
    [self.scanImageView.layer removeAnimationForKey:@"rotationAnimation"];
}
- (void)scan{
    [self rotateView:self.scanImageView];
}

- (void)rotateView:(UIImageView *)view

{
    CABasicAnimation *rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    
    rotationAnimation.duration = 6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
