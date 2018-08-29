//
//  JMHomeModel.h
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHMessage.h"
#import "BGFMDB.h"
#import "EasyPeripheral.h"
#import "JJPeripheralNotfiy.h"
#import "JMHomeDraftModel.h"

typedef NS_ENUM(NSInteger, JMCommunicationType) {
    
    JMCommunicationTypeNormal = 0,
    //通过xmpp链接通信
    JMCommunicationTypeXMPP,
    //与苹果手机通过MultipeerConnectivity框架通信
    JMCommunicationTypeMultipeerConnectivity ,
    //作为主设，通过蓝牙与安卓手机通信
    JMCommunicationTypeBlueToothMainDesign,
    //作为外设，通过蓝牙与安卓手机通信
    JMCommunicationTypeBlueToothPeripheral
};

@interface JMHomeModel : JMBaseModel
//是否是查询聊天记录，进入到聊天界面
@property (nonatomic ,assign) BOOL isChatHistory;
//草稿提示
@property (nonatomic,strong) JMHomeDraftModel *draftModel;
@property (nonatomic ,strong) XHMessage *message;
//跟iOS设备通过MultipeerConnectivity通信
@property (nonatomic ,strong) MCPeerID *peerID;
@property (nonatomic ,strong) NSString *userID;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) XMPPJID *jid;
//跟安卓设备通过蓝牙通信
@property (nonatomic ,strong) EasyPeripheral *peripheral;
@property (nonatomic ,strong) JJPeripheralNotfiy *notfiy;
@property (nonatomic ,assign) JMCommunicationType communicationType;

+ (NSArray *)getAllModel;

+ (void)deleteWithUserID:(NSString *)userID;

+ (JMHomeModel *)findModelWithUserID:(NSString *)userID;

@end
