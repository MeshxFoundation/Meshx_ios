//
//  JMLoginController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMLoginController.h"
#import "ToastTool.h"
#import "AppDelegate.h"
#import "JMUserManager.h"
#import "JMMyInfo.h"
#import "BGFMDB.h"

@interface JMLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation JMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isEnterRootViewController]) {
        return;
    }
   
    [[JMXMPPTool sharedInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self setupView];
}



- (BOOL)isEnterRootViewController{
    
    switch (self.type) {
        case JMLoginControllerTypeNormal:
        {
            return [self isEnterTabBarController];
          
        }
            break;
        case JMLoginControllerTypeSignOut:
        {
            self.userTextField.text = [JMUserManager getLastUserName];
            self.passwordTextField.text = [JMUserManager getPasswordWithUserName:[JMUserManager getLastUserName]];
            return NO;
        }
            break;
        case JMLoginControllerTypeChangUser:
        {
            
        }
            break;
            
        default:
            break;
    }
    return NO;
}

- (BOOL)isEnterTabBarController{
    NSString *userName = [JMUserManager getLastUserName];
    if (userName.length) {
        self.userTextField.text = userName;
        NSString *password = [JMUserManager getPasswordWithUserName:userName];
        if (password.length) {
            [[JMXMPPTool sharedInstance] loginWithUserName:userName password:password result:nil];
            //进入首页
            [self enterTabBarControllerWithUserName:userName];
            return YES;
        }else{
            self.passwordTextField.text = @"";
        }
    }else{
        return NO;
    }
    return NO;
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [JMProgressHUDTool hidden];
    //保存用户名和密码
    [JMUserManager addUserWithName:_userTextField.text pwd:_passwordTextField.text];
    [self enterTabBarControllerWithUserName:[JMMyInfo name]];
}


//验证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    [JMProgressHUDTool hidden];
    JMShowToast([JMLanguageManager jm_languageLoginFailed]);
}


- (void)enterTabBarControllerWithUserName:(NSString *)userName{
    bg_closeDB();
    bg_setDebug(NO);
    bg_setDisableCloseDB(YES);
    bg_setSqliteName(userName);
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate enterTabBarController];
}

- (void)setupView{
    
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    self.LoginButton.layer.masksToBounds = YES;
    self.LoginButton.layer.cornerRadius = 5;
    self.LoginButton.backgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    [self.forgetPasswordButton setTitleColor:[UIColor colorWithHexString:kJMMainColorHexString] forState:UIControlStateNormal];
     [self.forgetPasswordButton setTitleColor:[UIColor colorWithHexString:kJMMainColorHexString] forState:UIControlStateHighlighted];
     [self.registerButton setTitleColor:[UIColor colorWithHexString:kJMMainColorHexString] forState:UIControlStateNormal];
     [self.forgetPasswordButton setTitleColor:[UIColor colorWithHexString:kJMMainColorHexString] forState:UIControlStateHighlighted];
    self.title = [JMLanguageManager jm_languageUserLogin];
    self.userTextField.placeholder = [JMLanguageManager jm_languageEnterUserName];
    self.passwordTextField.placeholder = [JMLanguageManager jm_languageEnterPassword];
    self.nameLabel.text = [JMLanguageManager jm_languageUserName];
    self.passwordLabel.text = [JMLanguageManager jm_languagePassword];
    [self.LoginButton setTitle:[JMLanguageManager jm_languageUserLogin] forState:UIControlStateNormal];
    [self.registerButton setTitle:[JMLanguageManager jm_languageSignUp] forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:[JMLanguageManager jm_languageForgetPassword] forState:UIControlStateNormal];
    
}
- (IBAction)eyeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = sender.selected?NO:YES;
}

- (IBAction)LoginButtonClick:(id)sender {
    
    NSString *username = _userTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *message = nil;
    if (username.length <= 0) {
        message = [JMLanguageManager jm_languageEnterUserName];
    } else if (password.length <= 0) {
        message = [JMLanguageManager jm_languageEnterPassword];
    }
    
    if (message.length > 0) {
        JMShowToast(message);
    } else {
        [JMProgressHUDTool show];
        [[JMXMPPTool sharedInstance] loginWithUserName:username password:password result:^(BOOL isSuccess, XMPPElement *element, XMPPStream *sender) {
            if (!isSuccess) {
                [JMProgressHUDTool hidden];
                JMShowToast([JMLanguageManager jm_languageNotConnectedServer]);
            }
        }];
    }
    
}
- (IBAction)forgetPasswordButtonClick:(id)sender {
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


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
