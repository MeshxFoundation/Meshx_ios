//
//  JMHomeSearchController.m
//  MeshxIos
//
//  Created by xiaozhu on 2018/7/20.
//  Copyright © 2018年 Mobile. All rights reserved.
//

#import "JMHomeSearchController.h"
#import "JMPeopleCell.h"
#import "JMHomeSearchModel.h"
#import "JMHomeCell.h"
#import "JMHomeSearchChatModel.h"
#import "JMSearchChatContentCell.h"
#import "JMSearchChatContentController.h"
#import "JMHomeController.h"

@interface JMHomeSearchController ()

@end

@implementation JMHomeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewWithStyle:UITableViewStyleGrouped registerClass:nil];
    self.tableView.sectionHeaderHeight = 25;
    self.tableView.sectionFooterHeight = 0;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *text = searchController.searchBar.text;
    if (![self.resultStr isEqualToString:text]&&text.length) {
        self.resultStr = text;
        [self updateDataWithText:text];
    }
    
}

- (void)updateDataWithText:(NSString *)text{
    GCDGlobalQueue(^{
        @synchronized(self) {
            [self.resultArray removeAllObjects];
            [self searchResultWithText:text];
            GCDMainQueue(^{
                self.promptLabel.hidden = self.resultArray.count;
                [self.tableView reloadData];
            });
        }
    });
    
}

- (void)searchResultWithText:(NSString *)text{
    
    JMHomeSearchModel *peopleModel = [self searchPeopleWithText:text];
    if (peopleModel) {
    [self.resultArray addObject:[self searchPeopleWithText:text]];
    }
    JMHomeSearchModel *chatModel = [self searchChatHistoryWithText:text];
    if (chatModel) {
        [self.resultArray addObject:chatModel];
    }
    
}

- (JMHomeSearchModel *)searchPeopleWithText:(NSString *)text{
    NSString *resultString = [NSString stringWithFormat:@"%%%@%%",text];
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ like %@ order by %@ desc",bg_sqlKey(@"type"),bg_sqlValue(@(1)),bg_sqlKey(@"name"),bg_sqlValue(resultString),bg_sqlKey(@"name")];
    NSArray *array = [JMPeopleModel bg_find:nil where:where];
    if (array.count) {
        JMHomeSearchModel *model = [[JMHomeSearchModel alloc] initWithTitle:[JMLanguageManager jm_languagePeople] type:JMHomeSearchTypePeople dataArray:array];
        return model;
    }
    return nil;
}

- (JMHomeSearchModel *)searchChatHistoryWithText:(NSString *)text{
    NSString *resultString = [NSString stringWithFormat:@"%%%@%%",text];
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ like %@ order by %@ desc",bg_sqlKey(@"messageMediaType"),bg_sqlValue(@(0)),bg_sqlKey(@"text"),bg_sqlValue(resultString),bg_sqlKey(@"bg_createTime")];
    NSArray *messages = [XHMessage bg_find:nil where:where];
    if (!messages.count) {
        return nil;
    }

  __block  NSMutableArray *searchMessageDatas = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *msg = (XHMessage *)obj;
        [dic setObject:msg.userID forKey:msg.userID];
    }];
    [dic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *userID = (NSString *)obj;
        NSArray <XHMessage *>*userMessages = [messages jj_filteredWithKey:@"userID" value:userID];
        JMHomeSearchChatModel *chatModel = [[JMHomeSearchChatModel alloc] initWithUserID:userID messages:userMessages];
        chatModel.resultStr = self.resultStr;
        [searchMessageDatas addObject:chatModel];
        
    }];
    
    return  [[JMHomeSearchModel alloc] initWithTitle:[JMLanguageManager jm_languageChatHistory] type:JMHomeSearchTypeChatHistory dataArray:searchMessageDatas];
    
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JMHomeSearchModel *searchModel = self.resultArray[section];
    return searchModel.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMHomeSearchModel *searchModel = self.resultArray[indexPath.section];
 
    switch (searchModel.type) {
        case JMHomeSearchTypePeople:
        {
            static NSString *identifier = @"PeopleCell";
            JMPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass(JMPeopleCell.class) bundle:nil];
                cell = [nib instantiateWithOwner:nib options:nil].firstObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            JMBaseModel * model = searchModel.dataArray[indexPath.row];
            cell.jm_model = model;
            return cell;

        }
            break;
        case JMHomeSearchTypeChatHistory:{
            static NSString *identifier = @"ChatCell";
            JMSearchChatContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass(JMSearchChatContentCell.class) bundle:nil];
                cell = [nib instantiateWithOwner:nib options:nil].firstObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
              JMHomeSearchChatModel * model = searchModel.dataArray[indexPath.row];
            [cell setupViewWithChatModel:model searchText:self.resultStr];
            return cell;
        }
            break;
            
        default:
            break;
    }
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JMHomeCell jm_cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
     JMHomeSearchModel *searchModel = self.resultArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 25)];
    label.text = searchModel.title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JMHomeSearchModel *searchModel = self.resultArray[indexPath.section];
    switch (searchModel.type) {
        case JMHomeSearchTypePeople:
        {
            JMPeopleModel *peopleModel = searchModel.dataArray[indexPath.row];
            if ([self.delegate respondsToSelector:@selector(selectPeople:)]) {
                [self.delegate selectPeople:peopleModel];
            }
        }
            break;
        case JMHomeSearchTypeChatHistory:
        {
            JMHomeSearchChatModel * model = searchModel.dataArray[indexPath.row];
            if (model.messages.count == 1) {
                if ([self.delegate respondsToSelector:@selector(selectPeopleChatHistoryWithModel:)]) {
                    XHMessage *message = model.messages.firstObject;
                    JMHomeModel *homeModel = [JMHomeModel new];
                    homeModel.isChatHistory = YES;
                    homeModel.jid = [JMXMPPUserManager getJidWithUserID:message.userID];
                    homeModel.message = message;
                    [self.delegate selectPeopleChatHistoryWithModel:homeModel];
                }
                
            }else{
                
                JMSearchChatContentController *chatContentController = [JMSearchChatContentController new];
                chatContentController.chatModel = model;
                UINavigationController *nav = [JMTabBarController getNavigationControllerWithClass:JMHomeController.class];
                JMHomeController *homeController = (JMHomeController *)nav.viewControllers.firstObject;
                chatContentController.delegate = homeController;
                [nav pushViewController:chatContentController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)searchButtonClick{
    [self updateDataWithText:self.resultStr];
    JMHiddenTabBar(YES);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchController.searchBar resignFirstResponder];
     JMHiddenTabBar(YES);
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    JMHiddenTabBar(NO);
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    
   JMHiddenTabBar(YES);
}

- (void)dealloc{
    
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
