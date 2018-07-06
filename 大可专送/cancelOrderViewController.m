//
//  cancelOrderViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/3.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "cancelOrderViewController.h"
#import "UITextView+YLTextView.h"
@interface cancelOrderViewController ()

@property (nonatomic,strong) NSArray * labelTextArr;
@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) UITextView *textView;
@end

@implementation cancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"取消订单";
    self.view.backgroundColor=APP_GARY;
    
    UILabel * label=[[UILabel alloc]init];
    label.text=@"不发件了，告诉我们原因吧";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.view).offset(64);
        make.height.mas_equalTo(35);
    }];
    
    UIView * backView=[[UIView alloc]init];
    [self.view addSubview:backView];
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(45*4+3);
        
        
    }];
    self.btnArr=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"取消勾选框"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"勾选框"] forState:0];
        btn.tag=i;
        [view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.btnArr addObject:btn];
        UILabel * label=[[UILabel alloc]init];
        label.text=self.labelTextArr[i];
        label.font=[UIFont systemFontOfSize:14];
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view);
            make.left.mas_equalTo(btn.mas_right).offset(10);
            make.right.mas_equalTo(view).offset(-10);
        }];
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:view];
    }
    
    [backView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [backView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).offset(0);
    }];
    [self btnClick:_btnArr[0]];
    
    UITextView *textView=[[UITextView alloc]init];
    textView.placeholder=@"有什么需要补充吗？(选填)";
    textView.backgroundColor=[UIColor whiteColor];
    textView.font=[UIFont systemFontOfSize:14];
//    textView.textVerticalAlignment=YYTextVerticalAlignmentCenter;
//    textView.verticalForm=YES;
    [self.view addSubview:textView];
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(85);
    }];
    
    label=[[UILabel alloc]init];
    label.text=@"取消订单后，预计3-5个工作日到账";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(textView.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.tag=0;
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"暂不取消" forState:0];
    btn.backgroundColor=[UIColor whiteColor];
    btn.layer.cornerRadius=6;
    [btn setTitleColor:[UIColor lightGrayColor] forState:0];
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn2];
    btn2.tag=1;
    [btn2 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"取消订单" forState:0];
    btn2.backgroundColor=[UIColor whiteColor];
    btn2.layer.cornerRadius=6;
    [btn2 setTitleColor:APP_ORAGNE forState:0];
    
    NSArray * arr=@[btn,btn2];
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [arr makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];
    // Do any additional setup after loading the view.
}
-(void)btnClick:(UIButton *)btn{
    for (int i=0; i<_btnArr.count; i++) {
        if (i==btn.tag) {
            [_btnArr[i] setSelected:YES];
        }else{
            [_btnArr[i] setSelected:NO];
        }
    }
}
-(void)bottomBtnClick:(UIButton *)btn{
    if (btn.tag==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSString * remark;
        for (int i=0; i<_btnArr.count; i++) {
            if ([_btnArr[i] isSelected]) {
                remark=self.labelTextArr[i];
            }
        }
        remark =[NSString stringWithFormat:@"%@:%@",remark,self.textView.text];
        NSString * url=APP_URL @"CancelOrder.aspx";
        NSDictionary * param=@{@"orderid":_orderid,@"remark":remark};
        [SVProgressHUD show];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([[dic objectForKey:@"success"] boolValue]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"errorMsg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSArray *)labelTextArr{
    if (!_labelTextArr) {
        _labelTextArr=@[@"其他原因",@"跑男要求取消订单",@"信息填写错误",@"取货时间过长"];
    }
    return _labelTextArr;
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
