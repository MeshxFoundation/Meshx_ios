//
//  JMChatController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/21.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMChatController.h"
#import "FaceSourceManager.h"
#import "JMChatSelectedMsgProcess.h"
#import "JMFileSaveManager.h"
#import "JMChatReadMsgProcess.h"
#import "JMReceiveMsgProcess.h"
#import "JMChatCompanyInfoController.h"
#import "JMChatConnectionProcess.h"
#import "JMChatUpdateMsgProcess.h"

@interface JMChatController ()<XHMessageTextViewDelegate>
@property (nonatomic ,strong) FaceSourceManager *faceSourceManager;
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;
@property (nonatomic ,strong) JMChatSelectedMsgProcess *selectedMsgProcess;
@property (nonatomic ,strong) JMChatReadMsgProcess *readMsgProcess;
@property (nonatomic ,strong) JMChatConnectionProcess *connectionProcess;

@end

@implementation JMChatController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self postDraftMsgNotification];
 
}

//发送草稿通知
- (void)postDraftMsgNotification{
    if (self.messageInputView.inputTextView.text.length) {
        MCSessionModel * sessionModel = [MCSessionModel new];
        JJTransportProcess *process = [JJTransportProcess new];
        process.type = kJMChatMsgTextAPI;
        process.msg = nil;
        sessionModel.process = process;
        JMHomeDraftModel *draftModel = [[JMHomeDraftModel alloc] initWithText:self.messageInputView.inputTextView.text timestamp:[NSDate date]];
        sessionModel.draftModel = draftModel;
        sessionModel.jid = self.homeModel.jid;
        switch (self.homeModel.communicationType) {
            case JMCommunicationTypeNormal:
            {
                sessionModel.receiveDataType = JMReceiveDataTypeNormal;
            }
                break;
            case JMCommunicationTypeXMPP:
            {
                sessionModel.receiveDataType = JMReceiveDataTypeXMPP;
            }
                break;
            case JMCommunicationTypeMultipeerConnectivity:
            {
                sessionModel.receiveDataType = JMReceiveDataTypeMultipeerConnectivity;
            }
                break;
            case JMCommunicationTypeBlueToothPeripheral:
            {
                sessionModel.receiveDataType = JMReceiveDataTypeBlueToothPeripheral;
            }
                break;
            case JMCommunicationTypeBlueToothMainDesign:
            {
                sessionModel.receiveDataType = JMReceiveDataTypeBlueToothMainDesign;
            }
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kJMDraftMsgNotification object:sessionModel];
    }else{
        if (self.homeModel.draftModel.text.length) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kJMDeleteDraftMsgNotification object:self.homeModel];
        }
    }
}

- (void)setHomeModel:(JMHomeModel *)homeModel{
    _homeModel = homeModel;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (id)init {
    self = [super init];
    if (self) {
        _connectionProcess = [[JMChatConnectionProcess alloc] initWithViewController:self];
        [self addObservers];
     
    }
    return self;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageTableView.backgroundColor = JMCustomTableViewBackgroundColor;
    self.messageInputView.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotification:) name:kJMXMPPUserNotification object:nil];
    UIImage *image =[[[UIImage imageNamed:@"more"] jj_ratioScaleToSize:0.6] jj_imageWithTintColor:[UIColor colorWithHexString:kJMMainColorHexString]];
    [self setupRightItemWithImage:image];
    [JMReceiveMsgProcess setupTabbarBadgeWithUserID:self.homeModel.userID];
    [self.messageTableView reloadData];
    NSLog(@"===UUID:%@========",self.homeModel.userID);
//    [self scrollToBottomAnimated:NO];
    self.faceSourceManager = [[FaceSourceManager alloc] initWithInputView:self.messageInputView.inputTextView];
    [self.emotionManagerView loadFaceThemeItems:[self.faceSourceManager loadFaceSource]];
    self.messageInputView.inputTextView.XHDelegate = self;

     CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    self.title = self.homeModel.name;
    
    //第一次从数据库加载数据
    [self firstLoadDataFromSqlite];
    // 设置自身用户名
    self.messageSender = [JMMyInfo name];
//    [self setupShareMenu];
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"viewDidLoad Linked in %f ms", linkTime *1000.0);
   
   
}



- (void)setupShareMenu{
    GCDGlobalQueue((^{
        NSMutableArray *shareMenuItems = [NSMutableArray array];
        NSArray *plugIcons = @[@"icon_photo",@"icon_camera"];
        NSArray *plugTitle = @[@"照片",@"拍摄"];
        for (NSString *plugIcon in plugIcons) {
            XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
            [shareMenuItems addObject:shareMenuItem];
        }
        GCDMainQueue(^{
            self.shareMenuItems = shareMenuItems;
            [self.shareMenuView reloadData];
        });
    }));
}

- (void)rightBarButtonItemClick:(UIButton *)btn{
    
    JMBaseNavigationController *baseNav = (JMBaseNavigationController *)self.navigationController;
    JMChatCompanyInfoController *chatCompany = (JMChatCompanyInfoController *)[baseNav getControllerWithClass:JMChatCompanyInfoController.class];
    if (chatCompany) {
        [self.navigationController popToViewController:chatCompany animated:YES];
        return;
    }
    NSString *identifier = NSStringFromClass(JMChatCompanyInfoController.class);
    JMChatCompanyInfoController *infoController = VCFromSBWithIdentifier(identifier, identifier);
    infoController.model = self.homeModel;
    [self.navigationController pushViewController:infoController animated:YES];
}

- (void)userNotification:(NSNotification *)not{
    JMXMPPNotificationUserModel *model = not.object;
    switch (model.type) {
        case JMXMPPNotificationUserModelTypeRemove:
        {
            if ([model.jid.user isEqualToString:self.homeModel.jid.user]) {
                self.isFriend = NO;
            }
        }
            break;
        case JMXMPPNotificationUserModelTypeAdd:
        {
            if ([model.jid.user isEqualToString:self.homeModel.jid.user]) {
                self.isFriend = YES;
            }
        }
            break;
        case JMXMPPNotificationUserModelTypeUnavailable:
        {
            if ([model.jid.user isEqualToString:self.homeModel.jid.user]) {
                self.isAvailable = NO;
            }
        }
            break;
        case JMXMPPNotificationUserModelTypeAvailable:
        {
            if ([model.jid.user isEqualToString:self.homeModel.jid.user]) {
                self.isAvailable = YES;
            }
        }
            break;
            
        default:
            break;
    }
}


- (JMChatMsgProcess *)msgProcess{
    if (!_msgProcess) {
      _msgProcess = [[JMChatMsgProcess alloc] initWithViewController:self];
    }
    return _msgProcess;
}

- (JMChatReadMsgProcess *)readMsgProcess{
    if (!_readMsgProcess) {
        _readMsgProcess = [[JMChatReadMsgProcess alloc] initWithViewController:self];
    }
    return _readMsgProcess;
}

- (JMChatSelectedMsgProcess *)selectedMsgProcess{
    if (!_selectedMsgProcess) {
        _selectedMsgProcess = [[JMChatSelectedMsgProcess alloc] initWithViewController:self];
    }
    return _selectedMsgProcess;
}


- (void)addAndFinishSendMessage:(XHMessage *)message{
    
        [self finishSendMessageWithBubbleMessageType:message.messageMediaType];
     [self addMessage:message];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    [self.selectedMsgProcess multiMediaMessageDidSelectedOnMessage:message atIndexPath:indexPath onMessageTableViewCell:messageTableViewCell];
}
#pragma mark ===================头像点击事件=================
- (void)didSelectedAvatarOnMessage:(XHMessage *)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    [self.selectedMsgProcess didSelectedAvatarOnMessage:message atIndexPath:indexPath];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
 
    return !self.readMsgProcess.isReadComplete;
}


- (void)loadMoreMessagesScrollTotop {
   
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        GCDGlobalQueue(^{
            XHMessage *firstMessage = self.messages.firstObject;
            NSArray *messages = [self.readMsgProcess loadMoreMessage:firstMessage];
            if (messages.count) {
                    GCDAfterTime(0.5, ^{
                        [self.messages jj_insertArray:messages atIndex:0];
                        [self.messageTableView reloadData];
                        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0]
                                                     atScrollPosition:UITableViewScrollPositionTop
                                                             animated:NO];
                        self.loadingMoreMessage = NO;
                    });
            }
        })
    }
  
}

- (void)firstLoadDataFromSqlite{
    
    self.loadingMoreMessage = YES;
    //判断是否有草稿信息
    if (self.homeModel.draftModel.text.length) {
        //设置草稿信息
        self.messageInputView.inputTextView.text = self.homeModel.draftModel.text;
        //判断是否是从查询聊天记录时进入该页面，如果不是，就激活输入框
        if (!self.homeModel.isChatHistory) {
            [self.messageInputView.inputTextView becomeFirstResponder];
        }
        
    }
    GCDGlobalQueue(^{
        NSArray *messages = nil;
        if (self.homeModel.isChatHistory&&self.homeModel.message) {
             //查询聊天记录，进入该页面
            messages = [self.readMsgProcess loadDataFromSqliteChatHistory];
            GCDMainQueue(^{
                if (messages.count) {
                    [self.messages jj_insertArray:messages atIndex:0];
                    [self.messageTableView reloadData];
                    CGFloat contentOffsetY = 100;
                    CGFloat tableViewH = CGRectGetHeight(self.messageTableView.frame)/2.0;
                    CGFloat tableViewSizeHeight = self.messageTableView.size.height;
                    if (messages.count>kChatHistoryMsgLimitTop&&(tableViewSizeHeight-tableViewH)>=contentOffsetY) {
                        //要设置偏移量，不要拖动tableView时会触发下拉刷新
                        [self.messageTableView setContentOffset:CGPointMake(self.messageTableView.contentOffset.x, contentOffsetY) animated:NO];
                    }

                }
                self.loadingMoreMessage = NO;
            });
        }else{
            messages = [self.readMsgProcess loadDataFromSqlite];
            GCDMainQueue(^{
                if (messages.count) {
                    [self.messages jj_insertArray:messages atIndex:0];
                    [self.messageTableView reloadData];
                    [self scrollToBottomAnimated:NO];
                }
                self.loadingMoreMessage = NO;
            });
        }
       
    });
    
   
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    [self.msgProcess didSendText:text fromSender:sender onDate:date];
}
/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self.msgProcess didSendPhoto:photo fromSender:sender onDate:date];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self.msgProcess didSendVideoConverPhoto:videoConverPhoto videoPath:videoPath fromSender:sender onDate:date];
   
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self.msgProcess didSendVoice:voicePath voiceDuration:voiceDuration fromSender:sender onDate:date];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.messages.count) {
        return NO;
    }
    if (!indexPath.row) {
        //说明数据已经全部加载并且是第一条数据
        if (self.readMsgProcess.isReadComplete) {
            return YES;
        }
        return NO;
    }
    if (indexPath.row <= self.messages.count) {
        XHMessage *message1 = self.messages[indexPath.row-1];
        XHMessage *message2 = self.messages[indexPath.row];
        NSTimeInterval atimer = [message2.timestamp timeIntervalSinceDate:message1.timestamp];
        NSInteger second = (NSInteger)atimer;
        
        if (second >= 60) {
            return YES;
        }else{
            
            return NO;
        }
    }
    return NO;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

- (void)facePanelFacePicked:(FacePanel *)facePanel faceStyle:(FaceThemeStyle)themeStyle faceName:(NSString *)faceName isDeleteKey:(BOOL)deletekey{
    if (deletekey) {
        
        [self.faceSourceManager customDeleteText];
        
    }else{
        self.messageInputView.inputTextView.text = [self.messageInputView.inputTextView.text stringByAppendingString:faceName];
    }
}
#pragma mark ============键盘删除按钮事件＝＝＝＝＝＝＝＝＝＝＝
- (void)XHMessageTextViewDeleteBackward{
    [self.faceSourceManager textViewDeleteBackward];
}

//KVC添加观察者和移除观察者不能放在_connectionProcess对象操作，否则iOS11.0以下系统出现闪退
- (void)addObservers{
    [self addObserver:_connectionProcess forKeyPath:@"homeModel" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_connectionProcess forKeyPath:@"isAvailable" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_connectionProcess forKeyPath:@"isFriend" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)removeAllObservers{
    [self removeObserver:self.connectionProcess forKeyPath:@"homeModel"];
    [self removeObserver:self.connectionProcess forKeyPath:@"isAvailable"];
    [self removeObserver:self.connectionProcess forKeyPath:@"isFriend"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [self removeAllObservers];
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
