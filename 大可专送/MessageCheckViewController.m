//
//  MessageCheckViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/28.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "MessageCheckViewController.h"
#import "TTPasswordView.h"
#import "JKCountDownButton.h"
#import "AppDelegate.h"
@interface MessageCheckViewController ()
@property(nonatomic,strong)TTPasswordView *password;
@property(nonatomic,strong)JKCountDownButton * countDownCode;
@end

@implementation MessageCheckViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton * backBtn=[UIButton buttonWithType:0];
    [backBtn addTarget: self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"取消叉号"] forState:0];
    [self.view addSubview:backBtn];
    backBtn.frame=CGRectMake(10, 25, 25, 25);
    
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
    label.text=@"输入验证码";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(30);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    self.password = [[TTPasswordView alloc] init];
    self.password.elementCount = 4;
    self.password.elementMargin=5;//空隙
    self.password.textField.font=[UIFont systemFontOfSize:24];
    [self.password setNoSecure];
    [self.view addSubview:self.password];
    [self.password makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50*4+15, 50));
    }];
    __block MessageCheckViewController *weakself=self;
    self.password.passwordBlock = ^(NSString *password) {
        if (password.length==4) {
            [weakself enterCode:password];
        }
    };
    
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_countDownCode];
    [_countDownCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.password.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
    }];

    NSMutableAttributedString * aStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"重新发送验证码到%@ 点击获取",_phone]];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, aStr.length-4)];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:APP_ORAGNE range:NSMakeRange(aStr.length-4, 4)];

    //字体
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, aStr.length)];

    [_countDownCode setTitle:[NSString stringWithFormat:@"已发送验证码到%@ 点击重新获取",_phone] forState:0];
//    _countDownCode.backgroundColor = [UIColor blueColor];
    [_countDownCode setTitleColor:[UIColor grayColor] forState:0];
    [_countDownCode.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        sender.enabled = NO;
        NSString * url=APP_URL @"getCode.aspx";
        //类型（0注册手机号 1找回密码/修改 2短信登录）
        [SVProgressHUD show];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:@{@"phone":_phone,@"type":@"2"} progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([[dic objectForKey:@"success"] boolValue]) {
                    _messageCode=[[dic objectForKey:@"data"] objectForKey:@"code"];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"errorMsg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
        [sender startCountDownWithSecond:60];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"发送验证码到%@ %zd秒",_phone,second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return [NSString stringWithFormat:@"重新发送验证码到%@ 点击获取",_phone];
            
        }];
        
    }];
    
//    [_countDownCode startCountDownWithSecond:60];
    
    // Do any additional setup after loading the view.
}

-(void)enterCode:(NSString *)code
{
    if ([self.messageCode isEqualToString:code]){
        NSString * url=APP_URL @"login.aspx";
        
        NSDictionary * param=@{
                               @"username":self.phone,
                               @"type":@"2",
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"errorMsg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证码有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
