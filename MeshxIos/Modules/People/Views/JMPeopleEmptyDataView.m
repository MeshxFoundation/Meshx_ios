//
//  JMPeopleEmptyDataView.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/24.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMPeopleEmptyDataView.h"
@interface JMPeopleEmptyDataView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPeopleButton;
@property (nonatomic ,copy) emptyDataViewAddPeople addPopleBack;

@end
@implementation JMPeopleEmptyDataView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.addPeopleButton.backgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    self.addPeopleButton.layer.masksToBounds = YES;
    self.addPeopleButton.layer.cornerRadius = 5;
}

+ (JMPeopleEmptyDataView *)createEmptyDataView{
    JMPeopleEmptyDataView *emptyDataView = XibWithClassName(JMPeopleEmptyDataView);
    emptyDataView.hidden = YES;
    return emptyDataView;
}
- (void)addPeople:(emptyDataViewAddPeople)addPeopleBack{
    if (addPeopleBack) {
        self.addPopleBack = addPeopleBack;
    }
}
- (void)hiddenEmptyDataView{
    self.hidden = YES;
}
- (void)showEmptyDataView{
    self.hidden = NO;
}

- (void)changeLanguage{
    [self.addPeopleButton setTitle:[JMLanguageManager jm_languageAddPeople] forState:UIControlStateNormal];
    [self.addPeopleButton setTitle:[JMLanguageManager jm_languageAddPeople] forState:UIControlStateHighlighted];
    self.titleLabel.text = [JMLanguageManager jm_languageNoPeoplesGoAddPeoples];
}

- (IBAction)addPeopleButtonClick:(id)sender {
    if (self.addPopleBack) {
       self.addPopleBack(sender);
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
