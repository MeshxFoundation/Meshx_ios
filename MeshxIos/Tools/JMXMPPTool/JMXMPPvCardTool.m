//
//  JMXMPPvCardTool.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPvCardTool.h"
@interface JMXMPPvCardTool()
@property (nonatomic ,copy)updateMyCard resultBack;
@end
@implementation JMXMPPvCardTool

- (XMPPvCardTempModule*)vCardModule{
    if (!_vCardModule) {
        _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
        _vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
        [_vCardModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
        //激活
        [_vCardModule activate:[JMXMPPTool sharedInstance].xmppStream];
    }
    return _vCardModule;
}

- (XMPPvCardAvatarModule *)vCardAvatar{
    if (!_vCardAvatar) {
        //  添加头像模块
        _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCardModule];
        [_vCardAvatar addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
        [_vCardAvatar activate:[JMXMPPTool sharedInstance].xmppStream];
    }
    return _vCardAvatar;
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"%s",__FUNCTION__);
    GCDMainQueue(^{
        [self setupResultIsSuccess:YES];
    });
    
    //保存用户信息
    [JMMyInfo saveToFile];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error{
    GCDMainQueue(^{
        [self setupResultIsSuccess:NO];
    });
    NSLog(@"%s",__FUNCTION__);
}

- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule didReceivePhoto:(UIImage *)photo forJID:(XMPPJID *)jid{
    NSLog(@"%s",__FUNCTION__);
    //保存用户的头像
    [JMHeaderImageManager saveImageWithData:UIImageJPEGRepresentation(photo, 1) userID:[JMBaseModel getUserIDWithName:jid.user]];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid{
    if ([jid.user isEqualToString:[JMMyInfo name]]) {
        [JMMyInfo saveToFile];
    }
    NSLog(@"%s",__FUNCTION__);
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToFetchvCardForJID:(XMPPJID *)jid error:(DDXMLElement *)error{
    NSLog(@"%s",__FUNCTION__);
}

- (void)updateMyCardWithResult:(updateMyCard)result{
    
    XMPPStream *stream = [JMXMPPTool sharedInstance].xmppStream;
    
    if ([stream isConnected]) {
        [self.vCardModule updateMyvCardTemp:self.vCardModule.myvCardTemp];
        if (result) {
            self.resultBack = [result copy];
        }
    }else{
        if (result) {
            result(NO,self.vCardModule.myvCardTemp);
        }
    }
}


- (void)setupResultIsSuccess:(BOOL)isSuccess{
    if (self.resultBack) {
        self.resultBack(isSuccess,self.vCardModule.myvCardTemp);
        self.resultBack = nil;
    }
}

- (void)clearData{
    [_vCardModule removeDelegate:self];
    [_vCardAvatar removeDelegate:self];
    [_vCardModule deactivate];
    [_vCardAvatar deactivate];
    _vCardAvatar = nil;
    _vCardModule = nil;
}

@end
