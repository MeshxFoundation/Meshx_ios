//
//  JMRegisterController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/6/13.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMRegisterController.h"
#import "ToastTool.h"
@interface JMRegisterController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;

@end

@implementation JMRegisterController
- (IBAction)registerButtonClick:(id)sender {
    NSString *username = _userTextField.text;
    NSString *password = _passwordTextField.text;
    NSString *confirm = _confirmField.text;
    
    NSString *message = nil;
    if (username.length <= 0) {
        message = [JMLanguageManager jm_languageEnterUserName];
    } else if (password.length <= 0) {
        message = [JMLanguageManager jm_languageEnterPassword];
    } else if (confirm.length <= 0) {
        message = [JMLanguageManager jm_languageEnterPassword];
    }
    
    if (message.length > 0) {
        if (![password isEqualToString:confirm]) {
            message = [JMLanguageManager jm_languageInconsistentPassword];
        }
        JMShowToastWindow(message);
    } else {
        [JMProgressHUDTool show];
        [[JMXMPPTool sharedInstance] registWithUserName:username password:password result:^(BOOL isSuccess, XMPPElement *element, XMPPStream *sender) {
            if (!isSuccess) {
                [JMProgressHUDTool hidden];
                JMShowToastWindow([JMLanguageManager jm_languageNotConnectedServer]);
            }
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [JMLanguageManager jm_languageSignUp];
    self.cancelItem.title = [JMLanguageManager jm_languageCancel];
    [self.registerButton setTitle:[JMLanguageManager jm_languageSignUp] forState:UIControlStateNormal];
    self.confirmField.placeholder = [JMLanguageManager jm_languageEnterPassword];
    self.userTextField.placeholder = [JMLanguageManager jm_languageEnterUserName];
    self.passwordTextField.placeholder = [JMLanguageManager jm_languageEnterPassword];
    self.nameLabel.text = [JMLanguageManager jm_languageUserName];
    self.passwordLabel.text = [JMLanguageManager jm_languagePassword];
    self.confirmLabel.text = [JMLanguageManager jm_languageConfirmPassword];
    self.confirmLabel.adjustsFontSizeToFitWidth = YES;
    self.passwordLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    [[JMXMPPTool sharedInstance].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 4;
    self.registerButton.backgroundColor = [UIColor colorWithHexString:kJMMainColorHexString];
    
}
- (IBAction)passwordEyeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = sender.selected?YES:NO;
}
- (IBAction)confirmEyeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.confirmField.secureTextEntry = sender.selected?YES:NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClick:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"%s__%d__注册成功",__FUNCTION__,__LINE__);
    [self.view endEditing:YES];
    [JMProgressHUDTool hidden];
    JMShowToastWindow([JMLanguageManager jm_languageSuccess]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}
//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"%s__%d__注册失败%@",__FUNCTION__,__LINE__,error);
    
    [JMProgressHUDTool hidden];
    DDXMLElement *element = [error elementForName:@"error"];
    NSString *code = [[element attributeForName:@"code"] stringValue];
    NSInteger codeType = [code integerValue];
    if (codeType == 409) {
        NSLog(@"==注册失败，该用户已存在===");
        JMShowToastWindow([JMLanguageManager jm_languageRegistrationFailedUserAlreadyExists]);
    }else if (codeType == 408){
        NSLog(@"==注册超时===");
         JMShowToastWindow([JMLanguageManager jm_languageRegistrationTimeout]);
    }else{
        NSLog(@"==注册失败===");
        JMShowToastWindow([JMLanguageManager jm_languageRegistrationFailed]);
    }
}





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
