//
//  JMHomeSearchController.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMBaseViewController.h"
#import "JMBaseSearchResultController.h"
#import "JMPeopleModel.h"
@protocol JMHomeSearchControllerDelegate <NSObject>
- (void)selectPeople:(JMPeopleModel *)peopleModel;
- (void)selectPeopleChatHistoryWithModel:(JMHomeModel *)homeModel;
@end
@interface JMHomeSearchController : JMBaseSearchResultController
@property (nonatomic ,weak) id <JMHomeSearchControllerDelegate> delegate;
@end
