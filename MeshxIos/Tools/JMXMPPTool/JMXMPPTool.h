//
//  JMXMPPTool.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "JMXMPPRosterTool.h"
#import "JMXMPPvCardTool.h"

extern NSString *const kJMXMPPHost;
extern NSString *const kJMXMPPDoMain;
extern NSString *const kJMXMPPReSource;
extern NSString *const kJMXMPPRosterDidChangeNotification;
extern NSString *const kJMXMPPRosterDidEndPopulatingNotification;
extern NSString *const kJMXMPPGetGroupNotification;

typedef void(^sendElementResultBack)(BOOL isSuccess,XMPPElement *element,XMPPStream *sender);

@interface JMXMPPTool : NSObject<XMPPStreamDelegate,UIAlertViewDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPIncomingFileTransferDelegate,XMPPReconnectDelegate,XMPPAutoPingDelegate>
@property (nonatomic, strong) XMPPStream *xmppStream;
// 模块
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
//花名册
@property (nonatomic ,strong) JMXMPPRosterTool *rosterTool;
//名片
@property (nonatomic ,strong) JMXMPPvCardTool *vCardTool;
//是否登录成功
@property (nonatomic ,assign) BOOL isLoginSuccess;

@property (nonatomic ,assign) BOOL isSocketState;

//登入密码
@property (nonatomic,strong)NSString *loginpassword;
@property (nonatomic,strong)NSString *loginName;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;

+ (instancetype)sharedInstance;
/**
 *  登入
 *
 *  @param userName 账户
 *  @param password 密码
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password result:(sendElementResultBack)result;
/**
 *  注册
 *
 *  @param userName 账户
 *  @param password 密码
 */
- (void)registWithUserName:(NSString *)userName password:(NSString *)password result:(sendElementResultBack)result;

/**
 设置是否在线

 @param type 状态标识
 */
- (void)setupPresenceWithType:(NSString *)type;
/**
 *  退出登录
 */
- (void)logout;

+ (void)sendElement:(NSXMLElement *)element result:(sendElementResultBack)result;

@end
