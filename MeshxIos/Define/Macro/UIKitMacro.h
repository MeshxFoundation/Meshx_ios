//
//  UIKitMacro.h
//  MacroDemo
//
//  Created by xiaozhu on 2017/6/10.
//  Copyright © 2017年 xiaozhu. All rights reserved.
//

#ifndef UIKitMacro_h
#define UIKitMacro_h

/**
 被观察对象的属性字符串
 
 @param obj 被观察对象
 @param keyPath 被观察对象属性
 @return 被观察对象的属性字符串
 */
#define KObjKeyPath(obj,keyPath) [NSString stringWithUTF8String:((void)obj.keyPath,#keyPath)]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

#pragma mark- 颜色
//----------------------颜色---Start-------------------------
// 获取颜色--RGBA
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 获取颜色--RGB
#define RGB(r,g,b)          RGBA(r,g,b,1.0f)
// 获取颜色--十六进制（十六进制->十进制）0xFFEEAA
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 0.0 white, 0.0 alpha
#define kClearColor [UIColor clearColor]
// 1.0 white
#define kWhiteColor [UIColor whiteColor]
// 0.0 white
#define kBlackColor [UIColor blackColor]
// 0.5 white
#define kGrayColor [UIColor grayColor]
//0.667 white
#define kLightGrayColor [UIColor lightGrayColor]
// 0.0, 0.0, 1.0 RGB
#define kBlueColor [UIColor blueColor]
// 1.0, 0.0, 0.0 RGB
#define kRedColor [UIColor redColor]
// 1.0, 1.0, 0.0 RGB
#define kYellowColor [UIColor yellowColor]
// 0.5, 0.0, 0.5 RGB
#define kPurpleColor [UIColor purpleColor]
// 0.0, 1.0, 0.0 RGB
#define kGreenColor [UIColor greenColor]
// 0.0, 1.0, 1.0 RGB
#define kCyanColor [UIColor cyanColor]
// 0.6, 0.4, 0.2 RGB
#define kBrownColor [UIColor brownColor]

//随机色生成
#define kRandomColorKRGBColor (arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)


//----------------------颜色---End-------------------------

//----------------------图片---Start-------------------------

#pragma mark - 图片，返回UIImage
#define LoadCacheImage(name) [UIImage imageNamed:name]

#define LoadDiskImage(name)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]]

//----------------------图片---End-------------------------

//-----------------------UIApplication---Start------------------------

#pragma mark- UIApplication

//获取系统对象

#define kApplication [UIApplication sharedApplication]
#define kAppWindow [UIApplication sharedApplication].delegate.window
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kAppDelegate [UIApplication sharedApplication].delegate
/**
 显示状态栏上的加载菊花
 */
#define ShowNetworkActivityIndicatorVisible  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
/**
 隐藏状态栏上的加载菊花
 */
#define HiddenNetworkActivityIndicatorVisible  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

// openURL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define openURLWithString(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])

// telphone
#define canTel   ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]])

/**
 拨打电话

 @param phoneNumber 电话号码
 */
#define tel(phoneNumber)       ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]])

/**
 发短信
 
 @param phoneNumber 电话号码
 */
#define smsWithPhoneNumber(phoneNumber)       ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",phoneNumber]]])

#define telprompt(phoneNumber) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]])
//-----------------------UIApplication--End-------------------------



//-----------------------Alert--Start-------------------------
#pragma mark - Alert
/**
 title:提示标题
 msg:提示内容
 isShowCancel:是否显示取消按钮
 actionTitle:其他按钮名字
 block:点击其他按钮回调方法
 
 用法：   AlertView(@"提示", @"您好！", 1,@"确定",{
        NSLog(@"helloword");
    });
 */
#define AlertView(title,msg,isShowCancel,actionTitle,block) \
UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];\
if (isShowCancel) {UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];[alert addAction:cancelAction];}\
UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) block];[alert addAction:action];\
[self presentViewController:alert animated:YES completion:nil]


#define ShowAlertViewWithActionDetermine(title,msg,isShowCancel,block) AlertView(title,msg,isShowCancel,@"确定",block)

#define ShowAlertViewWithTitle(title,msg) \
UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];[alert addAction:action];\
[self presentViewController:alert animated:YES completion:nil]

#define ShowAlertView(msg) ShowAlertViewWithTitle(@"提示",msg)

#define ShowAlertViewWithNoTitle(msg) ShowAlertViewWithTitle(@"",msg)

//-----------------------Alert--End-------------------------


//View圆角和加边框
#define ViewBorderRadius(view,radius,width,color)\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];\
[view.layer setBorderWidth:(width)];\
[view.layer setBorderColor:[color CGColor]];
// View圆角
#define ViewRadius(view,radius)\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]

//-----------------------Xib和StoryBoard--Start-------------------------

#pragma mark - Xib和StoryBoard

/**
  将类名转成字符串
 */
#define ClassStringFromClassName(className) NSStringFromClass([className class])
/**
 读取xib文件
 name:xib文件名
 */
#define XibWithNibName(name) [[[NSBundle mainBundle]loadNibNamed:name owner:self options:nil] objectAtIndex:0]
/**
 读取xib文件
 className:类名 类名和xib文件名必须的一致
 */
#define XibWithClassName(className) XibWithNibName(ClassStringFromClassName(className));


/**
 加载storyboard文件

 @param SB storyboard文件名
 @param Identifier storyboardID
 @return UIViewController对象
 */
#define VCFromSBWithIdentifier(SB,Identifier) [[UIStoryboard storyboardWithName:SB bundle:nil] instantiateViewControllerWithIdentifier:Identifier]

//-----------------------Xib和StoryBoard--End-------------------------

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
//加粗字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
//系统字体
#define SYSTEMFONT(FONTSIZE)[UIFont systemFontOfSize:FONTSIZE]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)


//单例化一个类

#pragma mark - 单例化一个类

#define SINGLETON_FOR_HEADER(className)\
+(className *)shared##className;

#define SINGLETON_FOR_CLASS(className)\
+(className *)shared##className { \
    static className *shared##className = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken,^{ \
        shared##className =[[self alloc]init];\
    });\
    return shared##className;\
}

#endif /* UIKitMacro_h */
