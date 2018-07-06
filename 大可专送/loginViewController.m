//
//  loginViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/28.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "loginViewController.h"
#import "MessageCheckViewController.h"
#import "findPasswordViewController.h"
#import "registerViewController.h"
#import "AppDelegate.h"
#import<CommonCrypto/CommonDigest.h>
@interface loginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton * messageBtn;
@property (nonatomic,strong) UIButton * passwordBtn;
@property (nonatomic,strong) UIButton * nextBtn;
@property (nonatomic,strong) UIButton * loginBtn;

@property (nonatomic,strong) UIView   * passwordView;
@property (nonatomic,strong) UITextField  * phoneTextField;
@property (nonatomic,strong) UITextField  * passwordTextField;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登陆图标"]];
    [self.view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(self.view);
    }];
    UIView * btnView=[[UIView alloc]init];
    [self.view addSubview:btnView];
    [btnView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.width.mas_equalTo(250);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    _messageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addSubview:_messageBtn];
    [_messageBtn setTitle:@"短信登陆" forState:0];
    [_messageBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_messageBtn setSelected:YES];
    [_messageBtn addTarget:self action:@selector(changeLoginWay:) forControlEvents:UIControlEventTouchUpInside];
    [_messageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.mas_equalTo(btnView);
        make.right.mas_equalTo(btnView.mas_centerX);
    }];
    
    _passwordBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addSubview:_passwordBtn];
    [_passwordBtn setTitle:@"密码登陆" forState:0];
    [_passwordBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    [_passwordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_passwordBtn addTarget:self action:@selector(changeLoginWay:) forControlEvents:UIControlEventTouchUpInside];
    [_passwordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.height.mas_equalTo(btnView);
        make.left.mas_equalTo(btnView.mas_centerX);
    }];
    
    _phoneTextField =[[UITextField alloc]init];
    _phoneTextField.placeholder=@"请输入手机号码";
    _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _phoneTextField.delegate=self;
    [self.view addSubview:_phoneTextField];
    [_phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(btnView);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UIView * lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(btnView);
        make.height.mas_equalTo(0.5);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton * btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:0];
    [btn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn=btn;
    [btn setBackgroundColor:APP_GARY];
    [btn.layer setCornerRadius:5];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(10);
        make.width.mas_equalTo(btnView);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _passwordView =[[UIView alloc]init];
    _passwordView.alpha=0;
    _passwordView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_passwordView];
    [_passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn);
        make.width.mas_equalTo(btnView);
        make.height.mas_equalTo(300);
        make.centerX.mas_equalTo(self.view);
    }];
    _passwordTextField =[[UITextField alloc]init];
    _passwordTextField.placeholder=@"请输入密码";
    _passwordTextField.secureTextEntry=YES;
    [_passwordView addSubview:_passwordTextField];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_passwordView);
        make.height.mas_equalTo(20);
    }];
    lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [_passwordView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordTextField.mas_bottom).offset(10);
        make.left.right.mas_equalTo(_passwordView);
        make.height.mas_equalTo(0.5);
    }];

    btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"登录" forState:0];
    _loginBtn=btn;
    [btn setBackgroundColor:APP_BLUE];
    [btn.layer setCornerRadius:5];
    [btn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_passwordView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(_passwordView);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *registerBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"注册账号" forState:0];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    [_passwordView addSubview:registerBtn];
    [registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(20);
        make.left.mas_equalTo(_passwordView);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    UIButton *forgetBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码" forState:0];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    [_passwordView addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(20);
        make.right.mas_equalTo(_passwordView);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    [self changeLoginWay:_messageBtn];
    
    [self.phoneTextField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];

}
-(void)loginBtnClick{
    if (![self checkMobilePhone:_phoneTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_passwordTextField.text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString * url=APP_URL @"login.aspx";
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * param=@{
                           @"username":_phoneTextField.text,
                           @"password":_passwordTextField.text,
                           @"type":@"1",
                           @"source":@"3",
                           @"token":APP_DELEGATA.token ? APP_DELEGATA.token :@"",
                           @"clientid":APP_DELEGATA.cid ? APP_DELEGATA.cid :@""
                           };

    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {

                NSString * userId=[[dic objectForKey:@"data"] objectForKey:@"userId"];
                NSString * userName=[[dic objectForKey:@"data"] objectForKey:@"userName"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:userId forKey:@"userId"];
                [defaults setObject:userName forKey:@"userName"];

//                NSLog(@"%@",APP_USERID);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}

-(void)changeLoginWay:(UIButton *)btn{
    [btn setSelected:YES];
    if (btn == _messageBtn) {
        _passwordView.alpha=0;
        [_passwordBtn setSelected:NO];
        [_passwordBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_messageBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    }else{
        _passwordView.alpha=1;
        [_messageBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_passwordBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [_messageBtn setSelected:NO];
    }
}
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
-(NSString *)getsign
{
    NSString *str;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYYMMdd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    str=[NSString stringWithFormat:@"%@|key=%@|yangjingfang",_phoneTextField.text,currentTimeString];
    NSString *result = [self md5:str];
    return result;
}
-(void)forgetBtnClick{
    [self.navigationController pushViewController:[[findPasswordViewController alloc]init] animated:YES];
}
-(void)registerBtnClick{
    [self.navigationController pushViewController:[[registerViewController alloc]init] animated:YES];
}
-(void)nextBtnClick:(UIButton *)btn{
    
    if (![self checkMobilePhone:_phoneTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString * url=APP_URL @"getCode.aspx";
    //类型（0注册手机号 1找回密码/修改 2短信登录）
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:@{@"phone":_phoneTextField.text,@"type":@"2",@"sign":[self getsign]} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                MessageCheckViewController * vc=[[MessageCheckViewController alloc]init];
                vc.messageCode=[[dic objectForKey:@"data"] objectForKey:@"code"];
                vc.phone=_phoneTextField.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//注意：事件类型是：`UIControlEventEditingChanged`
-(void)passConTextChange:(id)sender{
    UITextField* target=(UITextField*)sender;
    if (target.text.length==11) {
        [_nextBtn setBackgroundColor:APP_BLUE];
    }else{
        [_nextBtn setBackgroundColor:APP_GARY];
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location>=11) {
        return NO;
    }else{
        return YES;
    }
    
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
