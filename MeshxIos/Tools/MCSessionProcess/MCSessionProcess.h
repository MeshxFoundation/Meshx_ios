//
//  MCSessionProcess.h
//  MCDemo
//
//  Created by JMZiXun on 2018/5/17.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJLSessionManager.h"
#import "MCSessionModel.h"


extern NSString *const kMCSessionReceiveDataNotification;
extern NSString *const kMCSessionReceiveStreamNotification;
extern NSString *const kMCSessionFinishReceivingResourceNotification;
extern NSString *const kMCSessionChangeStateNotification;
extern NSString *const kMCSessionBrowserFoundPeerNotification;
extern NSString *const kMCSessionBrowserLostPeerNotification;

@interface MCSessionProcess : NSObject

@property(strong, nonatomic) TJLSessionManager *sessionManager;
@property (nonatomic ,strong)NSDictionary *discoveryInfo;

+ (MCSessionProcess *)sharedInstance;
- (void)disconnectMCSession;
+ (void)reconnectionMCSession;
+ (void)reconnectionMCSessionWithUserName:(NSString *)userName;
+ (void)invitePeer:(MCPeerID *)peerID state:(MCSessionState)state;
+ (void)receiveDataNotificationWithData:(NSData *)data peerID:(MCPeerID *)peerID;
@end
