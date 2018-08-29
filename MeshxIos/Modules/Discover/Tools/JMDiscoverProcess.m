//
//  JMDiscoverProcess.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMDiscoverProcess.h"
#import "JMDiscoverController.h"
#import "JJPeripheralManager.h"
#import "MCSessionProcess.h"

@interface JMDiscoverProcess()
@property (nonatomic ,weak) JMDiscoverController *discoverController;
@property (nonatomic ,strong) MCSessionProcess *sessionProcess;
@end

@implementation JMDiscoverProcess

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        self.discoverController = (JMDiscoverController *)viewController;
        [self addMCSessionNotification];
//        [self initDiscoverDevice];
    }
    return self;
}

- (void)addMCSessionNotification{
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPeer:) name:kMCSessionBrowserFoundPeerNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lostPeer:) name:kMCSessionBrowserLostPeerNotification object:nil];
      [self scanForPeripherals];
}

- (void)scanForPeripherals{
    
    if (SIMULATOR) {
        return;
    }
    
}

- (void)scanForPeripheralsWithServices:(NSArray *)service{
    
    
    [[EasyBlueToothManager shareInstance].centerManager scanDeviceWithTimeInterval:NSIntegerMax services:service options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)} callBack:^(EasyPeripheral *peripheral, searchFlagType searchType) {
  NSLog(@"==%@=====%@==%@=",peripheral.advertisementData,peripheral.name,peripheral.identifierString);
        if (peripheral) {
            JMHomeModel *model = [self getModelWithName:peripheral.name];
            if (searchType&searchFlagTypeChanged || searchType&searchFlagTypeAdded) {
                
                if (model) {
                    model.peripheral = peripheral;
                }else{
                    
                    model = [JMHomeModel new];
                    model.peripheral = peripheral;
                    model.jid = [JMXMPPUserManager getJidWithName:peripheral.name];
                    model.communicationType = JMCommunicationTypeBlueToothMainDesign;
                    [self.discoverController.dataSources addObject:model];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kJMFindBluePeripheralsNotification object:model];
            }
            else if (searchType&searchFlagTypeDisconnect){
                if (model) {
                   [self.discoverController.dataSources removeObject:model];
                }
            }
            GCDMainQueue(^{
                [self reloadData];
            });
        }
    }];
    
}

- (void)reScan{

    [self removeAllDatas];
    GCDAfterTime(1, ^{
        [[MCSessionProcess sharedInstance].sessionManager.browser stopBrowsingForPeers];
        if (![JJPeripheralManager sharedInstance].isAdvertising) {
            [JJPeripheralManager reStartAdvertising];
        }
        if (!SIMULATOR) {
            NSLog(@"===发现设备==%@+===",[EasyBlueToothManager shareInstance].centerManager.foundDeviceDict);
            [self scanForPeripherals];
        }
        [[MCSessionProcess sharedInstance].sessionManager.browser startBrowsingForPeers];
    });
    
}

- (void)initDiscoverDevice{
//    if (!SIMULATOR) {
//        //开启蓝牙广播
//        [JJPeripheralManager startAdvertising:nil back:^(CBPeripheralManagerState state) {
//
//        }];
//    }
//    self.sessionProcess = [MCSessionProcess sharedInstance];
}

- (void)foundPeer:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    JMHomeModel *model = [self getModelWithName:sessionModel.peerID.jj_displayName];
    if (model) {
        model.peerID = sessionModel.peerID;
    }else{
        JMHomeModel *homeModel = [JMHomeModel new];
        homeModel.communicationType = JMCommunicationTypeMultipeerConnectivity;
        homeModel.peerID = sessionModel.peerID;
        homeModel.jid = [JMXMPPUserManager getJidWithName:sessionModel.peerID.jj_displayName];
        [self.discoverController.dataSources insertObject:homeModel atIndex:0];
    }
    [self reloadData];
}


- (void)lostPeer:(NSNotification *)not{
    MCSessionModel *sessionModel = not.object;
    
     JMHomeModel *model = [self getModelWithName:sessionModel.peerID.jj_displayName];
    if (model) {
        [self.discoverController.dataSources removeObject:model];
    }
    [self reloadData];
}



- (JMHomeModel *)getModelWithName:(NSString *)name{
   __block JMHomeModel *model = nil;
    [self.discoverController.dataSources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JMHomeModel *homeModel = obj;
        if ([homeModel.name isEqualToString:name]) {
            model = homeModel;
            *stop = YES;

        }
    }];
    return model;
}

- (void)reloadData{
    
    
    if (self.discoverController.dataSources.count) {
        self.discoverController.scanView.hidden = YES;
 self.discoverController.navigationController.navigationBarHidden = NO;
        [self.discoverController.scanView stop];
    }else{
 self.discoverController.navigationController.navigationBarHidden = YES;
        self.discoverController.scanView.hidden = NO;
        [self.discoverController.scanView scan];
    }
    [self.discoverController.tableView reloadData];
}


- (void)removeAllDatas{
    [self.discoverController.dataSources removeAllObjects];
    [self reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
