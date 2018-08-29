//
//  JMPeopleEmptyDataView.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/24.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMPeopleEmptyDataView;
typedef void(^emptyDataViewAddPeople)(id sender);


@interface JMPeopleEmptyDataView : UIView

+ (JMPeopleEmptyDataView *)createEmptyDataView;
- (void)addPeople:(emptyDataViewAddPeople)addPeopleBack;
- (void)hiddenEmptyDataView;
- (void)showEmptyDataView;
- (void)changeLanguage;
@end
