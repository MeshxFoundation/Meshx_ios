//
//  JJPeripheralNotfiy.m
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/6.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import "JJPeripheralNotfiy.h"

@implementation JJPeripheralNotfiy
- (instancetype)initWithCharacteristic:(CBMutableCharacteristic *) characteristic central:(CBCentral *)central{
    if (self = [super init]) {
        _characteristic = characteristic;
        _central = central;
    }
    return self;
}
@end
