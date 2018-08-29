//
//  JMChatConnectionProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/2.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMChatConnectionProcess.h"
#import "JMChatController.h"
#import "JMPeopleModel.h"
#import "JMDiscoverController.h"
#import "JJPeripheralManager.h"
#import "JMBLReceiveMsgProcess.h"
#import "JMHomeController.h"

@interface JMChatConnectionProcess (){
    NSString *_homeModelString;
    NSString *_isFriendString;
    NSString *_isAvailableString;
}

@property (nonatomic ,weak) JMChatController *chatController;
@property (nonatomic ,assign) BOOL ifdo;
@end
@implementation JMChatConnectionProcess
- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _chatController = (JMChatController *)viewController;
        _homeModelString = KObjKeyPath(_chatController, homeModel) ;
        _isFriendString = KObjKeyPath(_chatController, isFriend);
        _isAvailableString = KObjKeyPath(_chatController, isAvailable);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPeer:) name:kMCSessionBrowserFoundPeerNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findBluePeripherals:) name:kJMFindBluePeripheralsNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:) name:kMCSessionReceiveDataNotification object:nil];
    }
    return self;
}

- (void)receiveData:(NSNotification *)not{
    MCSessionModel *model = not.object;
    if ([model.name isEqualToString:self.chatController.homeModel.name] && [model.process.type isEqualToString:kJMChatMsgTextAPI]) {
        switch (model.receiveDataType) {
            case JMReceiveDataTypeXMPP:
            {
             self.chatController.homeModel.communicationType = JMCommunicationTypeXMPP;
            }
                break;
            case JMReceiveDataTypeMultipeerConnectivity:
            {
             self.chatController.homeModel.communicationType = JMCommunicationTypeMultipeerConnectivity;
                if (![self.chatController.homeModel.peerID isEqual:model.peerID]) {
                    self.chatController.homeModel.peerID = model.peerID;
                }
               
            }
                break;
            case JMReceiveDataTypeBlueToothMainDesign:
            {  //自身蓝牙作为主设
                self.chatController.homeModel.communicationType = JMCommunicationTypeBlueToothMainDesign;
                if (![self.chatController.homeModel.peripheral isEqual:model.peripheral]) {
                    self.chatController.homeModel.peripheral = model.peripheral;
                }
                
            }
                break;
            case JMReceiveDataTypeBlueToothPeripheral:
            {//自身蓝牙作为外围设备
                self.chatController.homeModel.communicationType = JMCommunicationTypeBlueToothPeripheral;
                if (![self.chatController.homeModel.notfiy isEqual:model.notfiy]) {
                    self.chatController.homeModel.notfiy = model.notfiy;
                }
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:_homeModelString]) {
        JMHomeModel *home = change[@"new"];
        [self setupChatHomeModel:home];
    }else if ([keyPath isEqualToString:_isFriendString]){
        BOOL isFriend = [change[@"new"] boolValue];
         [self setupIsFriend:isFriend];
    }else if ([keyPath isEqualToString:_isAvailableString]){
        BOOL isAvailable = [change[@"new"] boolValue];
        [self setupIsAvailable:isAvailable];
    }
}

- (void)foundPeer:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    if (![sessionModel.peerID.jj_displayName isEqualToString:self.chatController.homeModel.name]) {
        return;
    }
    self.chatController.homeModel.peerID = sessionModel.peerID;
//    非好友
    if (!self.chatController.isFriend) {
        [MCSessionProcess invitePeer:sessionModel.peerID state:MCSessionStateNotConnected];
        self.chatController.homeModel.communicationType = JMCommunicationTypeMultipeerConnectivity;
    }else{
        //是好友，但不在线
        if (!self.chatController.isAvailable) {

            [MCSessionProcess invitePeer:sessionModel.peerID state:MCSessionStateNotConnected];
            self.chatController.homeModel.communicationType = JMCommunicationTypeMultipeerConnectivity;
        }
    }
}

- (void)findBluePeripherals:(NSNotification *)not{
    JMHomeModel *model = not.object;
    if ([model.name isEqualToString:self.chatController.homeModel.name]) {
        //非好友
        if (!self.chatController.isFriend) {
            [self connetDeviceWithModel:model];
        }else{
            //是好友，但不在线
            if (!self.chatController.isAvailable) {
                [self connetDeviceWithModel:model];
            }
        }
    }
    
}

- (void)setupChatHomeModel:(JMHomeModel *)homeModel{
    NSLog(@"===%s===%@====",__func__,homeModel);
   
        GCDGlobalQueue(^{
            if ([self setupCommunication]) {
                JMPeopleModel *model =[JMPeopleModel findFriendWithUserID:self.chatController.homeModel.userID];
                if (model) {
                    self.ifdo = YES;
                    self.chatController.isFriend = YES;
                    self.ifdo = NO;
                }
                return;
            }
            //设置好友是否在线
            BOOL isAvailable = [[JMXMPPTool sharedInstance].rosterTool isAvailableWithJid:self.chatController.homeModel.jid];
            JMPeopleModel *model =[JMPeopleModel findFriendWithUserID:self.chatController.homeModel.userID];
            GCDMainQueue(^{
                self.chatController.isAvailable = isAvailable;
                if (model) {
                    self.chatController.isFriend = YES;
                }else{
                    self.chatController.isFriend = NO;
                }
                
            });
        });
}

- (BOOL)setupCommunication{
    JMHomeModel *homeModel = self.chatController.homeModel;
    if (homeModel.peerID && homeModel.communicationType == JMCommunicationTypeMultipeerConnectivity && [[MCSessionProcess sharedInstance].sessionManager.connectedPeers containsObject:homeModel.peerID]) {
        return YES;
    }
    
    if (homeModel.notfiy && homeModel.communicationType == JMCommunicationTypeBlueToothPeripheral) {
        NSArray *allKeys = [[JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary allKeys];
        return [allKeys containsObject:homeModel.notfiy.central.identifier.UUIDString];
    }
    
    if (homeModel.peripheral && homeModel.communicationType == JMCommunicationTypeBlueToothMainDesign) {
        NSArray *allValues = [EasyBlueToothManager shareInstance].centerManager.connectedDeviceDict.allValues;
        for (EasyPeripheral *peripheral in allValues) {
            if ([peripheral.peripheral isEqual:homeModel.peripheral.peripheral]) {
                return YES;
            }
        }
        return NO;
    }
    
    return NO;
}

- (void)setupIsFriend:(BOOL)isFriend{
    
    if (self.ifdo) {
        return;
    }
    
    if ([self isXMPP]) {
        return;
    }
    //说明非好友
    if (!isFriend) {
        // 进行无网通信
        [self noNetwordConnet];
    }else{
        //说明是好友，但对方不在线
        if (!self.chatController.isAvailable) {
           [self noNetwordConnet];
        }
    }
}



- (void)setupIsAvailable:(BOOL)isAvailable{
    
    if ([self isXMPP]) {
        return;
    }
    if (self.chatController.isFriend&&!isAvailable) {
         [self noNetwordConnet];
    }
}

- (BOOL)isXMPP{
    if (self.chatController.isAvailable&&self.chatController.isFriend) {
        self.chatController.homeModel.communicationType = JMCommunicationTypeXMPP;
        return YES;
    }
    return NO;
}


- (void)noNetwordConnet{
    JMHomeModel *model = [self getNoNetworkModel];
    if (model) {
        [self connetDeviceWithModel:model];
    }else{
        
        if (self.chatController.isFriend) {
            self.chatController.homeModel.communicationType = JMCommunicationTypeXMPP;
        }else{
            self.chatController.homeModel.communicationType = JMCommunicationTypeNormal;
        }
        
    }
}

- (JMHomeModel *)getNoNetworkModel{
    JMDiscoverController  *discoverController = (JMDiscoverController *)[JMTabBarController getControllerWithClass:[JMDiscoverController class]];
    for (JMHomeModel *model in discoverController.dataSources) {
        if ([model.userID isEqualToString:self.chatController.homeModel.userID]) {
            return model;
        }
    }
    return nil;
}

- (void)connetDeviceWithModel:(JMHomeModel *)model{
    
    switch (model.communicationType) {
        case JMCommunicationTypeMultipeerConnectivity:
        {
            NSLog(@"=====MultipeerConnectivity===");
            self.chatController.homeModel.communicationType = JMCommunicationTypeMultipeerConnectivity;
            self.chatController.homeModel.peerID = model.peerID;
            [MCSessionProcess invitePeer:model.peerID state:MCSessionStateNotConnected];
        }
            break;
        case JMCommunicationTypeBlueToothMainDesign:
        {
            self.chatController.homeModel.peripheral = model.peripheral;
            //作为外设
            NSMutableDictionary *dic = [JJPeripheralManager sharedInstance].notfiyCharacteristicDictionary;
            JJPeripheralNotfiy *notfiy = [dic objectForKey:model.peripheral.identifierString];
            if (notfiy) {
                NSLog(@"======蓝牙作为外围设备---连接======");
                self.chatController.homeModel.notfiy = notfiy;
                self.chatController.homeModel.communicationType =JMCommunicationTypeBlueToothPeripheral;
                return;
            }
            self.chatController.homeModel.communicationType = JMCommunicationTypeBlueToothMainDesign;
            NSLog(@"======蓝牙作为主设备---连接======");
            [self connectDeviceWithIdentifier:model.peripheral.identifierString];
            
        }
            break;
            
        default:
            break;
    }
}

//蓝牙连接
- (void)connectDeviceWithIdentifier:(NSString *)identifier{
    
    JMBaseNavigationController *firstNav = [JMTabBarController viewControllers].firstObject;
    JMHomeController *homeController = firstNav.viewControllers.firstObject;
    EasyPeripheral *peripheral = [homeController.msgProcess connectDeviceWithIdentifier:identifier];
    if (peripheral) {
        self.chatController.homeModel.peripheral = peripheral;
    }
}


@end
