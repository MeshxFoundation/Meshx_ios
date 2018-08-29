//
//  JMSearchChatContentController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/28.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMSearchChatContentController.h"
#import "JMSearchChatContentCell.h"

@interface JMSearchChatContentController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) BOOL searchStatus;
@property (nonatomic ,strong) NSString *resultStr;
@property (nonatomic ,strong) UILabel *promptLabel;
//搜索结果
@property (nonatomic ,strong) NSMutableArray *searchResultArray;
@end

@implementation JMSearchChatContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarButtonItem];
    if (self.chatModel) {
        self.model = self.chatModel;
        self.resultStr = self.chatModel.resultStr;
        self.searchBar.text = self.chatModel.resultStr;
        self.searchStatus = YES;
        [self.searchResultArray removeAllObjects];
        [self.searchResultArray addObjectsFromArray:self.chatModel.messages];
        [self.tableView reloadData];
    }
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)setBarButtonItem
{
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    //用来放searchBar的View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    //关闭自动首字母大写
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //默认提示文字
    searchBar.placeholder = [JMLanguageManager jm_languageSearch];
//    //背景图片
//    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    //代理
    searchBar.delegate = self;
    //显示右侧取消按钮
    searchBar.showsCancelButton = YES;
    //光标颜色
    searchBar.tintColor = UIColorFromRGB(0x595959);
    //拿到searchBar的输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    [self setupSearchTextLeftView:searchTextField];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:15];
//    //拿到取消按钮
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
//    //设置按钮上的文字
    [cancleBtn setTitle:[JMLanguageManager jm_languageCancel] forState:UIControlStateNormal];
    
//    //设置按钮上文字的颜色
    [cancleBtn setTitleColor:[[UIColor alloc] initWithRed:47/255.0 green:142/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
    
}

- (void)setupSearchTextLeftView:(UITextField *)textField{
    if (self.chatModel) {
        CGFloat imageViewWH = 20;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWH, imageViewWH)];
        imageView.image = [UIImage imageNamed:@"search_icon"];
        imageView.center = CGPointMake(imageView.center.x, CGRectGetHeight(textField.frame)/2.0);
        UILabel *label = [[UILabel alloc] init];
        
        label.text = self.chatModel.name;
        label.textColor = [UIColor colorWithHexString:kJMMainColorHexString];
        label.font = textField.font;
        CGSize size = [self.chatModel.name boundingRectWithSize:CGSizeMake(INT_MAX, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
        label.frame = CGRectMake(imageViewWH, 0, size.width, size.height);
        label.center = CGPointMake(label.center.x, CGRectGetHeight(textField.frame)/2.0);
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftView.backgroundColor = [UIColor redColor];
        [leftView addSubview:imageView];
        [leftView addSubview:label];
        leftView.frame = CGRectMake(0, 0, imageViewWH+size.width, CGRectGetHeight(textField.frame));
        textField.leftView = leftView;
    }
   
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchStatus) {
        return self.searchResultArray.count;
    }
    if (_resultStr.length>0) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.searchStatus) {
        static NSString *cellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:kJMMainColorHexString];
        if (_resultStr.length>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[JMLanguageManager jm_languageSearch],_resultStr];
        }else{
            cell.textLabel.text = @"";
        }
        
        return cell;
    }
 
    JMSearchChatContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassStringFromClassName(JMSearchChatContentCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupViewWithMessage:self.searchResultArray[indexPath.row] searchText:self.resultStr];
    return cell;
 
}

#pragma mark ==============UITableViewDelegate==========

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.searchStatus) {
        [self searchData];
    }else{
        if ([self.delegate respondsToSelector:@selector(selectChatHistoryWithModel:)]) {
            XHMessage *message = self.searchResultArray[indexPath.row];
             NSString *userID = [self.model valueForKey:@"userID"];
            JMHomeModel *homeModel = [JMHomeModel findModelWithUserID:userID];
            if (!homeModel) {
                homeModel =  [JMHomeModel new];
                homeModel.jid = [JMXMPPUserManager getJidWithUserID:userID];
            }
            homeModel.isChatHistory = YES;
            homeModel.message = message;
            [self.delegate selectChatHistoryWithModel:homeModel];
        }
        
    }
}

- (void)searchData{
    self.searchStatus = YES;
    GCDGlobalQueue(^{
        self.searchResultArray = [[self findModel] mutableCopy];
        GCDMainQueue(^{
            [self.tableView reloadData];
            if (!self.searchResultArray.count) {
                self.promptLabel.hidden = NO;
            }
        });
    });
}

- (NSArray *)findModel{
    NSString *userID = [self.model valueForKey:@"userID"];
    NSString *resultString = [NSString stringWithFormat:@"%%%@%%",_resultStr];
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ = %@ and %@ like %@ order by %@ desc",bg_sqlKey(@"userID"),bg_sqlValue(userID),bg_sqlKey(@"messageMediaType"),bg_sqlValue(@(0)),bg_sqlKey(@"text"),bg_sqlValue(resultString),bg_sqlKey(@"bg_createTime")];
    return  [XHMessage bg_find:nil where:where];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SearchButton");
     [self searchData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _resultStr = searchText;
    self.searchStatus = NO;
    [self.tableView reloadData];
    self.promptLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JMSearchChatContentCell class]) bundle:nil] forCellReuseIdentifier:ClassStringFromClassName(JMSearchChatContentCell)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
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

@end
