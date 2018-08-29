//
//  JMHomeMsgProcess.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMHomeModel.h"
#import "MCSessionModel.h"

@interface JMHomeMsgProcess : NSObject
- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)updateDataWithModel:(MCSessionModel *)sessionModel;
- (JMHomeModel *)getDataWithModel:(JMHomeModel *)hModel;
//蓝牙连接
- (EasyPeripheral *)connectDeviceWithIdentifier:(NSString *)identifier;
@end
