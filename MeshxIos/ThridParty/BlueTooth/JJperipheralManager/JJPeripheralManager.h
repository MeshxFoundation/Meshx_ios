//
//  JJPeripheralManager.h
//  JMBlueTooth
//
//  Created by JMZiXun on 2018/5/31.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JJPeripheralNotfiy.h"

//发送服务UUID
extern NSString *const kJJBlueToothIOSServiceUUID;
extern NSString *const kJJBlueToothKnowledgeServiceUUID;
//搜索安卓服务UUID
extern NSString *const kJJBlueToothAndroidServiceUUID;
extern NSString *const kJJBlueToothReadWriteCharacteristicUUID;
extern NSString *const kJJBlueToothNotifyCharacteristicUUID;

typedef void(^peripheralManagerDidUpdateStateBack) (CBPeripheralManagerState state);
typedef void(^didReceiveWriteRequestsBack)(NSData *data ,CBATTRequest* request);

@interface JJPeripheralManager : NSObject

+ (instancetype)sharedInstance;

//蓝牙是否是开的;
@property (nonatomic ,assign,readonly) BOOL isPoweredOn;
@property (nonatomic ,strong,readonly) CBPeripheralManager *manager;
@property (nonatomic ,strong,readonly) NSDictionary *advertisementData;
@property (nonatomic, assign, readonly) BOOL isAdvertising;
@property (nonatomic ,strong,readonly) NSMutableDictionary *notfiyCharacteristicDictionary;

+ (void)startAdvertising:(NSDictionary<NSString *, id> *)advertisementData back:(peripheralManagerDidUpdateStateBack)back;

+ (void)startAdvertising:(NSDictionary<NSString *, id> *)advertisementData queue:(dispatch_queue_t)queue addServices:(NSArray<CBMutableService *>*)addServices back:(peripheralManagerDidUpdateStateBack)back;

+ (void)startAdvertising:(NSDictionary<NSString *, id> *)advertisementData queue:(dispatch_queue_t)queue options:(NSDictionary<NSString *, id> *)options addServices:(NSArray<CBMutableService *>*)addServices back:(peripheralManagerDidUpdateStateBack)back;

/**
 停止广播后，如果想在再次广播，可调用该方法
 */
+ (void)reStartAdvertising;

/**
 停止广播
 */
+ (void)stopAdvertising;

+ (void)clearData;
/**
 接受别人写入我蓝牙的数据

 @param back 数据回调
 */
+ (void)readReceiveWriteData:(didReceiveWriteRequestsBack)back;

@end
