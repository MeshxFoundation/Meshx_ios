//
//  JMNewFriendCell.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseTableViewCell.h"
@protocol JMNewFriendCellDelegate <NSObject>
- (void)lookNewFriend:(JMBaseModel *)model;
@end
@interface JMNewFriendCell : JMBaseTableViewCell

@property (nonatomic ,weak) id <JMNewFriendCellDelegate> delegate;

@end
