//
//  orderStateViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/8.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "orderStateViewController.h"
#import "ZJScrollPageView.h"
#import "oderStateView.h"
#import "MJRefresh.h"
#import "orderDetailModel.h"
@interface orderStateViewController ()<ZJScrollPageViewChildVcDelegate>
@property (nonatomic, assign) NSInteger showStateCount;
@property (nonatomic,strong) NSMutableArray * viewArr;
@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) NSMutableArray <UILabel*>* stateLabelArr;
@property (nonatomic,strong) NSMutableArray <UILabel*>* timeLabelArr;

@end

@implementation orderStateViewController
-(NSString *)getTimeWithDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSDate *date1 = [formatter dateFromString:dateStr1];
    NSDate *date2 = [formatter dateFromString:dateStr2];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitMinute;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    NSInteger sec = [d minute];
    return [NSString stringWithFormat:@"%zd",sec];
}

-(void)reloadViewData{
    _showStateCount=1;
    
    if ([self.model.payState isEqualToString: @"1"]) {
        _showStateCount +=2;
    }
    if (self.model.sendState.integerValue ==1 ||self.model.sendState.integerValue ==2) {
        _showStateCount +=2;
    }else if ([self.model.sendState isEqualToString: @"3"]) {
        _showStateCount +=3;
    }
    NSArray *labelTextArr=@[@"订单提交成功",
                            @"订单已支付",
                            self.model.isShopSet.intValue==2?@"订单已取消":_showStateCount==3?@"等待骑士接单":@"等待接单用时",
                            @"骑士已接单",
                            _showStateCount==5?@"骑士配送中":@"骑士配送用时",
                            @"骑士配送完成"];
    
    NSString * waitTime=[NSString stringWithFormat:@"%@分钟",[self getTimeWithDateStr1:_model.orderTime dateStr2:_model.DeliverQiangDate]];
    NSString * sendTime=[NSString stringWithFormat:@"%@分钟",[self getTimeWithDateStr1:_model.DeliverQiangDate dateStr2:_model.sLngDeliverWanDate]];
    NSArray * timeArr=@[_model.orderTime ?_model.orderTime :@"",//订单提交成功
            @"",//订单已支付"
            _model.sendState.integerValue>=1 ? waitTime:@"",//等待骑士接单",
            _model.DeliverQiangDate ,//骑士已接单",
            _showStateCount==6?sendTime:@"",//骑士配送中"
            _model.sLngDeliverWanDate?_model.sLngDeliverWanDate :@""];//骑士配送完成"];
    
    
    for (int i=0; i<6;i++) {
        _stateLabelArr[i].text=labelTextArr[i];
        [_timeLabelArr[i] setText:timeArr[i]];
        if (i<_showStateCount) {
            [_viewArr[i] setHidden:NO];
        }else{
            [_viewArr[i] setHidden:YES];
        }
        if (i==_showStateCount-1) {
            [_btnArr[i] setSelected:YES];
        }else{
             [_btnArr[i] setSelected:NO];
        }
        if (self.model.orderStatus.intValue==4&&self.model.isShopSet.intValue==2) {
            [_btnArr[i] setImage:[UIImage imageNamed:@"订单详情_已取消"] forState:UIControlStateSelected];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIScrollView * scrollView= [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
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
                    self.model=[orderDetailModel mj_objectWithKeyValues:[dic objectForKey:@"orderinfodata"]];
                    [self reloadViewData];
                    
                    NSLog(@"%@",_model.sendState);
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
    
    
    UIView *backView=[[UIView alloc]init];
    [scrollView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView).offset(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(60*6 + 6*15);
    }];
    self.viewArr=[NSMutableArray array];
    self.btnArr=[NSMutableArray array];
    self.timeLabelArr=[NSMutableArray array];
    self.stateLabelArr=[NSMutableArray array];
    
    
    for (int i=0; i<6; i++) {
        UIView * view=[[UIView alloc]init];
        [backView addSubview:view];
        view.hidden=YES;
        NSString * imgName=[NSString stringWithFormat:@"订单详情_%d",i];
        NSString * imgSelectName=[imgName stringByAppendingString:@"s"];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag =i;
        [btn setImage:[UIImage imageNamed:imgName] forState:0];
        [btn setImage:[UIImage imageNamed:imgSelectName] forState:UIControlStateSelected];
        [view addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(35/2);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        oderStateView * qipaoView=[[oderStateView alloc]init];
        qipaoView.backgroundColor=[UIColor clearColor];
        [view addSubview:qipaoView];
        
        [qipaoView makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view).offset(0);
            make.left.mas_equalTo(view).offset(56-8);
            make.right.mas_equalTo(view).offset(-15);
        }];
        UILabel * label=[[UILabel alloc]init];
        
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:14];
        [qipaoView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(qipaoView);
            make.left.mas_equalTo(9+15);
        }];
        [self.stateLabelArr addObject:label];
        
        
        label=[[UILabel alloc]init];
        label.textAlignment=NSTextAlignmentRight;
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:14];
        [qipaoView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(qipaoView);
            make.right.mas_equalTo(-10);
        }];
        
        [self.viewArr addObject:view];
        [self.btnArr addObject:btn];
        [self.timeLabelArr addObject:label];
    }
    
    [backView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:56 leadSpacing:0 tailSpacing:0];
    [backView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backView);
    }];
    
    [scrollView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
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
