//
//  JMChatSendMsgProcess.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/22.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatSendMsgProcess.h"
#import "JMFileSaveManager.h"
#import "JMDateManager.h"
#import "JMBLSendMsgProcess.h"
#import "JMXMPPSendMsgProcess.h"
#import "JMChatController.h"
@interface JMChatSendMsgProcess ()
@property (nonatomic ,weak) JMChatController *chatController;
@end
@implementation JMChatSendMsgProcess

- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        _chatController = (JMChatController *)viewController;
    }
    return self;
}

- (void)sendTextMessage:(XHMessage *)message model:(JMHomeModel *)model{
    NSString *timeStamp = [JMEventIDManager getTimeStampWithEventID:message.eventID];
    NSDictionary *dic = @{@"content":message.text,@"eventID":message.eventID,@"time":[JMDateManager stringFromDate:message.timestamp],@"timeStamp":@([timeStamp integerValue]),@"userID":[JMMyInfo userID],@"userName":[JMMyInfo name],@"type":kJMChatMsgTextAPI};
    JJTransportProcess *process = [[JJTransportProcess alloc] init];
    process.msg = dic;
    process.type = kJMChatMsgTextAPI;
    JMMessageResendModel *sendModel = [[JMMessageResendModel alloc] initWithMessage:message process:process homeModel:model];
    [self.sendMessageCache setObject:sendModel forKey:message.eventID];
    [self sendMsgWithProcess:process model:model type:JMSendMsgTypeText];
}

- (void)sendPhotoMessage:(XHMessage *)message model:(JMHomeModel *)model{
    JJTransportProcess *process = [[JJTransportProcess alloc] init];
    process.fileData =  UIImageJPEGRepresentation(message.photo, 1);
    process.type = kJMChatMsgFileAPI;
    process.msg = @{@"fileType":kJMChatMsgFilePhotoType,@"eventID":message.eventID,@"content":@"[图片]",@"time":[JMDateManager stringFromDate:message.timestamp]};
    [self sendMsgWithProcess:process model:model type:JMSendMsgTypePhoto];
}

- (void)sendVoiceMessage:(XHMessage *)message model:(JMHomeModel *)model{
    NSData *voiceData = [NSData dataWithContentsOfFile:message.voicePath];
    [JMFileSaveManager saveVoice:voiceData voiceName:message.eventID];
    JJTransportProcess *process = [[JJTransportProcess alloc] init];
    process.fileData = voiceData;
    process.type = kJMChatMsgFileAPI;
    process.msg = @{@"fileType":kJMChatMsgFileVoiceType,@"eventID":message.eventID,@"content":@"[语音]",@"voiceDuration":message.voiceDuration,@"time":[JMDateManager stringFromDate:message.timestamp]};
    [self sendMsgWithProcess:process model:model type:JMSendMsgTypeVoice];
}

- (void)sendMsgWithProcess:(JJTransportProcess *)process model:(JMHomeModel *)model type:(JMSendMsgType)type{
    
    
    MCSessionModel *sessionModel = nil;
    
    switch (model.communicationType) {
        case JMCommunicationTypeNormal:
        {
            sessionModel = [MCSessionModel new];
            sessionModel.process = process;
            sessionModel.jid = model.jid;
            sessionModel.communicationType = JMCommunicationTypeNormal;
            
        }
            break;
        case JMCommunicationTypeXMPP:
        {
            [JMXMPPSendMsgProcess sendTextWithProcess:process model:model];
            sessionModel = [MCSessionModel new];
            sessionModel.receiveDataType = JMCommunicationTypeXMPP;
            sessionModel.process = process;
            sessionModel.jid = model.jid;
        }
            break;
        case JMCommunicationTypeMultipeerConnectivity:
        {
            //与苹果手机通信，通过MultipeerConnectivity框架通信
            NSData *data = [JJTransportEncoder didEncodeWithProcess:process];
            NSError *error = [[MCSessionProcess sharedInstance].sessionManager sendData:data toPeers:@[model.peerID]];
            NSString *localizedDescription = error.localizedDescription;
            NSRange range = [localizedDescription rangeOfString:@"not connected"];
            //说明没有连接成功
            if (range.length>0) {
                
                NSLog(@"====断开MultipeerConnectivity连接，重新连接====%@",error.localizedDescription);
                //断开重新连接
                [MCSessionProcess reconnectionMCSessionWithUserName:self.chatController.homeModel.name];
                //三秒后在重新发送一次
                GCDAfterTime(3, ^{
                    [[MCSessionProcess sharedInstance].sessionManager sendData:data toPeers:@[model.peerID]];
                });
            } NSLog(@"==sendMsgError==%@====",error.localizedDescription);
            sessionModel = [[MCSessionModel alloc] initWithPeer:model.peerID process:[JJTransportDecoder decoderWithData:data]];
            sessionModel.receiveDataType = JMReceiveDataTypeMultipeerConnectivity;
        }
            break;
        case JMCommunicationTypeBlueToothMainDesign:
        {
            //        与安卓手机通信,蓝牙作为主设给外设发送信息
            NSData *data = [JJTransportEncoder didEncodeWithProcess:process];
            [JMBLSendMsgProcess sendMsgWithData:data peripheral:model.peripheral.peripheral characteristic:model.peripheral.writeCharacteristic];
            sessionModel = [[MCSessionModel alloc] initWithPeripheral:model.peripheral process:process];
            sessionModel.jid = model.jid;
            sessionModel.receiveDataType = JMReceiveDataTypeBlueToothMainDesign;
        }
            break;
        case JMCommunicationTypeBlueToothPeripheral:
        {
            //与安卓手机通信，蓝牙作为外设发送更新自身蓝牙数据
            NSData *data = [JJTransportEncoder didEncodeWithProcess:process];
            [JMBLSendMsgProcess sendMsgWithData:data peripheralNotfiy:model.notfiy];
            sessionModel = [[MCSessionModel alloc] initWithNotfiy:model.notfiy process:process];
             sessionModel.receiveDataType = JMReceiveDataTypeBlueToothPeripheral;
            sessionModel.jid = model.jid;
        }
            break;
            
        default:
            break;
    }

    if (!sessionModel) {
        NSLog(@"找不到发送类型");
        return;
    }
    
    switch (type) {
        case JMSendMsgTypeText:
        {
          
        }
            break;
        case JMSendMsgTypePhoto:
        {
            GCDGlobalQueue(^{
                [JMFileSaveManager saveImage:process.fileData imageName:process.msg[@"eventID"]];
            });
        }
            break;
        case JMSendMsgTypeVoice:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJMChatSendMsgNotification object:sessionModel];
}

/**
 消息重发

 @param model 消息重发模型
 */
- (void)messageResend:(JMMessageResendModel *)model{
    switch (model.homeModel.communicationType) {
        case JMCommunicationTypeXMPP:
        {
            [JMXMPPSendMsgProcess sendTextWithProcess:model.process model:model.homeModel];
        }
            break;
        case JMCommunicationTypeMultipeerConnectivity:
        {
            //与苹果手机通信，通过MultipeerConnectivity框架通信
            NSData *data = [JJTransportEncoder didEncodeWithProcess:model.process];
            NSError *error = [[MCSessionProcess sharedInstance].sessionManager sendData:data toPeers:@[model.homeModel.peerID]];
            NSString *localizedDescription = error.localizedDescription;
            NSRange range = [localizedDescription rangeOfString:@"not connected"];
            //说明没有连接成功
            if (range.length>0) {
                //断开重新连接
                [MCSessionProcess reconnectionMCSessionWithUserName:model.homeModel.name];
            }
        }
            break;
        case JMCommunicationTypeBlueToothMainDesign:
        {
            //        与安卓手机通信,蓝牙作为主设给外设发送信息
            NSData *data = [JJTransportEncoder didEncodeWithProcess:model.process];
            [JMBLSendMsgProcess sendMsgWithData:data peripheral:model.homeModel.peripheral.peripheral characteristic:model.homeModel.peripheral.writeCharacteristic];
        }
            break;
        case JMCommunicationTypeBlueToothPeripheral:
        {
            //与安卓手机通信，蓝牙作为外设发送更新自身蓝牙数据
            NSData *data = [JJTransportEncoder didEncodeWithProcess:model.process];
            [JMBLSendMsgProcess sendMsgWithData:data peripheralNotfiy:model.homeModel.notfiy];
        }
            break;
            
        default:
            break;
    }
}

- (NSCache *)sendMessageCache{
    if (!_sendMessageCache) {
        _sendMessageCache = [[NSCache alloc] init];
    }
    return _sendMessageCache;
}

@end
