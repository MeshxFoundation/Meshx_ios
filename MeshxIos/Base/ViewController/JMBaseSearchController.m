//
//  JMBaseSearchController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMBaseSearchController.h"
#import "JMSearchBarTool.h"
@interface JMBaseSearchController ()

@end

@implementation JMBaseSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseSearchView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isTabBar) {
        self.navigationController.navigationBar.hidden = NO;
        if (self.searchController.isActive) {
            JMHiddenTabBar(YES);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaseSearchView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
     [self.view addSubview:self.tableView];
    if (self.isTabBar) {
        if (self.navigationController.navigationBar.translucent) {
            self.tableView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreen_Height-kTabbarHeight);
        }else{
            self.tableView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreen_Height-kTabbarHeight-kNavHeight);
        }
    }
    [self setupSearchResultsController];
}

- (void)setupSearchResultsController{
    self.definesPresentationContext = YES;
    _searchController = [JMSearchBarTool setupSearchResultsController:self.searchResultsController];
    _searchResultsController.searchController = self.searchController;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    if (@available(iOS 11.0, *)) {
       [self.searchController.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[UISearchBar class]]) {
        UISearchBar *searchBar = (UISearchBar *)object;
        CGRect rect = [change[@"new"] CGRectValue];
        if (rect.origin.y<0) {
            rect.origin.y = -rect.origin.y;
            rect.size.height = 52;
            searchBar.frame = rect;
        }
        
    }
    
}

- (void)addFriend{
    UIColor *cbColor = [UIColor colorWithHexString:kJMMainColorHexString];
//    UIImage *addFriendImage = [[[UIImage imageNamed:@"addFriend_white"] jj_ratioScaleToSize:1] jj_imageWithTintColor:cbColor];
     UIImage *addFriendImage = [[UIImage imageNamed:@"addFriend"] jj_imageWithTintColor:cbColor];
    [self setupRightItemWithImage:addFriendImage];
}

- (void)rightBarButtonItemClick:(UIButton *)btn{

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchResultsController searchButtonClick];
}

- (void)dealloc{
    if (@available(iOS 11.0, *)) {
         [self.searchController.searchBar removeObserver:self forKeyPath:@"frame"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
