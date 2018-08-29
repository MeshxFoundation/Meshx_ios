//
//  JMMyProfileController.m
//  MeshXIos
//
//  Created by xiaozhu on 2018/7/10.
//  Copyright © 2018年 xiaozhu. All rights reserved.
//

#import "JMMyProfileController.h"
#import "JMMyQRCodeController.h"
#import "JMMyProfileCell.h"
#import "JMMyProfileModel.h"



@interface JMMyProfileController ()
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) JMMyProfileModel *sexModel;

@end

@implementation JMMyProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [JMLanguageManager jm_languageMyProfile];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ClassStringFromClassName(JMMyProfileCell) bundle:nil] forCellReuseIdentifier:ClassStringFromClassName(JMMyProfileCell)];
}

- (NSArray *)dataArray{
    if (!_dataArray) {
      JMMyProfileModel *nameModel =  [[JMMyProfileModel alloc] initWithTitle:[JMLanguageManager jm_languageName] name:[JMMyInfo name]];
        JMMyProfileModel *QRModel = [[JMMyProfileModel alloc] initWithTitle:[JMLanguageManager jm_languageMyQRCode] icon:@"QR_icon"];
        NSString *sexName = [JMLanguageManager jm_languageFemale];
        NSString *sex = [JMMyInfo gender];
        if (sex.length>0) {
            
        }
        JMMyProfileModel *sexModel =  [[JMMyProfileModel alloc] initWithTitle:[JMLanguageManager jm_languageGender] name:sexName];
        self.sexModel = sexModel;
        _dataArray = @[nameModel,QRModel,sexModel];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMMyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassStringFromClassName(JMMyProfileCell) forIndexPath:indexPath];
     JMMyProfileModel *model = self.dataArray[indexPath.row];
    cell.jm_model = model;
  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JMMyProfileModel *model = self.dataArray[indexPath.row];
    //我的二维码
    if ([model.title isEqualToString:[JMLanguageManager jm_languageMyQRCode]]) {
        JMMyQRCodeController *myQRCode =  VCFromSBWithIdentifier(ClassStringFromClassName(JMMyQRCodeController), ClassStringFromClassName(JMMyQRCodeController));
        myQRCode.title = model.title;
        [self.navigationController pushViewController:myQRCode animated:YES];
    }else if ([model.title isEqualToString:[JMLanguageManager jm_languageGender]]){
        //性别
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [JMMyProfileCell jm_cellHeight];
}

- (void)selectGender:(NSString *)gender{
    self.sexModel.name = gender;
    [self.tableView reloadData];
    
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
