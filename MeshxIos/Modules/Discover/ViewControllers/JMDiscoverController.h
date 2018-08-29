//
//  JMDiscoverController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMDiscoverProcess.h"
#import "JMDiscoverScanView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface JMDiscoverController : JMBaseViewController
@property (nonatomic ,strong) NSMutableArray *dataSources;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) JMDiscoverProcess *process;
@property (nonatomic ,strong) JMDiscoverScanView *scanView;

@end
