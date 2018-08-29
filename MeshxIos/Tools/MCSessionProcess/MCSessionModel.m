//
//  MCSessionModel.m
//  MCDemo
//
//  Created by JMZiXun on 2018/5/17.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "MCSessionModel.h"

@implementation MCSessionModel
- (instancetype)initWithPeer:(MCPeerID *)peer info:(NSDictionary *)info state:(MCSessionState)state data:(NSData *)data{
    if (self = [super init]) {
        _info = info;
        _state = state;
        _data = data;
        self.peerID = peer;
    }
    return self;
}

- (instancetype)initWithPeer:(MCPeerID *)peer process:(JJTransportProcess *)process;{
    if (self = [super init]) {
        self.notfiy = nil;
        self.peripheral = nil;
        self.peerID = peer;
        _process = process;
        self.receiveDataType = JMReceiveDataTypeMultipeerConnectivity;
        
    }
    return self;
}

- (instancetype)initWithNotfiy:(JJPeripheralNotfiy *)notfiy process:(JJTransportProcess *)process{
    if (self = [super init]) {
        self.peerID = nil;
        _process = process;
        self.notfiy = notfiy;
    }
    return self;
}
- (instancetype)initWithPeripheral:(EasyPeripheral *)peripheral process:(JJTransportProcess *)process{
    if (self = [super init]) {
        self.notfiy = nil;
        self.peerID = nil;
        _process = process;
        self.peripheral = peripheral;
    }
    return self;
}

@end
