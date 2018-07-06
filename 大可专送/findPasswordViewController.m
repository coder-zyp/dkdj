//
//  findPasswordViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/28.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "findPasswordViewController.h"
#import "findNextViewController.h"
#import "UIView+Extension.h"

@interface findPasswordViewController ()
@property (nonatomic,strong) UITextField  * phoneTextField;
@end

@implementation findPasswordViewController
-(void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * backBtn=[UIButton buttonWithType:0];
    [backBtn addTarget: self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"取消叉号"] forState:0];
    [self.view addSubview:backBtn];
 CGFloat stateheight =CGRectGetHeight( [UIApplication sharedApplication].statusBarFrame);
    backBtn.frame=CGRectMake(10, stateheight, 25, 25);
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登陆图标"]];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel * label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:25];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"找回密码";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    _phoneTextField =[[UITextField alloc]init];
    _phoneTextField.placeholder=@"请输入手机号码";
    _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_phoneTextField];
    [_phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(40);
        make.left.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UIView * lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneTextField.mas_bottom).offset(18);
        make.left.mas_equalTo(80);
        make.height.mas_equalTo(0.5);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton * btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:0];
    [btn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    [btn.layer setCornerRadius:5];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}
-(void)nextBtnClick:(UIButton *)btn{
    
    if (![self checkMobilePhone:_phoneTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    findNextViewController * vc=[[findNextViewController alloc]init];
    vc.phone=self.phoneTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)checkMobilePhone:(NSString *)phone
{
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[0-9]|5[017-9]|8[0-9]|7[0-9])\\d|705)\\d{7}$";
    
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:phone] == YES)
        
        || ([regextestct evaluateWithObject:phone] == YES)
        
        || ([regextestcu evaluateWithObject:phone] == YES)
        
        || ([regextestphs evaluateWithObject:phone] == YES))
        
    {
        return YES;
    }else{
        return NO;
    }
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
