//
//  JMChatCompanyInfoController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/27.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMChatCompanyInfoController.h"
#import "JMChatCompanyInfoTableHeaderView.h"
#import "JMPeopleModel.h"
#import "JMChatController.h"
#import "JMSearchChatContentController.h"

static NSString *const kJMJMChatCompanyInfoTextName = @"name";

@interface JMChatCompanyInfoController ()<JMChatCompanyInfoTableHeaderViewDelegate,JMSearchChatContentControllerDelegate>
@property (weak, nonatomic) IBOutlet JMChatCompanyInfoTableHeaderView *tableHeaderView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation JMChatCompanyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView{
    self.title = [JMLanguageManager jm_languageDetails];
    [self initData];
    [self.tableHeaderView showViewWithDatas:@[self.model] viewController:self];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    //    [self textData];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:ClassStringFromClassName(UITableViewCell)];
    self.tableHeaderView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = JMCustomTableViewBackgroundColor;
    [self.tableView reloadData];
}

- (void)initData{
    [self.dataArray addObjectsFromArray:@[@[@{kJMJMChatCompanyInfoTextName:[JMLanguageManager jm_languageSearchHistory]}],@[@{kJMJMChatCompanyInfoTextName:[JMLanguageManager jm_languageClearChatHistory]}]]];
}

- (void)textData{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i < 18; i ++) {
        JMPeopleModel *model = [JMPeopleModel new];
        model.name = [NSString stringWithFormat:@"小青%ld",i+1];
        [arr addObject:model];
    }
    
    [self.tableHeaderView showViewWithDatas:arr viewController:self];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassStringFromClassName(UITableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id obj = self.dataArray[indexPath.section][indexPath.row];
    NSString *text = [obj valueForKey:kJMJMChatCompanyInfoTextName];
    if ([text isEqualToString:[JMLanguageManager jm_languageSearchHistory]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = text;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)selectModel:(JMBaseModel *)obj{

}

- (void)selectChatHistoryWithModel:(JMHomeModel *)homeModel{
    JMChatController *chatController = [JMChatController new];
    chatController.homeModel = homeModel;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:[JMLanguageManager jm_languageClearChatHistory]]) {
        NSLog(@"----%@----",[JMLanguageManager jm_languageClearChatHistory]);
        [self showAlert];
        
    }else if ([cell.textLabel.text isEqualToString:[JMLanguageManager jm_languageSearchHistory]]){
        
        JMSearchChatContentController *searchChat = [JMSearchChatContentController new];
        searchChat.model = self.model;
        searchChat.delegate = self;
//        [self setupSearchResultsController:searchChat];
        [self.navigationController pushViewController:searchChat animated:YES];
        NSLog(@"----%@----",[JMLanguageManager jm_languageSearchHistory]);
    }
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[JMLanguageManager jm_languageClearChatHistory] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:[JMLanguageManager jm_languageClear] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearChatData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[JMLanguageManager jm_languageCancel] style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:clearAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearChatData{
    NSString *userID = [self.model valueForKey:@"userID"];
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"userID"),bg_sqlValue(userID)];
    //删除数据库内容
    [XHMessage bg_delete:nil where:where];
    
    JMChatController *chatController = (JMChatController *)[(JMBaseNavigationController *)self.navigationController getControllerWithClass:JMChatController.class];
    if (chatController) {
        [chatController.messages removeAllObjects];
        [chatController.messageTableView reloadData];
    }

    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
