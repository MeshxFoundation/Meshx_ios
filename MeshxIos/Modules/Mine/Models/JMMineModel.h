//
//  JMMineModel.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/6.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMMineModel : JMBaseModel
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *icon;
- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon;
@end
