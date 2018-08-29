//
//  JMBLSendMsgProcess.m
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import "JMBLSendMsgProcess.h"
#import "JMDAProcess.h"

NSString *const kJMBLSendMsgFailNotification = @"JMJMBLSendMsgFailNotification";

@interface JMSendMsgProcessModel : NSObject

@property (nonatomic,strong) NSData *data;
@property (nonatomic ,strong) CBCharacteristic *characteristic;
@property (nonatomic ,strong) JJPeripheralNotfiy *notfiy;
@property (nonatomic ,strong) CBPeripheral *peripheral;
@property (nonatomic ,assign) BOOL isFail;


- (instancetype)initWithData:(NSData *)data  notfiy:(JJPeripheralNotfiy *)notfiy;
- (instancetype)initWithData:(NSData *)data characteristic:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral;
@end

@implementation JMSendMsgProcessModel
- (instancetype)initWithData:(NSData *)data  notfiy:(JJPeripheralNotfiy *)notfiy{
    if (self = [super init]) {
        _data = data;
        _notfiy = notfiy;
        _characteristic = notfiy.characteristic;
        _peripheral = nil;
    }
    return self;
}
- (instancetype)initWithData:(NSData *)data characteristic:(CBCharacteristic *)characteristic peripheral:(CBPeripheral *)peripheral{
    if (self = [super init]) {
        _data = data;
        _characteristic = characteristic;
        _peripheral = peripheral;
        _notfiy = nil;
    }
    return self;
}
@end

@interface JMBLSendMsgProcess ()<CBPeripheralDelegate>
@property (nonatomic ,strong) NSMutableArray *sendDataSources;
@property (nonatomic ,assign) BOOL ifdo;
@property (nonatomic ,assign) BOOL isUpdating;
@property (nonatomic ,strong) JMSendMsgProcessModel *currentModel;
@end

@implementation JMBLSendMsgProcess

+ (instancetype)sharedInstance
{
    static JMBLSendMsgProcess *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.sendDataSources = [NSMutableArray array];
        sharedInstance.ifdo = NO;
    });
    return sharedInstance;
}

+ (void)sendMsgWithData:(NSData *)data peripheralNotfiy:(JJPeripheralNotfiy *)notfiy{
    
    [JMBLSendMsgProcess addSendMsgProcessModel:[[JMSendMsgProcessModel alloc] initWithData:data notfiy:notfiy]];
    if (![JMBLSendMsgProcess sharedInstance].ifdo) {
        [self sendMsgWithModel:[JMBLSendMsgProcess sharedInstance].sendDataSources.firstObject];
    }
}

+ (void)sendData:(NSMutableArray *)datas model:(JMSendMsgProcessModel *)model{
    CBMutableCharacteristic *characteristic = (CBMutableCharacteristic *)model.characteristic;
    NSData *data = datas.firstObject;
   BOOL isSuccess = [[JJPeripheralManager sharedInstance].manager updateValue:data forCharacteristic:characteristic onSubscribedCentrals:@[model.notfiy.central]];
    if (!isSuccess){
       [JMBLSendMsgProcess writeValueFailWithData:model.data];
        [self sendNextMsgWithOldModel:model];
        return;
    }else{
        NSArray *allKeys = [[JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary allKeys];
        if (![allKeys containsObject:model.notfiy.central.identifier.UUIDString]) {
            [JMBLSendMsgProcess writeValueFailWithData:model.data];
            [self sendNextMsgWithOldModel:model];
            return;
        }
    }
    [datas removeObjectAtIndex:0];
    if (datas.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self sendData:datas model:model];
        });
    }else{
        [JMBLSendMsgProcess writeValueSuccessWithData:model.data];
        [self sendNextMsgWithOldModel:model];
    }
}

+ (void)sendMsgWithData:(NSData *)data peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic{
    [JMBLSendMsgProcess addSendMsgProcessModel:[[JMSendMsgProcessModel alloc] initWithData:data characteristic:characteristic peripheral:peripheral]];
    if (![JMBLSendMsgProcess sharedInstance].ifdo) {
       [self sendMsgWithModel:[JMBLSendMsgProcess sharedInstance].sendDataSources.firstObject];
    }
}

+ (void)sendMsgWithModel:(JMSendMsgProcessModel *)model{
   
    [JMBLSendMsgProcess sharedInstance].ifdo = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *subDatas = [JMDAProcess disassembleWithData:model.data maximumUpdateValueLength:model.notfiy.central.maximumUpdateValueLength];
        NSLog(@"====蓝牙==发送文件总大小长度：%ld====",model.data.length);
        if (model.peripheral && model.characteristic) {
            NSLog(@"-------蓝牙作为主设备---发送消息-----");
            [JMBLSendMsgProcess sharedInstance].currentModel = model;
            model.peripheral.delegate = [JMBLSendMsgProcess sharedInstance];
            for (NSData *subData in subDatas) {
                //说明部分数据发送失败
                if (!model.isFail) {
                   [model.peripheral writeValue:subData forCharacteristic:model.characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
            [JMBLSendMsgProcess writeValueSuccessWithData:model.data];
            [JMBLSendMsgProcess sendNextMsgWithOldModel:model];
            
            return;
        }
        if (model.notfiy) {
            NSLog(@"-------蓝牙作为外围设备---发送消息-----");
            NSMutableArray *muDatas = [NSMutableArray arrayWithArray:subDatas];
            if (muDatas.count) {
                [self sendData:muDatas model:model];
            }
            return;
        }
        
        [JMBLSendMsgProcess writeValueFailWithData:model.data];
    });
    
}

+ (void)sendNextMsgWithOldModel:(JMSendMsgProcessModel *)model{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JMBLSendMsgProcess removeSendMsgProcessModel:model];
        if ([JMBLSendMsgProcess sharedInstance].sendDataSources.count) {
            JMSendMsgProcessModel *nextModel = [JMBLSendMsgProcess sharedInstance].sendDataSources.firstObject;
            [JMBLSendMsgProcess sendMsgWithModel:nextModel];
        }else{
            [JMBLSendMsgProcess sharedInstance].ifdo = NO;
        }
    });

}

+ (void)addSendMsgProcessModel:(JMSendMsgProcessModel *)model{
    [[JMBLSendMsgProcess sharedInstance].sendDataSources addObject:model];
}

+ (void)removeSendMsgProcessModel:(JMSendMsgProcessModel *)model{
    [[JMBLSendMsgProcess sharedInstance].sendDataSources removeObject:model];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        [JMBLSendMsgProcess sharedInstance].currentModel.isFail = YES;
        [JMBLSendMsgProcess writeValueFailWithData:[JMBLSendMsgProcess sharedInstance].currentModel.data];
    }
}


+ (void)writeValueFailWithData:(NSData *)data{
    
    JJTransportProcess *process = [JJTransportDecoder decoderWithData:data];
    
    if ([process.type isEqualToString:kJMChatMsgTextAPI]) {
        GCDMainQueue(^{
            NSString *eventID = process.msg[@"eventID"];
           [[NSNotificationCenter defaultCenter] postNotificationName:kJMBLSendMsgFailNotification object:eventID];
        });
    }
   
}

+ (void)writeValueSuccessWithData:(NSData *)data{
    JJTransportProcess *process = [JJTransportDecoder decoderWithData:data];
 
    if ([process.type isEqualToString:kJMChatMsgTextAPI]) {
        GCDMainQueue((^{
            MCSessionModel *model = [MCSessionModel new];
            process.type = kJMChatMsgBackAPI;
            NSDictionary *dic = process.msg;
            process.msg = @{@"userID":dic[@"userID"],@"eventID":dic[@"eventID"]};
            model.process = process;
            [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:model];
        }));
    }
}

@end
