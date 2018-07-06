//
//  findNextViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/28.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "findNextViewController.h"

@interface findNextViewController ()
@property (nonatomic,weak) UIButton * msgBtn;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) int  time;
@property (nonatomic,strong) NSMutableArray <UITextField*>* textFieldArr;
@property (nonatomic,strong) NSString * msgStr;
@end

@implementation findNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel * label=[[UILabel alloc]init];
    label.text=@"设置密码前请完成验证，已发送短信验证码到";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor grayColor];
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    label=[[UILabel alloc]init];
    label.text=[NSString stringWithFormat:@"%@****%@",[self.phone substringToIndex:3],[self.phone substringFromIndex:7]];
    label.font=[UIFont boldSystemFontOfSize:30];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80+40);
        make.left.mas_equalTo(self.view).offset(20);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    // 创建一个装载九宫格的容器
    UIView *containerView = [[UIView alloc] init];

    [self.view addSubview:containerView];
    
    // 给该容器添加布局代码
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(45*4+10*3);
    }];
    NSArray * textArr=@[@"  请输入验证码",@"  新密码",@"  确认密码",];
    // 为该容器添加宫格View
    _textFieldArr=[NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UITextField * textField=[[UITextField alloc]init];
        textField.layer.masksToBounds=YES;
        textField.layer.borderWidth=1;
        textField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        textField.layer.cornerRadius=8;
        textField.placeholder=textArr[i];
        [_textFieldArr addObject:textField];
        if (i==0) {
            UIView * view=[[UIView alloc]init];
            [containerView addSubview:view];
            [view addSubview:textField];
            [textField makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 108));
            }];
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            _msgBtn=btn;
            btn.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
            btn.layer.cornerRadius=8;
            [btn setTitle:@"获取验证码" forState:0];
            [btn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [view addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.mas_equalTo(view);
                make.width.mas_equalTo(100);
            }];
        }else{
            textField.secureTextEntry=YES;
            [containerView addSubview:textField];
        }
    }
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:227.0/255.0 blue:187.0/255.0 alpha:1];
    btn.layer.cornerRadius=8;
    [btn addTarget:self action:@selector(findBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"修改并登陆" forState:0];
    [containerView addSubview:btn];

    // 执行九宫格布局
    [containerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    
    [containerView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView);
        make.centerX.mas_equalTo(containerView);
    }];
}
-(void)findBtnClick{
    NSString * url=APP_URL @"FindPassword.aspx";
    if (![_textFieldArr[0].text isEqualToString:_msgStr]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:@{@"username":self.phone,@"password":_textFieldArr[1].text,@"pwdagain":_textFieldArr[2].text,@"source":@"3",@"username":@"1",@"password":@"2"} progress:^(NSProgress * _Nonnull uploadProgress) {
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
    
    
    NSString * url=APP_URL @"getCode.aspx";
    //类型（0注册手机号 1找回密码/修改 2短信登录）
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:@{@"phone":self.phone,@"type":@"1"} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                _msgStr=[[dic objectForKey:@"data"] objectForKey:@"code"];
                _timer =[[NSTimer alloc]init];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
                _time=60;
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden=YES;
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
