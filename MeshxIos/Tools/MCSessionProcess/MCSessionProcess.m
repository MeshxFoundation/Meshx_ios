//
//  MCSessionProcess.m
//  MCDemo
//
//  Created by JMZiXun on 2018/5/17.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "MCSessionProcess.h"


NSString *const kMCSessionReceiveDataNotification = @"kMCSessionReceiveDataNotification";
NSString *const kMCSessionReceiveStreamNotification = @"kMCSessionReceiveStreamNotification";
NSString *const kMCSessionFinishReceivingResourceNotification = @"kMCSessionFinishReceivingResourceNotification";
NSString *const kMCSessionChangeStateNotification = @"kMCSessionChangeStateNotification";
NSString *const kMCSessionBrowserFoundPeerNotification = @"kMCSessionBrowserFoundPeerNotification";
NSString *const kMCSessionBrowserLostPeerNotification = @"kMCSessionBrowserLostPeerNotification";

static NSString *const kMCSessionMyName = @"MCSessionMyName";
static NSString *const kMCSessionUserName = @"MCSessionUserName";

@implementation MCSessionProcess


+ (MCSessionProcess *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance sessionManager];
    });
    return sharedInstance;
}
- (void)createMCSession{
    
   
}

+ (void)receiveDataNotificationWithData:(NSData *)data peerID:(MCPeerID *)peerID{
    JJTransportProcess *process = [JJTransportDecoder decoderWithData:data];
     [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionReceiveDataNotification object:[[MCSessionModel alloc] initWithPeer:peerID process:process]];
     [self sendChatMsgBack:process peerID:peerID];
}

+ (void)sendChatMsgBack:(JJTransportProcess *)process peerID:(MCPeerID *)peerID{
    if ([process.type isEqualToString:kJMChatMsgTextAPI]) {
        process.type = kJMChatMsgBackAPI;
        NSDictionary *dic = process.msg;
        process.msg = @{@"eventID":dic[@"eventID"],@"userID":dic[@"userID"]};
        NSData *data = [JJTransportEncoder didEncodeWithProcess:process];
        [[MCSessionProcess sharedInstance].sessionManager sendData:data toPeers:@[peerID]];
    }
}

- (TJLSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [[TJLSessionManager alloc]initWithDisplayName:[MCPeerID jj_UUIDDisplayName] securityIdentity:nil encryptionPreferences:MCEncryptionNone serviceType:@"JMSMService"];
        [_sessionManager advertiseForBrowserViewController];
        [_sessionManager browseForProgrammaticDiscovery];
        if (!_discoveryInfo) {
            _discoveryInfo = @{kMCSessionMyName:[JMMyInfo name]};
        }
        [_sessionManager advertiseForBrowserViewControllerWithDiscoveryInfo:_discoveryInfo];
        __weak typeof (TJLSessionManager *) weakSessionManager = _sessionManager;
        [weakSessionManager didReceiveInvitationFromPeer:^void(MCPeerID *peer, NSData *context) {
            
            if (![self.sessionManager.peerID.jj_UUID isEqualToString:peer.jj_UUID]) {
                [weakSessionManager connectToPeer:YES];
                
            }
//            [MCSessionProcess invitePeer:peer state:MCSessionStateNotConnected];
        }];
        
        [weakSessionManager peerConnectionStatusOnMainQueue:YES block:^(MCPeerID *peer, MCSessionState state) {
            if (![weakSessionManager.peerID.jj_UUID isEqualToString:peer.jj_UUID]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionChangeStateNotification object:[[MCSessionModel alloc] initWithPeer:peer info:nil state:state data:nil]];
            }
            
        }];
        
        [weakSessionManager receiveDataOnMainQueue:YES block:^(NSData *data, MCPeerID *peer) {
            if (![weakSessionManager.peerID.jj_UUID isEqualToString:peer.jj_UUID]) {
                [MCSessionProcess receiveDataNotificationWithData:data peerID:peer];
            }
            
        }];
        [weakSessionManager didFindPeerWithInfo:^(MCPeerID *peer, NSDictionary *info) {
            
            
            if (![weakSessionManager.peerID.jj_UUID isEqualToString:peer.jj_UUID]) {
                NSLog(@"===发现节点==%@+===%@==",peer.jj_displayName,peer);
                NSString *userName = info[kMCSessionUserName];
                if (userName.length>0) {
                    [MCSessionProcess invitePeer:peer state:MCSessionStateNotConnected];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionBrowserFoundPeerNotification object:[[MCSessionModel alloc] initWithPeer:peer info:info state:0 data:nil]];
            }
            
        }];
        [weakSessionManager lostPeerWithBrowser:^(MCNearbyServiceBrowser *browser, MCPeerID *peerID) {
            if (![weakSessionManager.peerID.jj_UUID isEqualToString:peerID.jj_UUID]) {
                MCSessionModel *model = [MCSessionModel new];
                model.peerID = peerID;
                [[NSNotificationCenter defaultCenter] postNotificationName:kMCSessionBrowserLostPeerNotification object:model];
            }
        }];
    }
    return _sessionManager;
}

- (void)disconnectMCSession{
    [_sessionManager disconnectSession];
    [_sessionManager stopBrowsing];
    [_sessionManager stopAdvertising];
    _discoveryInfo = nil;
    _sessionManager = nil;
}


+ (void)reconnectionMCSessionWithUserName:(NSString *)userName{
    [[self sharedInstance]  disconnectMCSession];
    [self sharedInstance].discoveryInfo = @{kMCSessionMyName:[JMMyInfo name],kMCSessionUserName:userName};
    [[self sharedInstance] sessionManager];
}

+ (void)reconnectionMCSession{
    [[self sharedInstance]  disconnectMCSession];
    [[self sharedInstance] sessionManager];
}

+ (void)invitePeer:(MCPeerID *)peerID state:(MCSessionState)state{
    MCSessionProcess *sessionProcess = [self sharedInstance];
    if (![sessionProcess.sessionManager.connectedPeers containsObject:peerID]) {
        [sessionProcess.sessionManager invitePeerToConnect:peerID connected:^{
            
        }];
    }
}

@end
