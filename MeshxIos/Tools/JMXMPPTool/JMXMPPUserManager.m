//
//  JMXMPPUserManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/25.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMXMPPUserManager.h"
#import "JMXMPPUserDataProcess.h"
@interface JMXMPPUserManager()

@end

@implementation JMXMPPUserManager
+ (void)addFriend:(NSString *)friendName{

//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",friendName,kJMXMPPLocalhost]];
//    [[JMXMPPTool sharedInstance].rosterTool.xmppRoster addUser:friendJid withNickname:@"好友"];

    
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendName,[JMXMPPTool sharedInstance].xmppStream.myJID.domain]];
    [[JMXMPPTool sharedInstance].rosterTool.xmppRoster addUser:friendJid withNickname:@"好友"];
    
}
+ (void)deleteFriend:(NSString *)friendName{
   
//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",friendName,kJMXMPPLocalhost]];
//    [[JMXMPPTool sharedInstance].rosterTool.xmppRoster removeUser:friendJid];
    
    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendName,[JMXMPPTool sharedInstance].xmppStream.myJID.domain]];
    [[JMXMPPTool sharedInstance].rosterTool.xmppRoster removeUser:friendJid];
}

+ (XMPPJID *)getJidWithName:(NSString *)name{
//    NSString *friendJid = [NSString stringWithFormat:@"%@%@",name,kJMXMPPLocalhost];
//    return [XMPPJID jidWithString:friendJid];
    
    NSString *friendJid = [NSString stringWithFormat:@"%@@%@",name,[JMXMPPTool sharedInstance].xmppStream.myJID.domain];
    return [XMPPJID jidWithString:friendJid];
}

+ (XMPPJID *)getJidWithUserID:(NSString *)userID{
     NSArray *arr = [userID componentsSeparatedByString:kJMXMPPLocalhost];
    NSString *name = arr.firstObject;
    return [self getJidWithName:name];

}

@end
