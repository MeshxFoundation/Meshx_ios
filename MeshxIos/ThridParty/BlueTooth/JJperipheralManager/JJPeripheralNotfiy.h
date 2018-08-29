//
//  JJPeripheralNotfiy.h
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/6.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface JJPeripheralNotfiy : NSObject
@property (nonatomic ,strong) CBMutableCharacteristic *characteristic;
@property (nonatomic ,strong) CBCentral *central;

- (instancetype)initWithCharacteristic:(CBMutableCharacteristic *) characteristic central:(CBCentral *)central;
@end
