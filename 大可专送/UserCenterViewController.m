//
//  UserCenterViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "UserCenterViewController.h"
#import "manageAddressViewController.h"
#import "orderManageViewController.h"
#import "HTMLViewController.h"
#import "loginViewController.h"
#import "findPasswordViewController.h"
#import "YLButton.h"
#import "MBProgressHUD.h"
@interface UserCenterViewController()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation UserCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的";

    self.tableView.tableFooterView = [UIView new];

    if (APP_USERID) {
        _userNameLabel.text=[NSString stringWithFormat:@"账号%@",APP_NAME];
    }else{
        _userNameLabel.text=@"点击登录";
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 2:
        {
            NSArray *  textArr= @[@"我的地址",@"在线客服",@"修改密码"];
            cell.imageView.image = [UIImage imageNamed:textArr[indexPath.row]];
            cell.textLabel.text = textArr[indexPath.row];
        }
            break;
        case 3:
        {
            NSArray *  textArr= @[@"常见问题",@"使用须知",@"服务条款",@"关于我们"];
            cell.imageView.image = [UIImage imageNamed:textArr[indexPath.row]];
            cell.textLabel.text = textArr[indexPath.row];
        }
            break;
        case 4:
            cell.textLabel.text = @"退出登录";
            cell.imageView.image = [UIImage imageNamed:@"logout"];
        default:
            break;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 10;
    }
    return 0.0001;
}
-(void)login{
    if (APP_USERID) {
        return;
    }
    [self.navigationController pushViewController:[[loginViewController alloc]init] animated:YES];
}
- (IBAction)orderBtnClick:(UIButton *)sender {
    if (APP_USERID ==nil) {
        [self login];
        return;
    }
    orderManageViewController * vc=[[orderManageViewController alloc]init];
    vc.title=@"订单管理";
    vc.index=sender.tag;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if ([_userNameLabel.text isEqualToString:@"点击登录"]) {
                [self login];
            }
            break;
             case 2:
            switch (indexPath.row) {
                case 0:
                    if ([_userNameLabel.text isEqualToString:@"点击登录"]) {
                        [self login];
                    }else{
                        [self.navigationController pushViewController:[[manageAddressViewController alloc]init] animated:YES];
                    }
                    break;
                case 1:
                {
                    UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"拨号给客服" message:@"4001587110" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * aa=[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001587110"]];
                    }];
                    UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [ac addAction:aa];
                    [ac addAction:aa2];
                    [self presentViewController:ac animated:YES completion:nil];
                }
                    break;
                case 2:
                    if ([_userNameLabel.text isEqualToString:@"点击登录"]) {
                        [self login];
                    }else{
                        [self.navigationController pushViewController:[[findPasswordViewController alloc]init] animated:YES];
                    }
                    break;
            }
            break;
        case 3:
        {
            NSString * url = @"";
            switch (indexPath.row) {
                case 0:
                    url = APP_URL @"/aboutinfo.aspx?dataid=13";
                    break;
                case 1:
                    url = APP_URL @"/aboutinfo.aspx?dataid=16";
                    break;
                case 2:
                    url = APP_URL @"/aboutinfo.aspx?dataid=14";
                    break;
                case 3:
                    url = APP_URL @"/aboutinfo.aspx?dataid=17";
                    break;
                default:
                    break;
            }
            NSArray *  textArr= @[@"常见问题",@"使用须知",@"服务条款",@"关于我们"];
            HTMLViewController * vc = [[HTMLViewController alloc]initWithUrl:url];
            vc.title = textArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
            if ([_userNameLabel.text isEqualToString:@"点击登录"]) {
                [SVProgressHUD showErrorWithStatus:@"你还没有登录"];
            }else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"userId"];
                [defaults setObject:nil forKey:@"userName"];
                [SVProgressHUD showSuccessWithStatus:@"已退出登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
