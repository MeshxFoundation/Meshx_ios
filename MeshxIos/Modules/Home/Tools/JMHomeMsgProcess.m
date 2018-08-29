//
//  JMHomeMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMHomeMsgProcess.h"
#import "JMHomeController.h"
#import "AppDelegate.h"
#import "JMChatController.h"
#import "JMReceiveMsgProcess.h"
#import "JMChatSendMsgBackProcess.h"
#import "JMBLReceiveMsgProcess.h"
@interface JMHomeMsgProcess ()

@property (nonatomic ,weak) JMHomeController *homeController;
@property (nonatomic ,strong) JMChatSendMsgBackProcess *msgBackProcess;
@end

@implementation JMHomeMsgProcess

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        self.homeController = (JMHomeController *)viewController;
        self.msgBackProcess = [JMChatSendMsgBackProcess new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionReceiveData:) name:kMCSessionReceiveDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatSendMsg:) name:kJMChatSendMsgNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draftMsg:) name:kJMDraftMsgNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDraftMsg:) name:kJMDeleteDraftMsgNotification object:nil];
    }
    return self;
}

- (void)sessionReceiveData:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;

    [JMReceiveMsgProcess receiveMsgWithModel:sessionModel message:^(XHMessage *message, JMChatController *chatController, BOOL isSuccess) {
        [self updateMessage:message sessionModel:sessionModel];
    }];

}

- (void)chatSendMsg:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    [self updateDataWithModel:sessionModel];
}

- (void)draftMsg:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    [self updateDataWithModel:sessionModel];
}

- (void)deleteDraftMsg:(NSNotification *)not{
    JMHomeModel *hModel = not.object;
    JMHomeModel *homeModel = [self getDataWithModel:hModel];
    if (homeModel) {
        homeModel.draftModel = nil;
        [self.homeController.tableView reloadData];
        [homeModel bg_saveOrUpdateAsync:^(BOOL isSuccess) {
            
        }];
    }
}


- (void)updateDataWithModel:(MCSessionModel *)sessionModel{
    
    if ([sessionModel.process.type isEqualToString:kJMChatMsgFileAPI]) {
        NSString *fileType = sessionModel.process.msg[@"fileType"];
        if ([fileType isEqualToString:kJMChatMsgFilePhotoType]) {
           XHMessage *message = [JMReceiveMsgProcess getPhotoMessageWithModel:sessionModel];
            [self updateMessage:message sessionModel:sessionModel];
        }else if ([fileType isEqualToString:kJMChatMsgFileVoiceType]){
             XHMessage *message = [JMReceiveMsgProcess getVoiceMessageWithModel:sessionModel];
            [self updateMessage:message sessionModel:sessionModel];
        }
        
       
    }else if ([sessionModel.process.type isEqualToString:kJMChatMsgTextAPI]){
        XHMessage *message = [JMReceiveMsgProcess getTextMessageWithModel:sessionModel];
        [self updateMessage:message sessionModel:sessionModel];
        
    }
  
}

- (void)updateMessage:(XHMessage *)message sessionModel:(MCSessionModel *)sessionModel{
    WEAKSELF;
    GCDGlobalQueue(^{
        STRONGSELF;
        @synchronized(strongSelf) {
            JMHomeModel *homeModel = [strongSelf getDataWithModel:sessionModel];
            
            if (homeModel) {
                [strongSelf.homeController.dataSources removeObject:homeModel];
            }else{
                homeModel = [JMHomeModel new];
                homeModel.peripheral = sessionModel.peripheral;
                homeModel.name = sessionModel.name;
                homeModel.userID = message.userID;
                homeModel.jid = sessionModel.jid;
            }
            //设置聊天通讯的类型
            [self setupTypeWithSessionModel:sessionModel model:homeModel];
            //判断信息是否为空，如果为空，说明是可能是编辑的草稿发送的通知
            if (message) {
                //聊天
                homeModel.message = message;
            }
            //草稿
            homeModel.draftModel = sessionModel.draftModel;
            if (sessionModel.peerID) {
                homeModel.peerID = sessionModel.peerID;
            }
            [strongSelf.homeController.dataSources insertObject:homeModel atIndex:0];
            [homeModel bg_saveOrUpdateAsync:^(BOOL isSuccess) {
                
            }];
            GCDMainQueue(^{
                [strongSelf.homeController.tableView reloadData];
                
            });
        }
        
    });
}

- (void)setupTypeWithSessionModel:(MCSessionModel *)sessionModel model:(JMHomeModel *)model{
   
    switch (sessionModel.receiveDataType) {
        case JMReceiveDataTypeXMPP:
        {
            model.communicationType = JMCommunicationTypeXMPP;
        }
            break;
        case JMReceiveDataTypeMultipeerConnectivity:
        {
            model.communicationType = JMCommunicationTypeMultipeerConnectivity;
            if (![model.peerID isEqual:sessionModel.peerID]&&sessionModel.peerID) {
                model.peerID = sessionModel.peerID;
            }
            
        }
            break;
        case JMReceiveDataTypeBlueToothMainDesign:
        {  //自身蓝牙作为主设
            model.communicationType = JMCommunicationTypeBlueToothMainDesign;
            if (![model.peripheral isEqual:sessionModel.peripheral]&&sessionModel.peripheral) {
                model.peripheral = sessionModel.peripheral;
            }
            
        }
            break;
        case JMReceiveDataTypeBlueToothPeripheral:
        {//自身蓝牙作为外围设备
            model.communicationType = JMCommunicationTypeBlueToothPeripheral;
            if (![model.notfiy isEqual:sessionModel.notfiy]&&sessionModel.notfiy) {
                model.notfiy = sessionModel.notfiy;
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (JMHomeModel *)getDataWithModel:(JMHomeModel *)hModel{
    __block JMHomeModel *model = nil;
    [self.homeController.dataSources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JMHomeModel *homeModel = (JMHomeModel *)obj;
        if ([homeModel.userID isEqualToString:hModel.userID]) {
            model = homeModel;
            *stop = YES;
        }
    }];
    return model;
}

//蓝牙连接
- (EasyPeripheral *)connectDeviceWithIdentifier:(NSString *)identifier{
    
  __block  EasyPeripheral *eperipheral = nil;
    //作为主设连接外设
    [[EasyBlueToothManager shareInstance] connectDeviceWithIdentifier:identifier callback:^(EasyPeripheral *peripheral, NSError *error) {
        
        if (peripheral&&!error) {
            eperipheral = peripheral;
            //外设更新数据，主设收到外设更新的数据进行处理
            [peripheral updateValueForCharacteristicWithBack:^(EasyPeripheral *peripheral, EasyCharacteristic *characteristic, NSError *error) {
                NSData *data = characteristic.characteristic.value;
                [JMBLReceiveMsgProcess receiveData:data obj:peripheral type:JMBLReceiveCommunicationTypeBlueToothMainDesign];
            }];
            [peripheral discoverDeviceServiceWithUUIDArray:nil callback:^(EasyPeripheral *peripheral, NSArray<EasyService *> *serviceArray, NSError *error) {
                
                for (EasyService *easyService in serviceArray) {
                    
                    [easyService discoverCharacteristicWithCallback:^(NSArray<EasyCharacteristic *> *characteristics, NSError *error) {
                        
                        for (EasyCharacteristic *easyChara in characteristics) {
                            CBCharacteristic *c = easyChara.characteristic;
                            if(c.properties & CBCharacteristicPropertyWrite){
                                peripheral.writeCharacteristic = c;
                                NSLog(@"可以写入");
                            }
                            if (c.properties & CBCharacteristicPropertyRead){
                                //            [peripheral readValueForCharacteristic:c];
                                NSLog(@"可以读");
                            }
                            if (c.properties & CBCharacteristicPropertyNotify){
                                [peripheral.peripheral setNotifyValue:YES forCharacteristic:c];
                                NSLog(@"可以订阅");
                            }
                        }
                        
                    }];
                }
            }];
        }
        
    }];
    return eperipheral;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
