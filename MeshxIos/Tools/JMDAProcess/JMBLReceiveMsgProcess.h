//
//  JMBLReceiveMsgProcess.h
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JMDAProcess.h"
typedef NS_ENUM(NSInteger, JMBLReceiveCommunicationType) {
    //作为主设，通过蓝牙与安卓手机通信
    JMBLReceiveCommunicationTypeBlueToothMainDesign = 0,
    //作为外设，通过蓝牙与安卓手机通信
    JMBLReceiveCommunicationTypeBlueToothPeripheral
};

@interface JMBLReceiveMsgProcess : NSObject

+ (instancetype)sharedInstance;

+ (void)receiveData:(NSData *)data obj:(id)obj type:(JMBLReceiveCommunicationType)type;

@end
