//
//  JMSearchChatContentController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseViewController.h"
#import "JMHomeSearchChatModel.h"
#import "JMHomeModel.h"
@protocol JMSearchChatContentControllerDelegate <NSObject>
- (void)selectChatHistoryWithModel:(JMHomeModel *)homeModel;
@end
@interface JMSearchChatContentController : JMBaseViewController
@property (nonatomic ,weak) id <JMSearchChatContentControllerDelegate> delegate;
@property (nonatomic ,strong) JMBaseModel *model;
@property (nonatomic ,strong) JMHomeSearchChatModel *chatModel;
@end
