//
//  JMMineController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMineController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MXParallaxHeader.h"
#import "JMMineModel.h"
#import "JMMyProfileController.h"
#import "ToastTool.h"
#import "JJImagePicker.h"
#import "JMMineCell.h"
#import "AppDelegate.h"
#import "JMMyInfo.h"
#import "JMUserManager.h"
#import "JMLoginController.h"
#import "MCSessionProcess.h"
#import "JJPeripheralManager.h"
#import "EasyBlueToothManager.h"

@interface JMMineController ()<MXParallaxHeaderDelegate,XMPPvCardTempModuleDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeight;

@property (nonatomic ,strong) NSArray *dataArray;


@end

@implementation JMMineController

- (BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupvCard];
    // Do any additional setup after loading the view.
}
- (IBAction)editMyProfile:(id)sender {
    [self.navigationController pushViewController:[JMMyProfileController new] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupView{
    
    
    if (@available(iOS 11.0, *)) {
        
    }else{
       self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.frame = CGRectMake(0, -20, kScreenWidth, kScreenHeight-kTabbarHeight+20);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    //消除分组时，第一组系统默认的空白高度
    self.tableView.tableHeaderView = view;
    self.navigationBarHeight.constant = kNavHeight;
    self.titleLabel.text = [JMLanguageManager jm_languageMe];
    
    self.headBgView.backgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    self.tableView.parallaxHeader.view = self.headBgView;
    self.tableView.parallaxHeader.height = 164;
    self.tableView.parallaxHeader.mode = MXParallaxHeaderModeTopFill;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JMMineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JMMineCell class])];
    
    [self.editButton setBackgroundImage:[[UIImage imageNamed:@"edit_icon"] jj_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.nameLabel.text = [JMMyInfo name];
    [self setupHeaderImage];
    self.headImageView.userInteractionEnabled = YES;
    self.headBgView.backgroundColor = [[UIColor alloc] initWithRed:8/255.0 green:47/255.0 blue:63/255.0 alpha:1];
    self.tableView.backgroundColor = JMCustomTableViewBackgroundColor;
    self.tableView.rowHeight = 44;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHeadImage)];
    [self.headImageView addGestureRecognizer:tap];
    
}

- (NSArray *)dataArray{
    if (!_dataArray) {
//        _dataArray =@[@[[[JMMineModel alloc] initWithName:[JMLanguageManager jm_languageSettings] icon:@"setting_icon"]]];
        _dataArray =@[@[[[JMMineModel alloc] initWithName:[JMLanguageManager jm_languageLanguage] icon:@"language_icon"]],@[[[JMMineModel alloc] initWithName:[JMLanguageManager jm_languageAboutUs] icon:@"aboutus_icon"]],@[[[JMMineModel alloc] initWithName:[JMLanguageManager jm_languageSettings] icon:@"setting_icon"]],@[[[JMMineModel alloc] initWithName:[JMLanguageManager jm_languageLogOut] icon:@"logout_icon"]]];
    }
    return _dataArray;
}

- (void)selectHeadImage{
    
   JJImagePicker *picker = [JJImagePicker sharedInstance];
    picker.cancelText = [JMLanguageManager jm_languageCancel];
    picker.doneText = [JMLanguageManager jm_languageDone];
    picker.retakeText = [JMLanguageManager jm_languageRetake];
    picker.choosePhotoText = [JMLanguageManager jm_languageUsePhoto];
    picker.albumText = [JMLanguageManager jm_languagePhotos];
    picker.closeText = [JMLanguageManager jm_languageClose];
    picker.automaticText = [JMLanguageManager jm_languageAutomatic];
    picker.openText = [JMLanguageManager jm_languageOpen];
    [picker actionSheetWithTakePhotoTitle:[JMLanguageManager jm_languageTakePhoto] albumTitle:[JMLanguageManager jm_languageChooseFromAlbum] cancelTitle:[JMLanguageManager jm_languageCancel] InViewController:self didFinished:^(JJImagePicker *picker, UIImage *image) {
        XMPPvCardTemp *myCard = [JMMyInfo myCard];
        image = [image jj_scaleToSize:CGSizeMake(80, 80)];
        myCard.photo = [image jj_compressImageWithMaxLength:10000];
        [[JMXMPPTool sharedInstance].vCardTool updateMyCardWithResult:^(BOOL isSuccess, XMPPvCardTemp *myCard) {
            if (isSuccess) {
                [self setupHeaderImage];
            }else{
                JMShowToastWindow([JMLanguageManager jm_languageFail]);
            }
        }];
    }];
;
//    }];
}



- (void)setupvCard{
    [[JMXMPPTool sharedInstance].vCardTool.vCardModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    [[JMXMPPTool sharedInstance].vCardTool.vCardAvatar addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
}

- (void)changeLanguage{
    self.titleLabel.text = [JMLanguageManager jm_languageMe];
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark ============UITableViewDataSource=============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMMineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JMMineCell class]) forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
     JMMineModel *model = self.dataArray[indexPath.section][indexPath.row];
    cell.jm_model = model;
    return cell;
}

#pragma mark ==============UITableViewDelegate==========

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JMMineModel *model = self.dataArray[indexPath.section][indexPath.row];
    
    if ([model.name isEqualToString:[JMLanguageManager jm_languageLogOut]]){
        [self signOut];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

//获取名片失败
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToFetchvCardForJID:(XMPPJID *)jid error:(DDXMLElement *)error{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupHeaderImage{
    CGSize size = self.headImageView.frame.size;
    CGFloat radius = size.width/2.0;
    UIImage *image = [[JMMyInfo headerImage] jj_imageAddCornerWithRadius:radius size:size];
    self.headImageView.image = [image jj_circleRadius:radius borderWidth:3 borderColor:[UIColor whiteColor]];
    
}

- (void)signOut{
    
    if (!SIMULATOR) {
        
    }
    //删除用户名片
    [JMMyInfo deleteUserInfo];
    //清除XMPP数据
    [[JMXMPPTool sharedInstance] logout];
    //重新设置登录密码
    [JMUserManager addUserWithName:[JMUserManager getLastUserName] pwd:@""];
   
    UINavigationController *loginNavgation = VCFromSBWithIdentifier(@"Main", @"JMLoginNavigation");
    JMLoginController *loginController=loginNavgation.viewControllers.firstObject;
    loginController.type = JMLoginControllerTypeSignOut;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = loginNavgation;
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
