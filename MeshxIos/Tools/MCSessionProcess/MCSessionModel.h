//
//  MCSessionModel.h
//  MCDemo
//
//  Created by JMZiXun on 2018/5/17.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTransportProcess.h"
#import "JMHomeModel.h"



typedef NS_ENUM(NSInteger, JMReceiveDataType) {
    
    JMReceiveDataTypeNormal = 0,
    //接收到xmpp信息
    JMReceiveDataTypeXMPP,
    //接收到MultipeerConnectivity信息
    JMReceiveDataTypeMultipeerConnectivity ,
    //自身作为主设，通过蓝牙与安卓手机通信，接收到信息
    JMReceiveDataTypeBlueToothMainDesign,
    //自身作为外设，通过蓝牙与安卓手机通信，接收到信息
    JMReceiveDataTypeBlueToothPeripheral
};


@interface MCSessionModel : JMHomeModel

@property (nonatomic ,assign) JMReceiveDataType receiveDataType;
@property (nonatomic ,strong) NSDictionary *info;
@property (nonatomic ,assign) MCSessionState state;
@property (nonatomic ,strong) NSData *data;
@property (nonatomic ,strong) JJTransportProcess *process;
- (instancetype)initWithPeer:(MCPeerID *)peer info:(NSDictionary *)info state:(MCSessionState)state data:(NSData *)data;

- (instancetype)initWithPeer:(MCPeerID *)peer process:(JJTransportProcess *)process;

- (instancetype)initWithNotfiy:(JJPeripheralNotfiy *)notfiy process:(JJTransportProcess *)process;
- (instancetype)initWithPeripheral:(EasyPeripheral *)peripheral process:(JJTransportProcess *)process;

@end
