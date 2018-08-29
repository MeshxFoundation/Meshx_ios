//
//  JMBLReceiveMsgProcess.m
//  BlueTooth
//
//  Created by JMZiXun on 2018/6/1.
//  Copyright © 2018年 BFMobile. All rights reserved.
//

#import "JMBLReceiveMsgProcess.h"
#import "AppDelegate.h"
#import "MCSessionModel.h"
#import "EasyPeripheral.h"

@interface JMBLReceiveMsgProcess ()

@property (nonatomic ,strong) NSMutableDictionary *dataDictionary;

@end

@implementation JMBLReceiveMsgProcess

+ (JMBLReceiveMsgProcess *)sharedInstance
{
    static JMBLReceiveMsgProcess *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.dataDictionary = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

+ (void)receiveData:(NSData *)data obj:(id)obj type:(JMBLReceiveCommunicationType)type{
    CBPeer *peer = nil;
    if (type == JMBLReceiveCommunicationTypeBlueToothMainDesign) {
        EasyPeripheral *easyP = (EasyPeripheral *)obj;
        peer = easyP.peripheral;
    }else{
      CBATTRequest *request = (CBATTRequest *)obj;
      peer = request.central;
    }
    NSInteger firstByte = [JMDAProcess firstByteWithData:data];
    if (firstByte == 0) {
         NSData *contentData = [JMDAProcess getContentData:data];
         [self showContentData:contentData obj:obj type:type];
        return;
    }else if (firstByte == 1){
        [self saveData:data identifier:peer.identifier.UUIDString];
        return;
    }
    
    NSData *dicData = [JMBLReceiveMsgProcess sharedInstance].dataDictionary[peer.identifier.UUIDString];
    if (dicData.length) {
    
        NSData *nowAddData = [JMDAProcess assemblyWithData:dicData addData:data];
        if (firstByte == 2) {
            [self saveData:nowAddData identifier:peer.identifier.UUIDString];
        }
        if (firstByte == 3) {
            [[JMBLReceiveMsgProcess sharedInstance].dataDictionary removeObjectForKey:peer.identifier.UUIDString];
            NSData *contentData = [JMDAProcess getContentData:nowAddData];
            NSData *md5Data = [nowAddData subdataWithRange:NSMakeRange(kJMSendMsgHeadTypeLength, kJMSendMsgMD5HeadLength)];
            NSString *md5String = [[md5Data md5String] uppercaseString];
            NSData *contentMD5DataHead = [JMDAProcess getMD5_4WithData:contentData];
            if ([[[contentMD5DataHead md5String] uppercaseString] isEqualToString:md5String]) {
                [self showContentData:contentData obj:obj type:type];
            }
            return;
        }
    }
}

+ (void)showContentData:(NSData *)data obj:(id)obj type:(JMBLReceiveCommunicationType)type{
    
    switch (type) {
            //自身作为主设接收的信息
        case JMBLReceiveCommunicationTypeBlueToothMainDesign:
        {
            JJTransportProcess *process = [JJTransportDecoder decoderWithData:data];
            MCSessionModel *model = [[MCSessionModel alloc] initWithPeripheral:obj process:process];
            model.receiveDataType = JMReceiveDataTypeBlueToothMainDesign;
            model.jid = [JMXMPPUserManager getJidWithName:process.msg[@"userName"]];
            NSLog(@"===自身蓝牙作为主设接收的信息====%@======",process.msg);
             [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:model];
        }
            break;
            //自身作为外设接收的信息
        case JMBLReceiveCommunicationTypeBlueToothPeripheral:
        {
            CBATTRequest *request = (CBATTRequest *)obj;
            JJTransportProcess *process = [JJTransportDecoder decoderWithData:data];
            MCSessionModel *model = [[MCSessionModel alloc] initWithNotfiy:[[JJPeripheralNotfiy alloc] initWithCharacteristic:(CBMutableCharacteristic *)request.characteristic central:request.central] process:process];
            model.receiveDataType = JMReceiveDataTypeBlueToothPeripheral;
             model.jid = [JMXMPPUserManager getJidWithName:process.msg[@"userName"]];
            NSLog(@"===自身蓝牙作为外设接收的信息====%@======",process.msg);
             [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:model];
        }
            break;
            
        default:
            break;
    }
    
    
//     NSString *title = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alertController addAction:alertAction];
//        [appDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    NSLog(@"======接收到的数据=====长度：%ld==%@=======",data.length,title);
}

+ (void)saveData:(NSData *)data identifier:(NSString *)identifier{
     [[JMBLReceiveMsgProcess sharedInstance].dataDictionary setObject:data forKey:identifier];
}

@end
