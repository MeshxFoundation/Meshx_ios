//
//  JMHomeModel.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMHomeModel.h"

@implementation JMHomeModel
- (void)setPeerID:(MCPeerID *)peerID{
    _peerID = peerID;
    _name = peerID.jj_displayName;
    [self setJid:[JMXMPPUserManager getJidWithName:peerID.jj_displayName]];
    _communicationType = JMCommunicationTypeMultipeerConnectivity;
}


- (void)setPeripheral:(EasyPeripheral *)peripheral{
    _peripheral = peripheral;
    [self setJid:[JMXMPPUserManager getJidWithName:peripheral.name]];
    _name = peripheral.name;
    _communicationType = JMCommunicationTypeBlueToothMainDesign;
    _peerID = nil;
    _notfiy = nil;
}

- (void)setCommunicationType:(JMCommunicationType)communicationType{
    _communicationType = communicationType;
    if (_communicationType == JMCommunicationTypeXMPP) {
        
    }
}

- (void)setNotfiy:(JJPeripheralNotfiy *)notfiy{
    _notfiy = notfiy;
    if (notfiy) {
       _communicationType = JMCommunicationTypeBlueToothPeripheral;
    }else{
        if (self.peripheral) {
            _communicationType = JMCommunicationTypeBlueToothMainDesign;
        }
    }
    _peerID = nil;
}

- (void)setJid:(XMPPJID *)jid{
    _jid = jid;
    self.userID = [JMBaseModel getUserIDWithName:jid.user];
    _name = jid.user;
}


/**
 如果需要指定“唯一约束”字段,就实现该函数,这里指定 userID为“唯一约束”.
 */
+(NSArray *)bg_uniqueKeys{
    return @[@"userID"];
}

/**
 设置不需要存储的属性.
 */
+(NSArray *)bg_ignoreKeys{
    return @[@"communicationType",@"peripheral",@"notfiy",@"isChatHistory"];
}

+ (void)deleteWithUserID:(NSString *)userID{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"userID"),bg_sqlValue(userID)];
    [JMHomeModel bg_delete:nil where:where];
}

+ (NSArray *)getAllModel{
    NSString *where = [NSString stringWithFormat:@"order by %@ desc",bg_sqlKey(@"bg_updateTime")];
    return [JMHomeModel bg_find:nil where:where];
}

+ (JMHomeModel *)findModelWithUserID:(NSString *)userID{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"userID"),bg_sqlValue(userID)];
    return [JMHomeModel bg_find:nil where:where].firstObject;
}

@end
