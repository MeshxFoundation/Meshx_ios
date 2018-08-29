//
//  JMBaseTableViewController.m
//  JMSmartMesh
//
//  Created by JMZiXun on 2018/5/11.
//  Copyright © 2018年 JMZiXun. All rights reserved.
//

#import "JMBaseTableViewController.h"

@interface JMBaseTableViewController ()

@end

@implementation JMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.tableView.tableFooterView) {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
   
}

- (void)setupRightItemWithImage:(UIImage *)image{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}


- (void)rightBarButtonItemClick:(UIButton *)btn{
    
}

- (void)changeLanguage{
    
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
