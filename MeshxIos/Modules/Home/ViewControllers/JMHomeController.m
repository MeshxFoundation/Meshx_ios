//
//  JMHomeController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMHomeController.h"
#import "JMChatController.h"
#import "JMHomeMsgProcess.h"
#import "JMHomeModel.h"
#import "JMHomeCell.h"
#import "JMReceiveMsgProcess.h"
#import "JMChatReadMsgProcess.h"
#import "RHSocketUtils.h"
#import "JJPeripheralManager.h"
#import "JMBLReceiveMsgProcess.h"
#import "JMLoginConnectionTool.h"
#import "JMTabBarPromptTool.h"
#import "JMDateTool.h"
#import "JMNetworkConnectionProcess.h"
#import "JMReceiveMsgProcess.h"
#import "JMHomeAddMenuView.h"
#import "JMHomeSearchController.h"
#import "JMSearchBarTool.h"
#import "UIScrollView+EmptyDataSet.h"


@interface JMHomeController ()<UITableViewDelegate,UITableViewDataSource,JMHomeSearchControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (strong ,nonatomic) MCSessionProcess *sessionProcess;
@property (nonatomic ,strong) JMNetworkConnectionProcess *netWordProcess;
@property (strong, nonatomic) JMHomeSearchController *searchHomeResultController;
@end

@implementation JMHomeController

- (instancetype)init{
    if (self = [super init]) {
       _msgProcess = [[JMHomeMsgProcess alloc] initWithViewController:self];
        _netWordProcess = [JMNetworkConnectionProcess new];
        self.searchHomeResultController = [JMHomeSearchController new];
        self.searchResultsController = self.searchHomeResultController;
        self.isTabBar = YES;
        [[MCSessionProcess sharedInstance] sessionManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [[UIImage imageNamed:@"add_icon"] jj_imageWithTintColor:[UIColor colorWithHexString:kJMMainColorHexString]];
    [self setupRightItemWithImage:image];
//    [JMLoginConnectionTool connection];
    [self initView];
    [self showTabBarPrompt];
  
    
    // Do any additional setup after loading the view.
}

-(void)rightBarButtonItemClick:(UIButton *)btn{
    JMHomeAddMenuView *menuView = [JMHomeAddMenuView new];
    [menuView showWithSender:btn viewController:self];
}

//显示TabBar提示
- (void)showTabBarPrompt{
    //首页提示
    [JMReceiveMsgProcess setupTabbarBadgeWithUserID:nil];
    //人脉的提示
    [JMTabBarPromptTool showPeopleItemDot];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    //判断搜索栏是否处于激活状态
//    if (self.searchController.active) {
//        JMHiddenTabBar(YES);
//    }
    [self.tableView reloadData];
  
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [NSMutableArray arrayWithArray:[JMHomeModel getAllModel]];
    }
    return _dataSources;
}


- (void)initView{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JMHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JMHomeCell class])];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.searchHomeResultController.delegate = self;
}


- (void)changeLanguage{
    
    self.searchController.searchBar.placeholder = [JMLanguageManager jm_languageSearch];
    [JMSearchBarTool setupCancelTitle:[JMLanguageManager jm_languageCancel] searchController:self.searchController];
    [self.tableView reloadEmptyDataSet];
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSources.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JMHomeCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JMHomeModel *homeModel = [self.dataSources objectAtIndex:indexPath.row];
    cell.model = homeModel;
    return cell;
}

#pragma mark ==============UITableViewDelegate==========

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JMHomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JMHomeModel *homeModel = cell.model;
    [self pushChatController:homeModel];

}

- (void)pushChatController:(JMHomeModel *)homeModel{

    JMChatController *chatController = [JMChatController new];
    chatController.homeModel = homeModel;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)selectPeople:(JMPeopleModel *)peopleModel{
    JMHomeModel *homeModel = [JMHomeModel new];
    homeModel.jid = peopleModel.jid;
    [self pushChatController:homeModel];
}

- (void)selectPeopleChatHistoryWithModel:(JMHomeModel *)homeModel{
    [self selectChatHistoryWithModel:homeModel];
}

- (void)selectChatHistoryWithModel:(JMHomeModel *)homeModel{
    [self pushChatController:homeModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return [JMHomeCell jm_cellHeight];
}

//设置表格可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

#pragma mark 返回编辑模式，默认为删除模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 只要实现这个方法，就实现了默认滑动删除！
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JMHomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        JMHomeModel *homeModel = cell.model;
        [self.dataSources removeObject:homeModel];
        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadEmptyDataSet];
        [JMReceiveMsgProcess setupTabbarBadgeWithUserID:homeModel.userID];
        GCDGlobalQueue(^{
            [JMHomeModel deleteWithUserID:homeModel.userID];
        });
        
    }
}

//删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JMLanguageManager jm_languageDelete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"none_chat_messages"];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [JMLanguageManager jm_languageNoChatInformation];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
