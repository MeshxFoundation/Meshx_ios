//
//  JMPeopleSearchController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/15.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMPeopleSearchController.h"
#import "JMPeopleCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import "JMPeopleModel.h"
#import "ToastTool.h"
#import "JMSearchPeopleTool.h"

@interface JMPeopleSearchController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,assign) BOOL searchStatus;
@end

@implementation JMPeopleSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableViewWithStyle:UITableViewStylePlain registerClass:JMPeopleCell.class];
}

- (void)setSearchController:(UISearchController *)searchController{
    [super setSearchController:searchController];
    [self setupTitleLabelRect];
  NSLog(@"____%@====",NSStringFromCGRect(searchController.searchBar.frame));
}

- (void)setupTitleLabelRect{
    self.titleLabel.frame =CGRectMake(CGRectGetWidth(self.searchController.searchBar.frame)-20-40, 0, 40, 22);
    self.titleLabel.center = CGPointMake(_titleLabel.center.x, CGRectGetHeight(self.searchController.searchBar.frame)/2.0);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.hidden = YES;
        [self.searchController.searchBar addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchStatus) {
        return self.resultArray.count;
    }
    if (self.resultStr.length>0) {
        return 1;
    }
    return 0;
}

- (void)setSearchStatus:(BOOL)searchStatus{
    _searchStatus = searchStatus;
    if (searchStatus == NO) {
        self.promptLabel.hidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchStatus) {
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:kJMMainColorHexString];
        if (self.resultStr.length>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[JMLanguageManager jm_languageSearch],self.resultStr];
        }else{
            cell.textLabel.text = @"";
        }
        
        return cell;
    }
    JMPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JMPeopleCell.class)];
    JMBaseModel *obj = self.resultArray[indexPath.row];
    cell.jm_model = obj;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.searchStatus) {
        return 44;
    }
    return [JMPeopleCell jm_cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    _titleLabel.hidden = YES;
    NSString *text = searchController.searchBar.text;
    if (![self.resultStr isEqualToString:text]&&text.length) {
        self.resultStr = text;
        self.searchStatus = NO;
        [self.tableView reloadData];
    }
    
}

- (void)updateDataWithText{
    self.searchStatus = YES;
    [self.resultArray removeAllObjects];
    if (self.allDataSource) {
        if (self.allDataSource.allValues.count) {
            [self searchOldPeople];
        }else{
            self.promptLabel.hidden = NO;
        }
        
    }else{
        [self searchNewPeople];
    }
   [self.tableView reloadData];
}

- (void)searchOldPeople{
    //对排序好的数据进行搜索
        NSArray *ary = [ZYPinYinSearch searchWithOriginalArray:[HCSortString getAllValuesFromDict:_allDataSource] andSearchText:self.resultStr andSearchByPropertyName:kJMSearchPropertyName];
        [self.resultArray addObjectsFromArray:ary];
    if (!self.resultArray.count) {
        self.promptLabel.hidden = NO;
    }
}

- (void)searchNewPeople{
    if (self.resultStr.length > 0) {
        [JMProgressHUDTool show];
        [JMSearchPeopleTool searchWithString:self.resultStr result:^(BOOL isSuccess, NSArray<JMPeopleModel *> *dataArray) {
            [JMProgressHUDTool hidden];
            if (isSuccess) {
                [self.resultArray removeAllObjects];
                [self.resultArray addObjectsFromArray:dataArray];
                if (!self.resultArray.count) {
                    self.promptLabel.hidden = NO;
                }
                [self.tableView reloadData];
            }else{
                NSString *title = [NSString stringWithFormat:@"%@ %@",[JMLanguageManager jm_languageSearch],[JMLanguageManager jm_languageFail]];
                JMShowToastWindow(title);
            }
            
        }];

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"======%ld=====",indexPath.row);
    
    if (!self.searchStatus) {
        [self updateDataWithText];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(selectObj:)]) {
        [self.delegate selectObj:self.resultArray[indexPath.row]];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated]; self.presentingViewController.navigationController.navigationBar.hidden = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
    [self isHiddenTabBar:YES];
}

- (void)searchButtonClick{
    [self updateDataWithText];
    [self isHiddenTabBar:YES];
}


- (void)willDismissSearchController:(UISearchController *)searchController{
     [self isHiddenTabBar:NO];
   
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    
    [self setupTitleLabelRect];
    if (self.isOperatingTabBar) {
        _titleLabel.hidden = NO;
    }
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    _titleLabel.hidden = YES;
    [self isHiddenTabBar:YES];
}



- (void)isHiddenTabBar:(BOOL)isHidden{
    if (self.isOperatingTabBar) {
       JMHiddenTabBar(isHidden);
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
