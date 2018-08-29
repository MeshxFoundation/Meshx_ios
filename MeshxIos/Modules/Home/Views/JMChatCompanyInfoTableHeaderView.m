//
//  JMChatCompanyInfoTableHeaderView.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMChatCompanyInfoTableHeaderView.h"
#import "JMChatCompanyInfoHeaderView.h"
static NSInteger const kJMChatCompanyInfoHeaderViewCount = 5;
//头像距离左边距离
#define kImageLeft 10
#define kImageHW (kScreen_Width-kImageLeft)/kJMChatCompanyInfoHeaderViewCount

@implementation JMChatCompanyInfoTableHeaderView

- (void)showViewWithDatas:(NSArray *)datas viewController:(JMChatCompanyInfoController *)viewController{
    NSInteger count = datas.count;
    NSInteger topbottom = 10;
    NSInteger interval = 5;
//    if (isAddButton) {
//        count = count +1;
//    }
    NSInteger num = 0;
    if (count<kJMChatCompanyInfoHeaderViewCount) {
        
        num = 1;
    }else{
        
        if (count%kJMChatCompanyInfoHeaderViewCount==0) {
            
            num = count/kJMChatCompanyInfoHeaderViewCount;
        }else{
            
            num = count/kJMChatCompanyInfoHeaderViewCount+1;
        }
    }
    NSInteger height = kImageHW*num+(num-1)*interval+topbottom*2;
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
    for (int i = 0; i < datas.count; i ++) {
        
        NSInteger row = i/kJMChatCompanyInfoHeaderViewCount;
        NSInteger intervalToal = 0;
        if (row>0) {
            intervalToal = row*interval;
        }
        JMBaseModel *model = datas[i];
        JMChatCompanyInfoHeaderView *headerView = XibWithClassName(JMChatCompanyInfoHeaderView);
        headerView.frame = CGRectMake(kImageLeft+i%kJMChatCompanyInfoHeaderViewCount *kImageHW, row*kImageHW+intervalToal+topbottom, kImageHW-kImageLeft, kImageHW);
        headerView.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick:)];
        [headerView addGestureRecognizer:tap];
        [self addSubview:headerView];
    }
};

- (void)selectClick:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(selectModel:)]) {
        JMChatCompanyInfoHeaderView *view = (JMChatCompanyInfoHeaderView *)tap.view;
        [self.delegate selectModel:view.model];
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
