//
//  JMSearchChatContentCell.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMHomeSearchChatModel.h"
@interface JMSearchChatContentCell : JMBaseTableViewCell
@property (nonatomic ,strong) XHMessage *message;
- (void)setupViewWithMessage:(XHMessage *)message searchText:(NSString *)searchText;
- (void)setupViewWithChatModel:(JMHomeSearchChatModel *)chatModel searchText:(NSString *)searchText;
@end
