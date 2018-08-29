//
//  JMPeopleSearchController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMBaseSearchResultController.h"

@protocol JMPeopleSearchControllerDelegate <NSObject>
- (void)selectObj:(JMBaseModel *)obj;
@end

@interface JMPeopleSearchController : JMBaseSearchResultController
@property (nonatomic ,weak) id <JMPeopleSearchControllerDelegate> delegate;
//是否需要对Tabbar进行隐藏和显示操作
@property (nonatomic ,assign) BOOL isOperatingTabBar;
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (nonatomic ,strong) UILabel  *titleLabel;
@end
