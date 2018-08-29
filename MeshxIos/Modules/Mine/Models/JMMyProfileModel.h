//
//  JMMyProfileModel.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/10.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMMyProfileModel : JMBaseModel
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *icon;
@property (nonatomic ,strong) NSString *title;
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;
- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name;
@end
