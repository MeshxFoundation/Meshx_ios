//
//  JMMeshXIosHeader.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMBaseViewController.h"
#import "JMBaseTableViewController.h"
#import "JMBaseNavigationController.h"
#import "JMXMPPTool.h"
#import "JMProgressHUDTool.h"
#import "JMBaseTableViewCell.h"
#import "JMConstant.h"
#import "JMMacroHeader.h"
#import "JJCategories.h"
#import "YYCategories.h"
#import "YYModel.h"
#import "MJExtension.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JMEventIDManager.h"
#import "LCProgressHUD.h"
#import "JMFileSaveManager.h"
#import "EasyBlueToothManager.h"
#import "JJTransportProcess.h"
#import "MCSessionProcess.h"
#import "JMHeaderImageManager.h"
#import "JMMyInfo.h"
#import "JMLanguageManager.h"



//* Debug 输出宏 release不输出宏

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>




#endif

