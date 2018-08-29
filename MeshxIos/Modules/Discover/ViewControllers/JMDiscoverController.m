//
//  JMDiscoverController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMDiscoverController.h"
#import "JMHomeModel.h"
#import "JMChatController.h"
@interface JMDiscoverController ()
@end

@implementation JMDiscoverController

- (BOOL)fd_prefersNavigationBarHidden{
    return !self.dataSources.count;
}

- (instancetype) init{
    if (self = [super init]) {
        _process = [[JMDiscoverProcess alloc] initWithViewController:self];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView{
    _scanView = XibWithClassName(JMDiscoverScanView);
    _scanView.frame = CGRectMake(0, -20, CGRectGetWidth(self.view.frame), kScreen_Height-kTabbarHeight+20);
    [_scanView scan];
    [self.view addSubview:_scanView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听是否重新进入程序程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)                                                name:UIApplicationDidBecomeActiveNotification object:nil];
    [self reScan];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)applicationDidBecomeActive{
     [self reScan];
}

- (void)reScan{
    
}

- (void)changeLanguage{
    [self.scanView changeLanguage];
}


@end
