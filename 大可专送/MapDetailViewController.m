//
//  MapDetailViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "MapDetailViewController.h"
#import "mapViewTool.h"
#import <MAMapKit/MAMapKit.h>
#import "cityListViewController.h"
#import "addressCell.h"

@interface MapDetailViewController ()<MapToolDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,addressCellDelegat>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI  *search;
@property (nonatomic, strong) UILabel * poiLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UITextField * buildNameTextField;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * searchTableView;
@property (nonatomic, strong) NSMutableArray <UIButton *>* btnArr;

@property (nonatomic, strong) NSMutableArray <mapAddressModel *>*tips;
@property (nonatomic, weak)   UIView * searchView;
@property (nonatomic, strong) NSArray <mapAddressModel *>* tableArr;
@property (nonatomic, strong) NSMutableArray <mapAddressModel *>* addressModelArr;
@property (nonatomic, strong) NSMutableArray <mapAddressModel *>* collectArr;
@property (nonatomic, strong) NSMutableArray <mapAddressModel *>* historyArr;

@property (nonatomic, strong) mapAddressModel * selectAddressModel;

@end

@implementation MapDetailViewController

-(void)setTableArr:(NSArray<mapAddressModel *> *)tableArr{
    _tableArr=tableArr;
    [self.tableView reloadData];
}
-(void)changeCity{
    cityListViewController * vc=[[cityListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initInfoView];
    [self initAddressView];

    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithTitle:@"切换城市" style:UIBarButtonItemStylePlain target:self action:@selector(changeCity)];
    backBtn.tintColor=APP_ORAGNE;
    self.navigationItem.rightBarButtonItem = backBtn;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated ];
    NSLog(@"%@",[mapViewTool shared].model.city);
    self.addressModelArr=[mapViewTool shared].addressModelArr;
    [self initMapView];
    self.title=[mapViewTool shared].model.city;
    [self addressTypeBtn:_btnArr[0]];
}
-(void)initSearchView{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    view.backgroundColor=[UIColor whiteColor];
    _searchView=view;
    [self.view addSubview:view];
    
    UISearchBar * searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 6, DEVICE_WIDTH, 29)];
    [view addSubview:searchBar];
    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    searchBar.placeholder  = @"请输入位置";
    searchBar.delegate=self;
    searchBar.showsCancelButton=YES;
    for(id cc in [[[searchBar subviews]firstObject] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    _searchTableView=[[UITableView alloc]init];
    _searchTableView.delegate=self;
    _searchTableView.dataSource=self;
    _searchTableView.tag=1;
    [view addSubview:_searchTableView];
    [_searchTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom);
        make.bottom.left.right.mas_equalTo(view);
    }];
    [searchBar becomeFirstResponder];
}
-(void)searchBtnClick{
    [self initSearchView];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchView removeFromSuperview];
    _searchView=nil;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    tips.city     = [mapViewTool shared].model.city;
    tips.cityLimit = YES; //是否限制城市
    if (self.search==nil) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    [self.search AMapInputTipsSearch:tips];
}
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    self.tips=[NSMutableArray array];
    for (AMapTip * tip in response.tips) {
        mapAddressModel * model=[mapAddressModel modelWithTip:tip];
        [self.tips addObject:model];
    }
    [self.searchTableView reloadData];
}
-(void)initAddressView{
    UIView * btnView=[[UIView alloc]init];
    btnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnView];
    [btnView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_bottom).offset(-230);
        make.height.mas_equalTo(35);
    }];
    _btnArr=[NSMutableArray array];
    NSArray * textArr=@[@"附近的点",@"历史记录",@"收藏的点"];
    for (int i=0; i<3; i++) {
        UIView * view=[[UIView alloc]init];
//
        [btnView addSubview:view];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:textArr[i] forState:0];
        [btn setTitleColor:[UIColor grayColor] forState:0];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor colorWithRed:246.0/255.0 green:135.0/255.0 blue:36.0/255.0 alpha:1] forState:UIControlStateSelected];
        [view addSubview:btn];
        btn.tag=i;
        [_btnArr addObject:btn];
        [btn addTarget:self action:@selector(addressTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view);
            make.centerX.mas_equalTo(view);
            make.width.mas_equalTo(70);
        }];
    }
    [btnView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [btnView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(btnView);
    }];
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[UIColor lightGrayColor];
    [btnView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.mas_equalTo(btnView);
        make.height.mas_equalTo(0.6);
    }];
    
    _tableView=[[UITableView alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tag=0;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnView.mas_bottom);
        make.bottom.left.right.mas_equalTo(self.view);
    }];
    
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 4;
    [btn setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getMapLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(btnView.mas_top).offset(-20);
        make.left.mas_equalTo(self.view).offset(10);
    }];
    
}
-(void)getCollectAddress{
    if (APP_USERID==nil) {
        self.tableArr=nil;
        return;
    }
    
    NSString * url=APP_URL @"GetAddresslist.aspx";
    NSDictionary * param=@{@"userid":APP_USERID};
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[dic objectForKey:@"success"] boolValue]) {
                self.collectArr=[NSMutableArray array];
                for (NSDictionary * dict in [dic objectForKey:@"datalist"]) {
                    [_collectArr addObject:[mapAddressModel modelWithDict:dict]];
                }
                self.tableArr=self.collectArr;
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
-(void)clearhistoryBtnClick{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[prefs objectForKey:@"historyAddressArray"] mutableCopy];
    arr=[NSMutableArray array];
    [prefs setObject:arr forKey:@"historyAddressArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self addressTypeBtn:_btnArr[1]];
}
-(void)addressTypeBtn:(UIButton *)btn{
    for (UIButton * button in _btnArr) {
        if (button==btn) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }
    switch (btn.tag) {
        case 0:
            self.tableArr=self.addressModelArr;
            self.tableView.tableFooterView=nil;
            break;
        case 1:
        {
            self.tableView.tableFooterView=nil;
            self.tableArr=self.historyArr;
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"清空所有记录" forState:0];
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
            [btn addTarget:self action:@selector(clearhistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(0, 0, DEVICE_WIDTH, 40);
            self.tableView.tableFooterView=btn;
            btn.layer.borderWidth=0.5;
            btn.layer.borderColor=APP_GARY.CGColor;
        }
            break;
        case 2:
            self.tableView.tableFooterView=nil;
            [self getCollectAddress];
            break;
        default:
            break;
    }
}
-(NSMutableArray<mapAddressModel *> *)historyArr{
    _historyArr=[NSMutableArray array];
    for (NSDictionary * dic in APP_HIS_ADDS) {
        [_historyArr addObject:[mapAddressModel modelWithDict:dic]];
    }
    return _historyArr;
}
-(void)initInfoView{
    UIView * infoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 85)];
    infoView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:infoView];
    
    UILabel * label=[[UILabel alloc]init];
    label.text=@"[当前]";
    label.textColor=[UIColor colorWithRed:246.0/255.0 green:135.0/255.0 blue:36.0/255.0 alpha:1];
    label.font=[UIFont systemFontOfSize:16];
    [infoView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView);
        make.left.mas_equalTo(infoView).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    _poiLabel=[[UILabel alloc]init];
    _poiLabel.text=[mapViewTool shared].model.poiName;//poiName
    _poiLabel.font=[UIFont systemFontOfSize:16];
    [infoView addSubview:_poiLabel];
    [_poiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView);
        make.right.mas_equalTo(infoView).offset(-50);
        make.left.mas_equalTo(label.mas_right).offset(0);
        make.height.mas_equalTo(30);
    }];
   
    _addressLabel=[[UILabel alloc]init];
    NSArray * arr =[[mapViewTool shared].model.poiAddress componentsSeparatedByString:@"市"];
    _addressLabel.text=[arr lastObject];
    _addressLabel.font=[UIFont systemFontOfSize:14];
    _addressLabel.textColor=[UIColor lightGrayColor];
    [infoView addSubview:_addressLabel];
    [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_poiLabel.mas_bottom);
        make.left.mas_equalTo(infoView).offset(15);
        make.right.mas_equalTo(infoView).offset(-50);
        make.height.mas_equalTo(14);
    }];
    
    UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];

    [infoView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(25/2);
        make.right.mas_equalTo(infoView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[UIColor lightGrayColor];
    [infoView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(infoView).offset(8);
        make.right.mas_equalTo(infoView).offset(-8);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [infoView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(infoView);
        make.height.mas_equalTo(50);
    }];
    
    _buildNameTextField=[[UITextField alloc]init];
    _buildNameTextField.placeholder=@"楼层/门牌号";
    _buildNameTextField.text=[mapViewTool shared].model.buildName;
    [infoView addSubview:_buildNameTextField];
    [_buildNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(infoView).offset(15);
        make.right.mas_equalTo(infoView).offset(100);
        make.bottom.mas_equalTo(infoView);
        make.top.mas_equalTo(line.mas_bottom);
    }];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=APP_ORAGNE;
    btn.layer.cornerRadius=4;
    [btn addTarget:self action:@selector(addBuildName) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:0];
    [infoView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.mas_equalTo(infoView).offset(-8);
        make.bottom.mas_equalTo(infoView).offset(-3);
        make.top.mas_equalTo(line.mas_bottom).offset(3);
    }];
    
}
-(void)addBuildName{

    if (_buildNameTextField.text.length) {
        [mapViewTool shared].model.buildName=_buildNameTextField.text;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(okBtnClickWith:withBtnTag:)]) {
        [self.delegate okBtnClickWith:[mapViewTool shared].model withBtnTag:_pushBtnTag];
    }
    NSLog(@"!!!!!!!%@",[mapViewTool shared].model.cityid);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initMapView{
    mapViewTool * tool=[mapViewTool sharedMapToolWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    tool.delegate=self;
    self.mapView=tool.mapView;
    [self.view insertSubview:_mapView atIndex:0];
}
-(void)getMapLocation{
    [[mapViewTool shared] getLocation];
}
#pragma mark - 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag==0) {
        return _tableArr.count;
    }else{
        return _tips.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addressCell *cell = [addressCell cellWithTableView:tableView];
    cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        ((addressCell*)cell).model =_tableArr[indexPath.row];
    }else{
        ((addressCell*)cell).model =_tips[indexPath.row];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView) {
        NSLog(@"%@",_tableArr[indexPath.row].location);
        _selectAddressModel=_tableArr[indexPath.row];
        [[mapViewTool shared] setMapCenterWithLocation:_tableArr[indexPath.row].location];
    }else{
        
        [[mapViewTool shared] setMapCenterWithLocation:_tips[indexPath.row].location];
        [_searchView removeFromSuperview];
        _searchView=nil;
    }
}
-(void)regionDidChange{
    [SVProgressHUD show];
}

-(void)locationChangeResponse:(AMapReGeocodeSearchResponse *)response{

    [SVProgressHUD dismiss];
    if (_selectAddressModel) {
        [mapViewTool shared].model.poiName=_selectAddressModel.poiName;
        [mapViewTool shared].model.location=_selectAddressModel.location;
        [mapViewTool shared].model.poiAddress=_selectAddressModel.poiAddress;
        _selectAddressModel=nil;
    }
    self.title=[mapViewTool shared].model.city;
    _poiLabel.text=[mapViewTool shared].model.poiName;//.poiName
    NSArray * arr =[[mapViewTool shared].model.poiAddress componentsSeparatedByString:@"市"];
    _addressLabel.text=[arr lastObject];
    _addressModelArr=[mapViewTool shared].addressModelArr;
    if ([_btnArr[0] isSelected]) {
        self.tableArr=self.addressModelArr;
    }
}
-(void)collectBtnClickWithModel:(mapAddressModel *)model{

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
                [self getCollectAddress];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
