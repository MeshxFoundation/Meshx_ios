//
//  JMLanguageManager.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/6.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMLanguageManager.h"

#define kJMHomeLocalizable @"HomeLocalizable"
#define kJMPeopleLocalizable @"PeopleLocalizable"
#define kJMWalletLocalizable @"WalletLocalizable"
#define kJMDiscoverLocalizable @"DiscoverLocalizable"
#define kJMMineLocalizable @"MineLocalizable"
#define kJMBaseLocalizable @"BaseLocalizable"

@implementation JMLanguageManager

//搜索
+ (NSString *)jm_languageSearch{
    return kLocalizedTableString(@"Search",kJMBaseLocalizable);
}
//取消
+ (NSString *)jm_languageCancel{
    return kLocalizedTableString(@"Cancel",kJMBaseLocalizable);
}

+ (NSString *)jm_languageFail{
  //失败
    return kLocalizedTableString(@"Fail",kJMBaseLocalizable);
}
+ (NSString *)jm_languageDelete{
   //删除
    return kLocalizedTableString(@"Delete",kJMBaseLocalizable);
}

+ (NSString *)jm_languageSuccess{
    //成功
    return kLocalizedTableString(@"Success",kJMBaseLocalizable);
}
+ (NSString *)jm_languageOK{
    //确定
    return kLocalizedTableString(@"OK",kJMBaseLocalizable);
}

#pragma mark ---------tabbar-------------

+ (NSString *)jm_languageHome{
   //聊天
    return kLocalizedTableString(@"Home",kJMHomeLocalizable);
}
+ (NSString *)jm_languagePeople{
   //人脉
    return kLocalizedTableString(@"People",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageWallet{
  //钱包
    return kLocalizedTableString(@"Wallet",kJMWalletLocalizable);
}
+ (NSString *)jm_languageDiscover{
   //发现
    return kLocalizedTableString(@"Discover",kJMDiscoverLocalizable);
}//
+ (NSString *)jm_languageMe{
   //我的
    return kLocalizedTableString(@"Me",kJMMineLocalizable);
}
#pragma mark ----------date------------
+ (NSString *)jm_languageYesterday{
   //昨天
    return kLocalizedTableString(@"Yesterday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageMonday{
   //星期一
    return kLocalizedTableString(@"Monday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageTuesday{
    //星期二
    return kLocalizedTableString(@"Tuesday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageWednesday{
   //星期三
    return kLocalizedTableString(@"Wednesday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageThursday{
   //星期四
    return kLocalizedTableString(@"Thursday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageFriday{
    //星期五
    return kLocalizedTableString(@"Friday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageSaturday{
   //星期六
    return kLocalizedTableString(@"Saturday",kJMBaseLocalizable);
}
+ (NSString *)jm_languageSunday{
   //星期日
    return kLocalizedTableString(@"Sunday",kJMBaseLocalizable);
}

#pragma mark ----------login----------
+ (NSString *)jm_languageUserName{
   //用户名
    return kLocalizedTableString(@"Username",@"LoginLocalizable");
}
+ (NSString *)jm_languagePassword{
  //密码
    return kLocalizedTableString(@"Password",@"LoginLocalizable");
}
+ (NSString *)jm_languageUserLogin{
    //登录
    return kLocalizedTableString(@"Log In",@"LoginLocalizable");
}
+ (NSString *)jm_languageEnterPassword{
   //请输入密码
    return kLocalizedTableString(@"Enter Password",@"LoginLocalizable");
}
+ (NSString *)jm_languageEnterUserName{
   //请输入用户名
    return kLocalizedTableString(@"Enter Username",@"LoginLocalizable");
}
+ (NSString *)jm_languageForgetPassword{
  //忘记密码
    return kLocalizedTableString(@"Forget Password",@"LoginLocalizable");
}
+ (NSString *)jm_languageSignUp{
   //注册
    return kLocalizedTableString(@"Sign Up",@"LoginLocalizable");
}
+ (NSString *)jm_languageConfirmPassword{
   //确认密码
    return kLocalizedTableString(@"Confirm Password",@"LoginLocalizable");
}
+ (NSString *)jm_languageInconsistentPassword{
   //密码与确认密码不一致
    //确认密码
    return kLocalizedTableString(@"Inconsistent Password",@"LoginLocalizable");
}

+ (NSString *)jm_languageRegistrationFailed{
    //注册失败
    return kLocalizedTableString(@"Registration failed",@"LoginLocalizable");
}
+ (NSString *)jm_languageRegistrationTimeout{
    //注册超时
    return kLocalizedTableString(@"注册超时",@"LoginLocalizable");
}
+ (NSString *)jm_languageRegistrationFailedUserAlreadyExists{
    //注册失败，该用户已存在
    return kLocalizedTableString(@"RegistrationFailedUserAlreadyExists",@"LoginLocalizable");
}
+ (NSString *)jm_languageNotConnectedServer{
    //未连接上服务器
    return kLocalizedTableString(@"Not connected to the server",@"LoginLocalizable");
}
+ (NSString *)jm_languageLoginFailed{
    //登录失败
    return kLocalizedTableString(@"Login failed",@"LoginLocalizable");
}

#pragma mark home

+ (NSString *)jm_languageDetails{
    //聊天详情
    return kLocalizedTableString(@"Details",kJMHomeLocalizable);
}
+ (NSString *)jm_languageNoChatInformation{
    //暂无聊天信息
    return kLocalizedTableString(@"No chat information~",kJMHomeLocalizable);
}

+ (NSString *)jm_languageSearchHistory{
   //查找本地聊天内容
    return kLocalizedTableString(@"Search History",kJMHomeLocalizable);
}
+ (NSString *)jm_languageClearChatHistory{
    //清空聊天记录
    return kLocalizedTableString(@"Clear Chat History",kJMHomeLocalizable);
}
+ (NSString *)jm_languageChatHistory{
    //聊天记录
    return kLocalizedTableString(@"Chat History",kJMHomeLocalizable);
}

+ (NSString *)jm_languageRelatedMessage{
    //条相关聊天记录
    return kLocalizedTableString(@"related message(s)",kJMHomeLocalizable);
}

+ (NSString *)jm_languageClear{
    //清除
    return kLocalizedTableString(@"Clear",kJMHomeLocalizable);
}

+ (NSString *)jm_languageScan{
    //扫一扫
    return kLocalizedTableString(@"Scan",kJMHomeLocalizable);
}

+ (NSString *)jm_languageAlbum{
    //相册
    return kLocalizedTableString(@"Album",kJMHomeLocalizable);
}

+ (NSString *)jm_languageFlash{
    //闪光灯
    return kLocalizedTableString(@"Flash",kJMHomeLocalizable);
}
+ (NSString *)jm_languageAlignQRCodeScan{
    //将二维码/条形码放入框内，即可自动扫描
    return kLocalizedTableString(@"Align QR Code Scan",kJMHomeLocalizable);
}

+ (NSString *)jm_languageQRCodeInfo{
    //扫描结果
    return kLocalizedTableString(@"QR Code Info",kJMHomeLocalizable);
}

+ (NSString *)jm_languageCopy{
    //复制
    return kLocalizedTableString(@"Copy",kJMHomeLocalizable);
}
+ (NSString *)jm_languageSendAMessage{
    //发送新消息
    return kLocalizedTableString(@"SendAMessage",kJMHomeLocalizable);
}
+ (NSString *)jm_languageNoResult{
    //无结果
    return kLocalizedTableString(@"No Result",kJMHomeLocalizable);
}

#pragma mark ----------people----------
+ (NSString *)jm_languageNewFreinds{
  //新的朋友
    return kLocalizedTableString(@"New Friends",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageNoPeoplesGoAddPeoples{
    //暂无好友，快去添加好友吧～
    return kLocalizedTableString(@"No peoples, go add peoples~",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageAddPeople{
    //添加好友
    return kLocalizedTableString(@"Add People",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageFreind{
    //好友
    return  kLocalizedTableString(@"Freind",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageMessages{
    //发送信息
    return kLocalizedTableString(@"Messages",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageAdded{
    //已同意
    return kLocalizedTableString(@"Added",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageAdd{
    //添加
    return kLocalizedTableString(@"Add",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageView{
    //查看
    return kLocalizedTableString(@"View",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageRequestSent{
    //等待验证
    return kLocalizedTableString(@"Request sent",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageExpired{
    //过期
    return kLocalizedTableString(@"Expired",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageApprove{
    //通过验证
    return kLocalizedTableString(@"Approve",kJMPeopleLocalizable);
}
+ (NSString *)jm_languageProfile{
    //详情资料
    return kLocalizedTableString(@"Profile",kJMPeopleLocalizable);
}
#pragma mark ----------wallet----------

#pragma mark ----------discover----------
+ (NSString *)jm_languageSearching{
   //正在搜索中...
    return kLocalizedTableString(@"Searching",kJMDiscoverLocalizable);
}
#pragma mark ----------mine----------
+ (NSString *)jm_languageSettings{
    //设置
    return kLocalizedTableString(@"Settings",kJMMineLocalizable);
}
+ (NSString *)jm_languageAboutUs{
    //关于我们
    return kLocalizedTableString(@"About us",kJMMineLocalizable);
}

+ (NSString *)jm_languageCurrencyUnit{
    //货币单位
    return kLocalizedTableString(@"Currency Unit",kJMMineLocalizable);
}

+ (NSString *)jm_languageLogOut{
    //退出登录
    return kLocalizedTableString(@"Log Out",kJMMineLocalizable);
}
+ (NSString *)jm_languageLanguage{
    //系统语言
    return kLocalizedTableString(@"Language",kJMMineLocalizable);
}
+ (NSString *)jm_languageMyQRCode{
    //我的二维码
    return kLocalizedTableString(@"My QR Code",kJMMineLocalizable);
}
+ (NSString *)jm_languageSaveQRCodeToAlbum{
    //保存二维码到相册
    return kLocalizedTableString(@"Save QR Code To Album",kJMMineLocalizable);
}
+ (NSString *)jm_languageMyProfile{
    //个人资料
    return kLocalizedTableString(@"My Profile",kJMMineLocalizable);
}

+ (NSString *)jm_languageName{
    //名字
    return kLocalizedTableString(@"Name",kJMMineLocalizable);
}

+ (NSString *)jm_languageGender{
    //性别
    return kLocalizedTableString(@"Gender",kJMMineLocalizable);
}

+ (NSString *)jm_languageMale{
    //男
    return kLocalizedTableString(@"Gender Male",kJMMineLocalizable);
}

+ (NSString *)jm_languageFemale{
    //女
    return kLocalizedTableString(@"Gender Female",kJMMineLocalizable);
}

+ (NSString *)jm_languagePermissionSettingPrompt{
    // "没有权限，是否前往设置";
    return kLocalizedTableString(@"Permission Setting Prompt",kJMMineLocalizable);
}

+ (NSString *)jm_languageVersion{
    // "版本";
    return kLocalizedTableString(@"Version",kJMMineLocalizable);
}

+ (NSString *)jm_languageTakePhoto{
    // "拍照";
    return kLocalizedTableString(@"Take Photo",kJMMineLocalizable);
}

+ (NSString *)jm_languageChooseFromAlbum{
    // "从相册选择图片";
    return kLocalizedTableString(@"Choose from Album",kJMMineLocalizable);
}

+ (NSString *)jm_languageDone{
    // "完成";
    return kLocalizedTableString(@"Done",kJMMineLocalizable);
}

+ (NSString *)jm_languageRetake{
    // "重拍";
    return kLocalizedTableString(@"Retake",kJMMineLocalizable);
}

+ (NSString *)jm_languageUsePhoto{
    // "使用照片";
    return kLocalizedTableString(@"Use photo",kJMMineLocalizable);
}
+ (NSString *)jm_languagePhotos{
    // "照片";
    return kLocalizedTableString(@"Photos",kJMMineLocalizable);
}
+ (NSString *)jm_languageAutomatic{
    // "自动";
    return kLocalizedTableString(@"Automatic",kJMMineLocalizable);
}
+ (NSString *)jm_languageOpen{
    // "打开";
    return kLocalizedTableString(@"Open",kJMMineLocalizable);
}
+ (NSString *)jm_languageClose{
    // "关闭";
    return kLocalizedTableString(@"Close",kJMMineLocalizable);
}

+ (NSString *)jm_languageAuboutUsDescription{
    // 关于我们的描述;
    return kLocalizedTableString(@"Aubout us description",kJMMineLocalizable);
}
+ (NSString *)jm_languageDetectNewVersion{
    // 检测新版;
    return kLocalizedTableString(@"Detect new version",kJMMineLocalizable);
}

+ (NSString *)jm_languageNoNetworkCommunication{
    // 无网通讯;
    return kLocalizedTableString(@"No network communication",kJMMineLocalizable);
}
+ (NSString *)jm_languagePrompt{
    // 提示;
    return kLocalizedTableString(@"prompt",kJMMineLocalizable);
}
+ (NSString *)jm_languageTurnedOffNoNetworkCommunication{
    // 您已经关闭无网通讯，是否前往设置;
    return kLocalizedTableString(@"You have turned off no network communication, go to the settings",kJMMineLocalizable);
}
+ (NSString *)jm_languageUseNoNetworkCommunicationPrompt{
    // 使用无网通讯，需要打开wifi或蓝牙开关，如果要搜索附近使用安卓手机的人，请务必打开蓝牙开关;
    return kLocalizedTableString(@"Use no network communication, you need to turn on the wifi or Bluetooth switch. If you want to search for people who use Android phones nearby, please be sure to turn on the Bluetooth switch.",kJMMineLocalizable);
}



@end
