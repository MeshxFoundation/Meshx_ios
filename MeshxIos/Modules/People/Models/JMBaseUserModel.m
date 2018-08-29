//
//  JMBaseUserModel.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/26.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseUserModel.h"

@implementation JMBaseUserModel
- (void)setJid:(XMPPJID *)jid{
    _jid = jid;
    if (jid.user.length>0) {
      _userID = [JMBaseModel getUserIDWithName:jid.user];
    }
}

@end
