//
//  shoplistVC.m
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "shoplistVC.h"
#import "shopmodel.h"
#import "shopCell.h"
#import "shopxiangqingVC.h"

@interface shoplistVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *shoparr;
    UITableView *selfTab;

}
@end

@implementation shoplistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商家列表";
    self.view.backgroundColor=[UIColor whiteColor];
    shoparr=[[NSMutableArray alloc]initWithCapacity:0];
    selfTab=[UITableView new];
    [self.view addSubview: selfTab];
    selfTab.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view,0);
    selfTab.backgroundColor=[UIColor whiteColor];
    selfTab.dataSource=self;
    selfTab.delegate=self;
    selfTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    selfTab.layer.cornerRadius=px_scale(30);
    [self getBtnClick];
    
    // Do any additional setup after loading the view.
}
-(void)getBtnClick{
    
    if (self.lat == nil) {
        [SVProgressHUD showErrorWithStatus:@"找不到坐标"];
        return;
    }
    NSString * url=@"http://www.gjqb110.com/App/Cpaotui/getShopFenleiShop.aspx";
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:@{@"fenleiid":_butmodel.butid,@"lat":_lat,@"lng":_lng} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"+++++++%@",dic);
            [shoparr removeAllObjects];
            if ([[dic objectForKey:@"state"] intValue]==1) {
                NSArray *arr=[dic objectForKey:@"data"];
                for ( NSDictionary *dic in arr) {
                    [shoparr addObject:[shopmodel mj_objectWithKeyValues:dic]];
                }
                [selfTab reloadData];
                if (shoparr.count==0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.bounds.size.width tableView:tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shoparr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    shopCell *cell1 = [[shopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    shopmodel *shopmo=shoparr[indexPath.row];
    [cell1.shopimg sd_setImageWithURL:[NSURL URLWithString:shopmo.imga] ];
    cell1.shopname.text=shopmo.name;
    cell1.shopphone.text=[NSString stringWithFormat:@"商家电话：%@",shopmo.phone];
    cell1.jingying.text=shopmo.xiangmu;
    cell1.juli.text = shopmo.juli;
    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    shopxiangqingVC *shopxqvc=[[shopxiangqingVC alloc]init];
    shopxqvc.shopmodel=shoparr[indexPath.row];
    [self.navigationController pushViewController:shopxqvc animated:YES];
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
