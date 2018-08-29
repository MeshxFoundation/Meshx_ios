//
//  JMChatCompanyInfoTableHeaderView.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMChatCompanyInfoController;

@protocol JMChatCompanyInfoTableHeaderViewDelegate <NSObject>
- (void)selectModel:(JMBaseModel *)model;
@end

@interface JMChatCompanyInfoTableHeaderView : UIView
- (void)showViewWithDatas:(NSArray *)datas viewController:(JMChatCompanyInfoController *)viewController;
@property (nonatomic ,weak) id <JMChatCompanyInfoTableHeaderViewDelegate> delegate;

@end
