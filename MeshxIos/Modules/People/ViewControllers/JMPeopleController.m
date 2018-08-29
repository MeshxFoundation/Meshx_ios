//
//  JMPeopleController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMPeopleController.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "SCIndexView.h"
#import "UITableView+SCIndexView.h"
#import "JMPeopleCell.h"
#import "JMPeopleSearchController.h"
#import "JMPeopleModel.h"
#import "JMTabBarPromptTool.h"
#import "JMPeopleEmptyDataView.h"
#import "JMSearchBarTool.h"

@interface JMPeopleController ()<UISearchBarDelegate,JMPeopleSearchControllerDelegate>

@property (strong, nonatomic) NSArray *firstSectionData;
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (strong, nonatomic) JMPeopleSearchController *searchPeopleResultController;
@property (nonatomic ,strong) JMPeopleEmptyDataView *emptyDataView;
@end

@implementation JMPeopleController


- (instancetype)init{
    if (self = [super init]) {
        self.searchPeopleResultController = [JMPeopleSearchController new];
        self.searchResultsController = self.searchPeopleResultController;
        self.isTabBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    NSArray *users = [JMPeopleModel findAllFriend];
    [self setupData:users];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XMPPRosterDidEndPopulating:) name:kJMXMPPRosterDidEndPopulatingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JMXMPPUser:) name:kJMXMPPUserNotification object:nil];

}

- (NSArray *)firstSectionData{
    if (!_firstSectionData) {
        _firstSectionData = [JMPeopleFirstSectionModel getFirstSectionData];
    }
    return _firstSectionData;
}

- (void)setupView{
    [self addFriend];
 
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.searchPeopleResultController.delegate = self;
    self.searchPeopleResultController.isOperatingTabBar = YES;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(JMPeopleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(JMPeopleCell.class)];
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:0];
    configuration.indexItemSelectedBackgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = NO;
   
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //判断搜索栏是否处于激活状态
    if (!self.searchController.active) {
        [self readData];
    }
     [JMTabBarPromptTool showPeopleItemDot];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)readData{
    GCDGlobalQueue(^{
        NSArray *users = [JMPeopleModel findAllFriend];
        GCDMainQueue(^{
             [self setupData:users];
        });
       
    });
}

- (void)changeLanguage{
    
    self.searchController.searchBar.placeholder = [JMLanguageManager jm_languageSearch];
    [JMSearchBarTool setupCancelTitle:[JMLanguageManager jm_languageCancel] searchController:self.searchController];
    self.firstSectionData = nil;
    [self.tableView reloadData];
    [_emptyDataView changeLanguage];
    
}



- (void)XMPPRosterDidEndPopulating:(NSNotification *)not{
    
    [self readData];
}

- (void)JMXMPPUser:(NSNotification *)not{
    
//    JMXMPPNotificationUserModel *model = not.object;
    [self readData];
}

- (void)setupData:(NSArray *)dataArray{
    
   
    [self clearData];
    if (!dataArray.count) {
        //说明花名册已经全部获取
        if ([JMXMPPTool sharedInstance].rosterTool.rosterType == JMXMPPRosterToolPopulatingTypeEnd) {
            [self.emptyDataView showEmptyDataView];
        }
        
        self.searchPeopleResultController.titleLabel.text = @"";
        return;
    }
   
    self.searchPeopleResultController.titleLabel.hidden = self.searchController.isActive;
    self.searchPeopleResultController.titleLabel.text = [NSString stringWithFormat:@"%ld",dataArray.count];
    _allDataSource = [HCSortString sortAndGroupForArray:dataArray PropertyName:kJMSearchPropertyName];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    _searchPeopleResultController.allDataSource = _allDataSource;
    NSMutableArray *indexViewData = [[NSMutableArray alloc] initWithArray:_indexDataSource];
    [indexViewData insertObject:UITableViewIndexSearch atIndex:0];
    self.tableView.sc_indexViewDataSource = indexViewData;
    if (_allDataSource.count) {
        [_emptyDataView hiddenEmptyDataView];
    }
    [self.tableView reloadData];
   
}

- (void)clearData{
    
    [self.tableView.sc_indexView clearData];
    _allDataSource = nil;
    _indexDataSource = nil;
    self.tableView.sc_indexView = nil;
    _searchPeopleResultController.allDataSource = @{};
    self.tableView.sc_indexViewDataSource = @[];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

     return _indexDataSource.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.firstSectionData.count;
    }
    NSArray *value = [_allDataSource objectForKey:_indexDataSource[section-1]];
    return value.count;
    
}
//////头部索引标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//        if (section == 0) {
//            return nil;
//        }
//        return _indexDataSource[section-1];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    view.backgroundColor = JMCustomTableViewBackgroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 20)];
    titleLabel.text = _indexDataSource[section-1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor grayColor];
    [view addSubview:titleLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  0.0001;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JMPeopleCell.class)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        JMPeopleFirstSectionModel *model = self.firstSectionData[indexPath.row];
        [cell setupFirstSectionCellWithModel:model];
    }else{
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section-1]];
       JMBaseModel * model = value[indexPath.row];
        cell.jm_model = model;
    }
    return cell;
}



#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self selectFirstSection:self.firstSectionData[indexPath.row]];
    }else{
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section-1]];
       JMBaseModel *obj = value[indexPath.row];
        [self selectFriend:obj];
    }
}

- (void)selectFirstSection:(JMPeopleFirstSectionModel *)model{
    if ([model.title isEqualToString:[JMLanguageManager jm_languageNewFreinds]]) {
        NSLog(@"++++新的朋友");
    }
}

- (void)selectFriend:(JMBaseModel *)obj{
    
}



- (void)selectObj:(JMBaseModel *)obj{
    [self selectFriend:obj];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGFloat offestY = scrollView.contentOffset.y;
//    NSArray *cells = [self.tableView visibleCells];
//    UITableViewCell *cell = cells.lastObject;
//    CGFloat sizeH = kScreen_Height-49-64;
//    if (cell.frame.origin.y < sizeH) {
//        [self.tableView setContentOffset:CGPointZero animated:NO];
//    }
//    NSLog(@"=====%@+====",NSStringFromCGRect(cell.frame));
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [_searchPeopleResultController searchButtonClick];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JMPeopleCell jm_cellHeight];
}


#pragma mark --JMNewFriendControllerDelegate
- (void)setupNewFriendPrompt{
    for (int i = 0; i < self.firstSectionData.count; i++) {
        JMPeopleFirstSectionModel *model = self.firstSectionData[i];
        if ([model.title isEqualToString:[JMLanguageManager jm_languageNewFreinds]]) {
            if (model.num) {
                model.cell.promptLabel.hidden = YES;
            }
            [JMTabBarPromptTool showPeopleItemDot];
            break;
        }
    }
    
}

- (JMPeopleEmptyDataView *)emptyDataView{
    if (!_emptyDataView) {
        _emptyDataView = [JMPeopleEmptyDataView createEmptyDataView];
        _emptyDataView.frame = CGRectMake(0, 0,280, 200);
        _emptyDataView.center = self.tableView.center;
        WEAKSELF
        [_emptyDataView addPeople:^(id sender) {
            STRONGSELF
            [strongSelf rightBarButtonItemClick:nil];
        }];
        [_emptyDataView changeLanguage];
        [self.tableView addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
