//
//  orderInfoViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/8.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "payWindow.h"
#import "orderInfoViewController.h"
#import "MJRefresh.h"
#import "ZJScrollPageView.h"
@interface orderInfoViewController ()<ZJScrollPageViewChildVcDelegate>
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) NSMutableArray <UILabel *>* labelArr;
@property (nonatomic,weak) UIScrollView * scrollView;
@end

@implementation orderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIScrollView * scrollView= [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    self.scrollView=scrollView;
    scrollView.backgroundColor=APP_GARY;
    scrollView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString * url=APP_URL @"GetOrderInfoByOrderid.aspx";
        NSDictionary * param=@{@"dataid":_dataid};
        [SVProgressHUD show];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [scrollView.mj_header endRefreshing];
                NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([[dic objectForKey:@"success"] boolValue]) {
                    NSLog(@"%@",dic);
                    self.model=[orderDetailModel mj_objectWithKeyValues:[dic objectForKey:@"orderinfodata"]];
                    [self reloadInfoData];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"errorMsg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
        
    }];
    [self loadInfoView];
    [self.scrollView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)reloadInfoData{
    NSArray * textArr=@[[NSString stringWithFormat:@"%@",self.model.orderType],
                        [NSString stringWithFormat:@"%@",self.model.sendFee],//,
                        [NSString stringWithFormat:@"%@",self.model.orderid],
                        [NSString stringWithFormat:@"%@公里",self.model.juLi],//,
                        self.model.qAddress.length?self.model.qAddress :@"任意购买地址",//,
                        [NSString stringWithFormat:@"%@",self.model.sAddress],
                        [NSString stringWithFormat:@"%@",self.model.deliverName],//,
                        [NSString stringWithFormat:@"%@",self.model.remark],//,
                        self.model.payState.intValue?@"已支付":@"未支付"
                        ];
    _timeLabel.text=self.model.orderTime;
    for (int i=0; i<9; i++) {
        _labelArr[i].text=textArr[i];
        
        switch (i) {
            case 4:
                [_btnArr[0] setHidden:_model.qTell.length? NO:YES];
                break;
            case 5:
                [_btnArr[1] setHidden:_model.sTell.length? NO:YES];
                break;
            case 6:
                [_btnArr[2] setHidden:_model.deliverPhone.length? NO:YES];
                break;
            case 8:
                
                [_btnArr[4] setHidden:_model.payState.intValue ? YES :NO];
                break;
            default:
                break;
        }
    }
}
-(void)loadInfoView{
    
    NSArray * titleArr=@[@"订单类型：",@"配送费：",@"订单号：",@"距离：",@"取货信息：",@"送货信息：",@"骑士信息：",@"备注：",@"支付状态："];
    
    UIView *backView=[[UIView alloc]init];
    [self.scrollView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(45*titleArr.count +1*titleArr.count);
    }];
    
    _labelArr=[NSMutableArray array];
    _btnArr=[NSMutableArray array];
    for (int i=0; i<titleArr.count; i++) {
        UIView * view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [backView addSubview:view];
        
        UILabel * label=[[UILabel alloc]init];
        [view addSubview:label];
        label.text=titleArr[i];
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.mas_equalTo(view);
            make.width.mas_equalTo(75);
        }];
        
        label=[[UILabel alloc]init];
        [view addSubview:label];
        label.numberOfLines=0;
        label.textColor=[UIColor lightGrayColor];
        label.font=[UIFont systemFontOfSize:14];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(90);
            make.right.mas_equalTo(view).offset(-50);
            make.top.bottom.mas_equalTo(view);
        }];
        [_labelArr addObject:label];
        if (i==0) {
            _timeLabel=[[UILabel alloc]init];
            _timeLabel.textColor=[UIColor lightGrayColor];
            _timeLabel.font=[UIFont systemFontOfSize:14];
            _timeLabel.textAlignment=NSTextAlignmentRight;
            [view addSubview:_timeLabel];
            [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(view);
                make.right.mas_equalTo(view).offset(-15);
                make.width.mas_equalTo(150);
            }];
        }
        if (i>=4) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_btnArr addObject:btn];
            [btn setHidden:YES];
            [view addSubview:btn];
            if (i<7){
                [btn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag =i;
                [btn setImage:[UIImage imageNamed:@"订单详情_phone"] forState:0];
                [btn makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(view).offset(10);
                    make.right.mas_equalTo(view).offset(-17);
                    make.size.mas_equalTo(CGSizeMake(21, 21));
                }];
            }
            if (i==8) {
                [btn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag =i;
                [btn setTitle:@"去支付" forState:0];
                btn.layer.cornerRadius=6;
                btn.layer.borderWidth=0.5;
                btn.layer.borderColor=APP_ORAGNE.CGColor;
                [btn setTitleColor:APP_ORAGNE forState:0];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [btn makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(view).offset(-10);
                    make.centerY.mas_equalTo(view);
                    make.size.mas_equalTo(CGSizeMake(60, 35));
                }];
            }
        }
        
        
    }
    [backView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:45 leadSpacing:0 tailSpacing:0];
    [backView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backView);
    }];
    
    
}
-(void)payBtnClick:(UIButton *)btn{
    payWindow *window = [payWindow shareShowWindow];
    window.param=@{@"totalfee":self.model.totalPrice,
                   @"orderid":self.model.orderid
                   };
    [window show];
}
-(void)phoneBtnClick:(UIButton *)btn{
    NSString * title;
    NSString * phone;
    
    switch (btn.tag) {
        case 4:
            title=@"拨号给取货人";
            phone=self.model.qTell;
            break;
        case 5:
            title=@"拨号给送货人";
            phone=self.model.sTell;
            break;
        case 6:
            phone=self.model.deliverPhone;
            title=@"拨号给骑士";
            break;
        default:
            break;
    }
    UIAlertController * ac=[UIAlertController alertControllerWithTitle:title message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa=[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }];
    UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:aa];
    [ac addAction:aa2];
    [self presentViewController:ac animated:YES completion:nil];
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
