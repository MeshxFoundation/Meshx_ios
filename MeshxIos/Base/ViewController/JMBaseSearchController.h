//
//  JMBaseSearchController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseViewController.h"
#import "JMBaseSearchResultController.h"

@interface JMBaseSearchController : JMBaseViewController<UISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UITableView *tableView;
//是否含有TabBar页面
@property (assign, nonatomic) BOOL isTabBar;
//搜索
@property (strong, nonatomic) UISearchController *searchController;
//搜索结果 UIViewController
@property (strong, nonatomic) JMBaseSearchResultController *searchResultsController;
- (void)setupSearchResultsController:(UIViewController *)searchResultsController;
- (void)rightBarButtonItemClick:(UIButton *)btn;
- (void)addFriend;

@end
