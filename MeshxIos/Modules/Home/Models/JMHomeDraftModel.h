//
//  JMHomeDraftModel.h
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/25.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMHomeDraftModel : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *timestamp;
- (instancetype)initWithText:(NSString *)text timestamp:(NSDate *)timestamp;
@end
