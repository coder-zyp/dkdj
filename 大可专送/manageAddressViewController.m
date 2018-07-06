//
//  manageAddressViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "manageAddressCell.h"
#import "manageAddressViewController.h"
#import "MJRefresh.h"
#import "mapAddressModel.h"
#import "MapDetailViewController.h"

@interface manageAddressViewController ()<manageAddressCellDelegat,UITableViewDelegate,UITableViewDataSource,MapDetailDelegate>

@property (nonatomic,strong) NSMutableArray <mapAddressModel*>* addressModelArr;
@property (nonatomic,weak) UITableView * tableView;
@end

@implementation manageAddressViewController
-(void)viewWillAppear:(BOOL)animated{

    [self.tableView.mj_header beginRefreshing];
}
-(void)manageAddressCellCollectBtnClickWithModel:(mapAddressModel *)model{
    NSDictionary * dic=@{@"userid":APP_USERID,
                         @"poiName":model.poiName,
                         @"poiAddress":model.poiAddress,
                         @"detailAddress":model.buildName,
                         @"lat":model.lat,
                         @"lng":model.lng,
                         };
    
    NSMutableDictionary * param=[NSMutableDictionary dictionaryWithDictionary:dic];
    [param setObject:model.addressId forKey:@"aid"];
    [param setObject:@"-1" forKey:@"op"];
    
    NSString * url=APP_URL @"AddMyaddress.aspx";
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                [self.addressModelArr removeObject:model];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
-(void)manageAddressCellEditBtnClickWithModel:(mapAddressModel *)model{
    
}
-(void)addAddressBtnClick{
    MapDetailViewController *vc=[[MapDetailViewController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)okBtnClickWith:(mapAddressModel *)model withBtnTag:(NSInteger)tag{
//
    NSDictionary * dic=@{@"userid":APP_USERID,
                         @"poiName":model.poiName,
                         @"poiAddress":model.poiAddress,
                         @"detailAddress":model.buildName,
                         @"lat":model.lat,
                         @"lng":model.lng,
                         };
    
    NSMutableDictionary * param=[NSMutableDictionary dictionaryWithDictionary:dic];
    [param setObject:@"1" forKey:@"op"];
    
    NSString * url=APP_URL @"AddMyaddress.aspx";
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                [self.addressModelArr addObject:model];
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
    self.title=@"我的地址";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithTitle:@"添加地址" style:UIBarButtonItemStylePlain target:self action:@selector(addAddressBtnClick)];
    backBtn.tintColor=APP_ORAGNE;
    self.navigationItem.rightBarButtonItem = backBtn;
    
    UIView * lineHorizontal=[[UIView alloc]init];
    lineHorizontal.backgroundColor=APP_GARY;
    [self.view addSubview:lineHorizontal];
    [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineHorizontal.superview);
        make.left.mas_equalTo(lineHorizontal.superview).offset(0);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(self.view).offset(0);
    }];
    
    UITableView * tableView=[[UITableView alloc]init];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self getAddressList];
    }];
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineHorizontal.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}
-(void)getAddressList{
    NSString * url=APP_URL @"GetAddresslist.aspx";
    NSDictionary * param=@{@"userid":APP_USERID};
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                self.addressModelArr=[NSMutableArray array];
                for (NSDictionary * dict in [dic objectForKey:@"datalist"]) {
                    [_addressModelArr addObject:[mapAddressModel modelWithDict:dict]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressModelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    manageAddressCell * cell =[manageAddressCell cellWithTableView:tableView];
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ((manageAddressCell *)cell).model=self.addressModelArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
