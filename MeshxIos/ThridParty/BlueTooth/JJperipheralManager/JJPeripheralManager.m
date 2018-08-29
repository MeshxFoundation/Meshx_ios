//
//  JJPeripheralManager.m
//  JMBlueTooth
//
//  Created by JMZiXun on 2018/5/31.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JJPeripheralManager.h"
#import <objc/runtime.h>

NSString *const kJJBlueToothServiceUUID = @"FFF0";

NSString *const kJJBlueToothKnowledgeServiceUUID = @"7777";

////发送服务UUID
//NSString *const kJJBlueToothIOSServiceUUID = kJJBlueToothServiceUUID;
////搜索服务UUID
//NSString *const kJJBlueToothAndroidServiceUUID = kJJBlueToothServiceUUID;

//发送服务UUID
NSString *const kJJBlueToothIOSServiceUUID = @"FFF2";
//搜索服务UUID
NSString *const kJJBlueToothAndroidServiceUUID = @"FFF1";
NSString *const kJJBlueToothReadWriteCharacteristicUUID = @"0000fff1-0000-1000-8000-00805f9b34fb";

NSString *const kJJBlueToothNotifyCharacteristicUUID = @"0000fff2-0000-1000-8000-00805f9b34fb";

@interface JJPeripheralManager ()<CBPeripheralManagerDelegate>{
    
    //添加成功的service数量
    int _serviceNum;
}

@property (nonatomic ,strong) CBPeripheralManager *manager;
@property (nonatomic ,strong) NSDictionary *advertisementData;
@property (nonatomic ,strong) NSArray *services;
@property (nonatomic ,strong) CBMutableCharacteristic *notfiyCharacteristic;
@property (nonatomic ,strong) NSMutableDictionary *notfiyCharacteristicDictionary;
@property (nonatomic ,copy) peripheralManagerDidUpdateStateBack stateBack;
@property (nonatomic ,copy) didReceiveWriteRequestsBack receiveWriteRequestsBack;
@end

@implementation JJPeripheralManager

+ (instancetype)sharedInstance
{
    static JJPeripheralManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)startAdvertising:(NSDictionary<NSString *,id> *)advertisementData back:(peripheralManagerDidUpdateStateBack)back{
    [self startAdvertising:advertisementData queue:nil addServices:nil back:back];
}

+ (void)startAdvertising:(NSDictionary<NSString *, id> *)advertisementData queue:(dispatch_queue_t)queue addServices:(NSArray<CBMutableService *>*)addServices back:(peripheralManagerDidUpdateStateBack)back{
    
    [self startAdvertising:advertisementData queue:queue options:nil addServices:addServices back:back];
    
}


+ (void)startAdvertising:(NSDictionary<NSString *,id> *)advertisementData queue:(dispatch_queue_t)queue options:(NSDictionary<NSString *,id> *)options addServices:(NSArray<CBMutableService *> *)addServices back:(peripheralManagerDidUpdateStateBack)back{
    
    if (back) {
        [JJPeripheralManager sharedInstance].stateBack = [back copy];
    }
   
    
    if (!advertisementData) {
        advertisementData = @{
                               CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:kJJBlueToothIOSServiceUUID],[CBUUID UUIDWithString:kJJBlueToothKnowledgeServiceUUID]],
                              CBAdvertisementDataLocalNameKey : [JMMyInfo name]
                              };
    }
    [JJPeripheralManager sharedInstance].advertisementData = advertisementData;
     [JJPeripheralManager sharedInstance].services = addServices;
     [JJPeripheralManager sharedInstance].manager = [[CBPeripheralManager alloc]initWithDelegate:[JJPeripheralManager sharedInstance] queue:queue options:options];
}

//配置bluetooch的
-(void)setUp{
    
    [[JJPeripheralManager sharedInstance].manager removeAllServices];
    NSArray *services = [JJPeripheralManager sharedInstance].services;
    if (services.count) {
        [services enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[JJPeripheralManager sharedInstance].manager addService:obj];
        }];
    }else{
        
        CBMutableService *service = [self createService];
        [JJPeripheralManager sharedInstance].services = @[service];
        [[JJPeripheralManager sharedInstance].manager addService:service];
    }
    
}

- (CBMutableService *)createService{
    //characteristics字段描述
    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    //    /*
    //     只读的Characteristic
    //     properties：CBCharacteristicPropertyRead
    //     permissions CBAttributePermissionsReadable
    //     */
    //添加一个特性，可读，可写，可订阅
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kJJBlueToothReadWriteCharacteristicUUID] properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
    
    //添加一个特性，可订阅
    CBMutableCharacteristic *notifyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kJJBlueToothNotifyCharacteristicUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    //设置特性的描述
    CBMutableDescriptor *characteristicDescription = [[CBMutableDescriptor alloc]initWithType: CBUUIDCharacteristicUserDescriptionStringUUID value:[JMMyInfo name]];
    
    [notifyCharacteristic setDescriptors:@[characteristicDescription]];
    //service1初始化并加入两个characteristics
    CBMutableService *service = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:kJJBlueToothIOSServiceUUID] primary:YES];
    NSLog(@"%@",service.UUID);
    [service setCharacteristics:@[characteristic,notifyCharacteristic]];
    return service;
}

#pragma  mark -- CBPeripheralManagerDelegate

//peripheralManager状态改变
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    _isPoweredOn = NO;
    switch (peripheral.state) {
            //在这里判断蓝牙设别的状态  当开启了则可调用  setUp方法(自定义)
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"powered on");
            _isPoweredOn = YES;
            [self setUp];
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"powered off");
            [[JJPeripheralManager sharedInstance].manager stopAdvertising];
            break;
            
        default:
            break;
    }
    if (_stateBack) {
        _stateBack(peripheral.state);
    }
}

//perihpheral添加了service
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
        if (error == nil) {
            _serviceNum++;
        }
    
    //因为我们添加了2个服务，所以想两次都添加完成后才去发送广播
        if (_serviceNum==[JJPeripheralManager sharedInstance].services.count) {
            
    //添加服务后可以在此向外界发出通告 调用完这个方法后会调用代理的
    //(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
    [[JJPeripheralManager sharedInstance].manager startAdvertising:[JJPeripheralManager sharedInstance].advertisementData
     ];
    
        }

}

//peripheral开始发送advertising
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"in peripheralManagerDidStartAdvertisiong");
}

//订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    
    
    NSLog(@"订阅了UUIDString %@的数据---======central=%@",central.identifier.UUIDString,central);
    JJPeripheralNotfiy *notfiy =  [[JJPeripheralNotfiy alloc] initWithCharacteristic:(CBMutableCharacteristic *)characteristic central:central];
    [[JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary setObject:notfiy forKey:central.identifier.UUIDString];
   
    
}

//取消订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"取消订阅CBCharacteristic %@===%@的数据",characteristic,central);
    [[JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary removeObjectForKey:central.identifier.UUIDString];

}

//读characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"didReceiveReadRequest");
//    NSData *data = request.characteristic.value;
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        //对请求作出成功响应
        [[JJPeripheralManager sharedInstance].manager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [[JJPeripheralManager sharedInstance].manager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}


//写characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"didReceiveWriteRequests");
    CBATTRequest *request = requests[0];
    NSData *data = request.value;
    self.receiveWriteRequestsBack(data,request);
    //判断是否有写数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
        c.value = request.value;
        [[JJPeripheralManager sharedInstance].manager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [[JJPeripheralManager sharedInstance].manager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

/**
 接受别人写入我蓝牙的数据
 
 @param back 数据回调
 */
+ (void)readReceiveWriteData:(didReceiveWriteRequestsBack)back{
    if (back) {
        [JJPeripheralManager sharedInstance].receiveWriteRequestsBack  = back;
    }
}

- (BOOL)isAdvertising{
    return[JJPeripheralManager sharedInstance].manager.isAdvertising;
}

/**
 停止广播后，如果想在再次广播，可调用该方法
 */
+ (void)reStartAdvertising{
    
    if ([JJPeripheralManager sharedInstance].isPoweredOn) {
        [[JJPeripheralManager sharedInstance].manager startAdvertising:[JJPeripheralManager sharedInstance].advertisementData
         ];
    }
}

/**
 停止广播
 */
+ (void)stopAdvertising{
    [[JJPeripheralManager sharedInstance].manager stopAdvertising];
}

+ (void)clearData{
    [self stopAdvertising];
    [JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary = nil;
    [JJPeripheralManager sharedInstance].advertisementData = nil;
}

- (NSMutableDictionary *)notfiyCharacteristicDictionary{
    if (!_notfiyCharacteristicDictionary) {
        _notfiyCharacteristicDictionary = [NSMutableDictionary dictionary];
    }
    return _notfiyCharacteristicDictionary;
}

@end
