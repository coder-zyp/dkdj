//
//  registerViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/28.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "registerViewController.h"
#import "AppDelegate.h"
#import<CommonCrypto/CommonDigest.h>

@interface registerViewController ()
@property (nonatomic,weak) UIButton * msgBtn;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) int  time;
@property (nonatomic,strong) NSMutableArray <UITextField*>* textFieldArr;
@property (nonatomic,strong) NSString * msgStr;
@end

@implementation registerViewController
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
    CGFloat stateHeight =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    backBtn.frame=CGRectMake(10, stateHeight, 25, 25);
    
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
    label.text=@"账号注册";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    // 创建一个装载九宫格的容器
    UIView *containerView = [[UIView alloc] init];
    [self.view addSubview:containerView];
    
    // 给该容器添加布局代码
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40*4);
    }];
    // 为该容器添加宫格View
    NSArray * textArr=@[@"请输入手机号",@"请输入验证码",@"请输入密码",@"确认密码"];
    UIView *view;
    _textFieldArr=[NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        view=[[UIView alloc]init];
        [containerView addSubview:view];
        
        UITextField * textField= [[UITextField alloc]init];
        [view addSubview:textField];
        textField.placeholder=textArr[i];
        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        if (i<2) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else{
            textField.secureTextEntry=YES;
        }
        [_textFieldArr addObject:textField];
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor lightGrayColor];
        [view addSubview: line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
    }
    // 执行九宫格布局
    [containerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [containerView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView);
        make.centerX.equalTo(containerView);
    }];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitle:@"获取验证码" forState:0];
    [btn addTarget: self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(5);
        make.right.equalTo(containerView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    _msgBtn=btn;
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn setTitle:@"注册" forState:0];
    [btn addTarget: self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:5];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_bottom).offset(20);
        make.right.left.mas_equalTo(containerView);
        make.height.mas_equalTo(40);
    }];
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
    str=[NSString stringWithFormat:@"%@|key=%@|yangjingfang",_textFieldArr[0].text,currentTimeString];
    NSString *result = [self md5:str];
    return result;
}
-(void) registerBtnClick:(UIButton *)btn{
    NSString * url=APP_URL @"register.aspx";
    if (![_textFieldArr[1].text isEqualToString:_msgStr]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_textFieldArr[2].text isEqualToString:_textFieldArr[3].text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"两次密码不一致" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary * param=@{
                           @"username":_textFieldArr[0].text,
                           @"password":_textFieldArr[2].text,
                           @"source":@"3",
                           @"token":APP_DELEGATA.token ? APP_DELEGATA.token :@"",
                           @"clientid":APP_DELEGATA.cid ? APP_DELEGATA.cid :@""
                           };
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];

}
-(void) timerFired:(id)senser
{

    _time--;
    [_msgBtn setTitle:[NSString stringWithFormat:@"%d s", _time] forState:UIControlStateNormal];
    
    if (_time == 0) {
        [_msgBtn setTitle:@" 获取验证码" forState:UIControlStateNormal];
        //取消定时器
        [_timer invalidate];
        _timer = nil;
        [_msgBtn setEnabled:YES];
    }
}
-(void)messageBtnClick{
    [_msgBtn setEnabled:NO];
    _timer =[[NSTimer alloc]init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    _time=60;
    
    if (![self checkMobilePhone:_textFieldArr[0].text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString * url=APP_URL @"getCode.aspx";
    //类型（0注册手机号 1找回密码/修改 2短信登录）
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:@{@"phone":_textFieldArr[0].text,@"type":@"0",@"sign":[self getsign]} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                _msgStr=[[dic objectForKey:@"data"] objectForKey:@"code"];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 [self.view endEditing:YES];
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
