//
//  JMBaseSearchResultController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseSearchResultController.h"

@interface JMBaseSearchResultController ()

@end

@implementation JMBaseSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _promptLabel.text = [JMLanguageManager jm_languageNoResult];
}

- (void)setupTableViewWithStyle:(UITableViewStyle)style registerClass:(Class)nibClass{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreen_Width, kScreen_Height) style:style];
    if (nibClass) {
       [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(nibClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(nibClass)];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    [self.view addSubview:self.tableView];
    self.searchController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}


- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

}
- (void)searchButtonClick{
    
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
        _promptLabel.center = CGPointMake(self.view.center.x, 220);
        _promptLabel.text = [JMLanguageManager jm_languageNoResult];
        _promptLabel.textColor = [UIColor grayColor];
        _promptLabel.hidden = YES;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_promptLabel];
    }
    return _promptLabel;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
}


@end
