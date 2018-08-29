//
//  JMBaseSearchResultController.h
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseViewController.h"


@interface JMBaseSearchResultController : JMBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *promptLabel;
@property (nonatomic ,strong) NSString *resultStr;
@property (nonatomic ,strong) NSMutableArray *resultArray;
@property (nonatomic ,weak) UISearchController *searchController;
- (void)searchButtonClick;
- (void)setupTableViewWithStyle:(UITableViewStyle)style registerClass:(Class)nibClass;
@end
