//
//  JMHomeSearchChatModel.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMHomeSearchChatModel : JMBaseModel
@property (nonatomic ,strong) NSArray <XHMessage *>*messages;
@property (nonatomic ,strong) NSString *userID;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *resultStr;
- (instancetype)initWithUserID:(NSString *)userID messages:(NSArray<XHMessage *>*)messages;

@end
