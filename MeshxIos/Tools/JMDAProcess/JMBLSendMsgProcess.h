//
//  JMBLSendMsgProcess.h
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JJPeripheralManager.h"

extern NSString *const kJMBLSendMsgFailNotification;

@interface JMBLSendMsgProcess : NSObject
+ (void)sendMsgWithData:(NSData *)data peripheralNotfiy:(JJPeripheralNotfiy *)notfiy;
+ (void)sendMsgWithData:(NSData *)data peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
@end
