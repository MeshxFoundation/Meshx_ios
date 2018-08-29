//
//  JMMessageResendModel.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/8/1.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMMessageResendModel : NSObject
@property (nonatomic ,strong) XHMessage *message;
@property (nonatomic ,strong) JJTransportProcess *process;
@property (nonatomic ,strong) JMHomeModel *homeModel;
- (instancetype)initWithMessage:(XHMessage *)message process:(JJTransportProcess *)process homeModel:(JMHomeModel *)homeModel;
@end
