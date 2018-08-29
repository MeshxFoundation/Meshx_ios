//
//  JMDiscoverProcess.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDiscoverProcess : NSObject
- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)scanForPeripherals;
- (void)reScan;
- (void)reloadData;
- (void)removeAllDatas;
@end
