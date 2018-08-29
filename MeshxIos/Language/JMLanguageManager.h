//
//  JMLanguageManager.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/6.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXLanguageManager.h"
#define kJMLanguageLocalizable @"LanguageLocalizable"
@interface JMLanguageManager : NSObject

+ (NSString *)jm_languageSearch;//搜索
+ (NSString *)jm_languageCancel;//取消
+ (NSString *)jm_languageFail;//失败
+ (NSString *)jm_languageSuccess;//成功
+ (NSString *)jm_languageOK; //确定
+ (NSString *)jm_languageDelete;//删除
#pragma mark ---------tabbar-------------
+ (NSString *)jm_languageHome;//聊天
+ (NSString *)jm_languagePeople;//人脉
+ (NSString *)jm_languageWallet;//钱包
+ (NSString *)jm_languageDiscover;////发现
+ (NSString *)jm_languageMe;//我的
#pragma mark ----------date------------
+ (NSString *)jm_languageYesterday;//昨天
+ (NSString *)jm_languageMonday;//星期一
+ (NSString *)jm_languageTuesday;//星期二
+ (NSString *)jm_languageWednesday;//星期三
+ (NSString *)jm_languageThursday;//星期四
+ (NSString *)jm_languageFriday;//星期五
+ (NSString *)jm_languageSaturday;//星期六
+ (NSString *)jm_languageSunday;//星期日

#pragma mark ----------login----------
+ (NSString *)jm_languageUserName;//用户名
+ (NSString *)jm_languagePassword;//密码
+ (NSString *)jm_languageUserLogin;//登录
+ (NSString *)jm_languageEnterPassword;//请输入密码
+ (NSString *)jm_languageEnterUserName;//请输入用户名
+ (NSString *)jm_languageForgetPassword;//忘记密码
+ (NSString *)jm_languageSignUp;//注册
+ (NSString *)jm_languageConfirmPassword;//确认密码
+ (NSString *)jm_languageInconsistentPassword;//密码与确认密码不一致
+ (NSString *)jm_languageRegistrationFailed;//注册失败
+ (NSString *)jm_languageRegistrationTimeout;//注册超时
+ (NSString *)jm_languageRegistrationFailedUserAlreadyExists;//注册失败，该用户已存在
+ (NSString *)jm_languageNotConnectedServer;//未连接上服务器
+ (NSString *)jm_languageLoginFailed;

#pragma mark home
+ (NSString *)jm_languageDetails;//聊天详情
+ (NSString *)jm_languageNoChatInformation;//暂无聊天信息
+ (NSString *)jm_languageSearchHistory;//查找本地聊天内容
+ (NSString *)jm_languageClearChatHistory;//清空聊天记录
+ (NSString *)jm_languageChatHistory;//聊天记录
+ (NSString *)jm_languageRelatedMessage;//条相关聊天记录
+ (NSString *)jm_languageClear;//清除
+ (NSString *)jm_languageScan;//扫一扫
+ (NSString *)jm_languageAlbum;//相册
+ (NSString *)jm_languageFlash;//闪光灯
+ (NSString *)jm_languageAlignQRCodeScan;//将二维码/条形码放入框内，即可自动扫描
+ (NSString *)jm_languageQRCodeInfo;//扫描结果
+ (NSString *)jm_languageCopy;//复制
+ (NSString *)jm_languageSendAMessage;//发送新消息
+ (NSString *)jm_languageNoResult;//无结果

#pragma mark ----------people----------
+ (NSString *)jm_languageNewFreinds;//新的朋友
+ (NSString *)jm_languageNoPeoplesGoAddPeoples;//暂无好友，快去添加好友吧～
+ (NSString *)jm_languageAddPeople;//添加好友
+ (NSString *)jm_languageFreind;//好友
+ (NSString *)jm_languageMessages;//发送信息
+ (NSString *)jm_languageAdded;//已同意
+ (NSString *)jm_languageAdd;//添加
+ (NSString *)jm_languageView;//查看
+ (NSString *)jm_languageRequestSent;//等待验证
+ (NSString *)jm_languageExpired;//过期
+ (NSString *)jm_languageApprove;//通过验证
+ (NSString *)jm_languageProfile;//详情资料
#pragma mark ----------wallet----------

#pragma mark ----------discover----------
+ (NSString *)jm_languageSearching;//正在搜索中...

#pragma mark ----------mine----------
+ (NSString *)jm_languageSettings;//设置
+ (NSString *)jm_languageAboutUs; //关于我们
+ (NSString *)jm_languageCurrencyUnit;//货币单位
+ (NSString *)jm_languageLogOut;//退出登录
+ (NSString *)jm_languageLanguage;//系统语言
+ (NSString *)jm_languageMyQRCode;//我的二维码
+ (NSString *)jm_languageSaveQRCodeToAlbum;//保存二维码到相册
+ (NSString *)jm_languageMyProfile; //个人资料
+ (NSString *)jm_languageName; //名字
+ (NSString *)jm_languageGender;//性别
+ (NSString *)jm_languageMale;//男
+ (NSString *)jm_languageFemale; //女
+ (NSString *)jm_languagePermissionSettingPrompt;//"没有权限，是否前往设置"
+ (NSString *)jm_languageVersion;// "版本";
+ (NSString *)jm_languageTakePhoto;// "拍照";
+ (NSString *)jm_languageChooseFromAlbum;// "从相册选择图片";
+ (NSString *)jm_languageDone;// "完成";
+ (NSString *)jm_languageRetake;// "重拍";
+ (NSString *)jm_languageUsePhoto;// "使用照片";
+ (NSString *)jm_languagePhotos;// "照片";
+ (NSString *)jm_languageAutomatic;// "自动";
+ (NSString *)jm_languageOpen;// "打开";
+ (NSString *)jm_languageClose;// "关闭";
+ (NSString *)jm_languageAuboutUsDescription;// 关于我们的描述;
+ (NSString *)jm_languageDetectNewVersion;// 检测新版;
+ (NSString *)jm_languageNoNetworkCommunication;// 无网通讯;
+ (NSString *)jm_languagePrompt; // 提示;
+ (NSString *)jm_languageTurnedOffNoNetworkCommunication;// 您已经关闭无网通讯，是否前往设置;
+ (NSString *)jm_languageUseNoNetworkCommunicationPrompt; // 使用无网通讯，需要打开wifi或蓝牙开关，如果要搜索附近使用安卓手机的人，请务必打开蓝牙开关;
@end
