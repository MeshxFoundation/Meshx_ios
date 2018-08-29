//
//  JMHomeSearchModel.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMBaseModel.h"
typedef NS_ENUM(NSInteger, JMHomeSearchType) {
    //搜索好友
    JMHomeSearchTypePeople = 0,
    //聊天记录
    JMHomeSearchTypeChatHistory,
};
@interface JMHomeSearchModel : JMBaseModel
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,assign) JMHomeSearchType type;
- (instancetype)initWithTitle:(NSString *)title type:(JMHomeSearchType)type dataArray:(NSArray *)dataArray;
@end
