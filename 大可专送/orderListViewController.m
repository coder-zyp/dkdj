//
//  orderListViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "MJRefresh.h"
#import "orderModel.h"
#import "orderCell.h"
#import "orderListViewController.h"
#import "ZJScrollPageView.h"
#import "payWindow.h"
#import "cancelOrderViewController.h"
#import "orderDetailViewController.h"
@interface orderListViewController ()<ZJScrollPageViewChildVcDelegate,UITableViewDelegate,UITableViewDataSource,orderCellDelegat>
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <orderModel *>* orderModelArr;
@property (nonatomic,strong) NSString * indexPath;
@property (nonatomic,assign) int total;
@end

@implementation orderListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _indexPath=@"1";
//    _orderModelArr=[NSMutableArray array];
    [self.tableView.mj_header beginRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
-(void)getOrderList{
    
    NSString * orderstatus;
    if (_index<3) {
        orderstatus=[NSString stringWithFormat:@"%zd",_index];
    }else if(_index==3){
        orderstatus=@"6";
    }else{
        orderstatus=[NSString stringWithFormat:@"%zd",_index-1];
    }
    NSString * url=APP_URL @"GetOrderlistByUserid.aspx";
    NSDictionary * param=@{@"userid":APP_USERID,
                           @"orderstatus":orderstatus,
                           @"pageindex":self.indexPath,
                           @"pagesize":@"8"};
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if ([self.tableView.mj_header isRefreshing]) {
                _orderModelArr=[NSMutableArray array];
                [self.tableView.mj_header endRefreshing];
            }
            
            [self.tableView.mj_footer endRefreshing];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"success"] boolValue]) {
                
                _indexPath=[[dic objectForKey:@"orderdata"] objectForKey:@"page"];
                _total =[[[dic objectForKey:@"orderdata"] objectForKey:@"total"] intValue];
                NSArray * arr=[[dic objectForKey:@"orderdata"] objectForKey:@"orderlist"];
                for (NSDictionary *dict in arr) {
                    orderModel * model=[orderModel mj_objectWithKeyValues:dict];
                    [self.orderModelArr addObject:model];
                }
                
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=APP_GARY;
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@10);
    }];
    
    UITableView * tableView=[[UITableView alloc]init];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.backgroundColor=APP_GARY;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.mj_header=[MJRefreshHeader headerWithRefreshingBlock:^{
        _orderModelArr=[NSMutableArray array];
        _indexPath=@"1";
        [self getOrderList];
    }];


    tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.indexPath.intValue<self.total ) {
            _indexPath=[NSString stringWithFormat:@"%d",_indexPath.intValue+ 1];
            [self getOrderList];
        }else{
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 0, 0, 0));
    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderModelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    orderCell * cell=[orderCell cellWithTableView:tableView];
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ((orderCell *)cell).model=_orderModelArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //未支付orderStatus=2 paystate=0
    //待接单：orderStatus=7 sendstate=0
    if (_orderModelArr.count<1) {
        return 0;
    }
    if ((_orderModelArr[indexPath.row].orderStatus.intValue==2 &&_orderModelArr[indexPath.row].payState.intValue==0)||(_orderModelArr[indexPath.row].orderStatus.intValue==7 &&_orderModelArr[indexPath.row].sendState.intValue==0)) {
        return 40+80+40+10;
    }else{
        return 40+80+10;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    orderDetailViewController * vc=[[orderDetailViewController alloc]init];
    vc.orderid=_orderModelArr[indexPath.row].dataid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)orderCellBottomBtnClickWithModel:(orderModel *)model{
 
    
    if (model.payState.intValue==0) {
        payWindow *window = [payWindow shareShowWindow];
        window.param=@{@"totalfee":model.TotalPrice,
                       @"orderid":model.orderid
                       };
        [window show];
    }else{
        cancelOrderViewController * vc=[[cancelOrderViewController alloc]init];
        vc.orderid=model.orderid;
        [self.navigationController pushViewController:vc animated:YES];

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
