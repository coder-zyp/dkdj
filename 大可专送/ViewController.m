//
//  ViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/26.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "mapViewTool.h"
#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "BuyViewController.h"
#import "sendViewController.h"
#import "pickUpGoodsViewController.h"
#import "loginViewController.h"
#import "MapDetailViewController.h"
#import "UserCenterViewController.h"
#import "cityListViewController.h"
#import "RedPactPopView.h"


#import "aipaoView.h"
@interface ViewController ()<MapToolDelegate,HHDelegate>

@property (strong,nonatomic) aipaoView * locInfoView;

@property (strong,nonatomic) UILabel * cityLabel;
@property (strong,nonatomic) UILabel * locLabel;
@property (strong,nonatomic) UILabel * runingManCountLabel;
@property (strong,nonatomic) UILabel * refreshLabel;
@property (nonatomic, strong) UIView *mapView;

@property (nonatomic,assign)  BOOL  deliverCountIsAdd;
@end

@implementation ViewController
-(void)requestReadBag
{
    if (!APP_USERID) {
        return;
    }
    NSLog(@"请求红包接口");
    __weak ViewController *ws = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isshow"]) {
        return;
    }
    NSString * url=@"http://www.gjqb110.com/App/Android/gethongbao.aspx";
    [AFRequstManager getUrlStr:url andParms:@{@"uid":APP_USERID} andCompletion:^(id obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * jsonStr = [obj componentsSeparatedByString:@"<"].firstObject;
            NSLog(@"红包json%@",jsonStr);
            NSDictionary *dic = [NSDictionary jsonStrToDic:jsonStr];
            if ([dic[@"state"] intValue]!=0) {
                NSDictionary *msgDic = dic[@"data"][0];
                NSString *money = [NSString stringWithFormat:@"%@",msgDic[@"红包金额"]];
                NSString *dayCount = [NSString stringWithFormat:@"%@",msgDic[@"有效天数"]];
                RedPactPopView *popView =  [RedPactPopView redPactShow:money andTishiMsg:dayCount];
                popView.delegate = ws;
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:money forKey:@"money"];
                [defaults setObject:[NSString stringWithFormat:@"1"] forKey:@"isjiaoyi"];
                
                [defaults synchronize];
            }
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"isshow"];
        }
    }Error:^(NSError *errror) {
        
    }];

}
- (void)hHDelegate:(id)sender didSelectIndex:(NSInteger)index customString:(NSString *)customString
{
    BuyViewController * vc= [[BuyViewController alloc]init];
    vc.sendModel=[mapViewTool shared].model;
    NSLog(@"=-=-=-=----=-=%@",vc.sendModel);

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  life cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initLocationInfoView];
    [self initBtnView];
    self.navigationItem.title=@"国警骑兵";
    UINavigationBar * bar = self.navigationController.navigationBar;
    bar.barTintColor = WT_RGBColor(0x016bb7);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
}
-(void)userCenterBtnClick{
    UserCenterViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserCenterViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestReadBag];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated ];
    self.navigationController.navigationBar.hidden=NO;
    [self reloadInfoView];
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"首页-我的"] style:UIBarButtonItemStylePlain target:self action:@selector(userCenterBtnClick)];
    backBtn.tintColor=[UIColor grayColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    mapViewTool * tool=[mapViewTool sharedMapToolWithFrame:self.mapView.bounds];
    tool.delegate=self;
    [self.mapView addSubview:tool.mapView];
}
-(void)initBtnView{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView * btnView=[[UIView alloc]init];
    [self.view addSubview:btnView];
    [btnView makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(65*3+50*2);
    }];

    NSArray * imgNameArr=@[@"买东西",@"送东西",@"取东西"];
    for (int i=0; i<3;i++) {
        UIView * view=[[UIView alloc]init];
       
        [btnView addSubview:view];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:btn];
        btn.tag=i;
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:imgNameArr[i]] forState:0];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(15);
            make.left.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        UILabel * label=[[UILabel alloc]init];
        label.text=imgNameArr[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        [view addSubview:label];
        label.font=[UIFont systemFontOfSize:16];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(8);
            make.left.right.mas_equalTo(view);
            make.height.mas_equalTo(20);
        }];
    }
    [btnView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:50 leadSpacing:0 tailSpacing:0];
    
    [btnView.subviews makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView);
        make.bottom.equalTo(self.view);
    }];

}
-(void)changeCityBtnClick{
    cityListViewController *cityvc= [[cityListViewController alloc]init];
    [self.navigationController pushViewController:cityvc animated:YES];
}
-(void)bottomBtnClick:(UIButton *)btn{
    if (APP_USERID ==nil) {
        [self.navigationController pushViewController:[[loginViewController alloc]init] animated:YES];
        return;
    }
    if (btn.tag==0) {
        BuyViewController * vc= [[BuyViewController alloc]init];
        vc.sendModel=[mapViewTool shared].model;
           NSLog(@"=-=-=-=----=-=%@",vc.sendModel.cityid);
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==1) {
        sendViewController * vc= [[sendViewController alloc]init];
        vc.sendModel=[mapViewTool shared].model;
           NSLog(@"=-=-=-=----=-=%@",vc.sendModel.cityid);
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag==2) {
        pickUpGoodsViewController * vc= [[pickUpGoodsViewController alloc]init];
        vc.receiptModel=[mapViewTool shared].model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)initLocationInfoView{
    _locInfoView =[[aipaoView alloc]init];
    _locInfoView.hidden=YES;
    _locInfoView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_locInfoView];
    _locLabel.layer.cornerRadius=8;
    _locInfoView.layer.cornerRadius=8;

    [_locInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DEVICE_WIDTH-40);
        make.centerX.mas_equalTo(_mapView.mas_centerX);
        make.centerY.mas_equalTo(_mapView).offset(-58);
        make.height.mas_equalTo(58);
    }];
    
    
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    [_locInfoView addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 8, 0));
    }];
    
    _cityLabel =[[UILabel alloc]init];
    _cityLabel.font=[UIFont systemFontOfSize:14];
    _cityLabel.textColor=[UIColor whiteColor];
    _cityLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:_cityLabel];
    [_cityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(10);
        make.left.mas_equalTo(view).offset(2);
        make.size.mas_equalTo(CGSizeMake(50,14));
    }];
    
    UILabel * label=[[UILabel alloc]init];
    label.text=@"(切换)";
    label.font=[UIFont systemFontOfSize:11];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.top.equalTo(_cityLabel.mas_bottom).offset(3);
        make.left.right.equalTo(_cityLabel);
    }];
//
    UIView * line=[[UIView alloc]init];
    [view addSubview:line];
    line.backgroundColor=[UIColor whiteColor];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cityLabel.mas_right).offset(0);
        make.top.mas_equalTo(5);
        make.centerY.mas_equalTo(view);
        make.width.mas_equalTo(1);
    }];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(changeCityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(view);
        make.right.mas_equalTo(line);
    }];
    
    UIView * line2=[[UIView alloc]init];
    [view addSubview:line2];
    line2.backgroundColor=[UIColor whiteColor];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line);
        make.right.mas_equalTo(view).offset(-25);
        make.top.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(1);
    }];

    _locLabel =[[UILabel alloc]init];
    _locLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
    _locLabel.textColor=[UIColor colorWithRed:246.0/255.0 green:135.0/255.0 blue:36.0/255.0 alpha:1];
    [view addSubview:_locLabel];
    [_locLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line).offset(5);
        make.right.mas_equalTo(line2);
        make.top.mas_equalTo(view).offset(3);
        make.bottom.mas_equalTo(line2);
    }];
    
    
    _runingManCountLabel=[[UILabel alloc]init];
    _runingManCountLabel.font=[UIFont systemFontOfSize:12];
    _runingManCountLabel.textColor=[UIColor whiteColor];
     [view addSubview:_runingManCountLabel];
    [_runingManCountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line).offset(5);
        make.right.mas_equalTo(line2);
        make.bottom.mas_equalTo(view);
        make.top.mas_equalTo(line2);
    }];
    
    UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_home"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.right.mas_equalTo(view).offset(-1);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIButton * infoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:infoBtn];
    [infoBtn addTarget:self action:@selector(pushToMapDetailVC) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 60, 0, 0));
    }];
    
    _refreshLabel=[[UILabel alloc]init];
    _refreshLabel.text=@"正在获取当前位置";
    _refreshLabel.textColor=[UIColor lightGrayColor];
    _refreshLabel.textAlignment=NSTextAlignmentCenter;
    _refreshLabel.backgroundColor=[UIColor whiteColor];
    _refreshLabel.layer.masksToBounds=YES;
    _refreshLabel.layer.cornerRadius=8;
    
    [self.view addSubview:_refreshLabel];
    [_refreshLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_locInfoView);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
}
-(void)pushToMapDetailVC{
    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initMapView{
   
    self.mapView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    mapViewTool * tool=[mapViewTool sharedMapToolWithFrame:self.mapView.bounds];
    tool.delegate=self;
    [self.mapView addSubview:tool.mapView];
    [self.view addSubview:_mapView];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 4;
    [btn setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getMapLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(_mapView).offset(-130);
        make.left.mas_equalTo(_mapView).offset(10);
    }];

}
-(void)getMapLocation{
    [[mapViewTool shared] getLocation];
}
-(void)zhaoJiaBtnClick{
    ///////////////////////////////
    
    if (_deliverCountIsAdd==NO) {
        _deliverCountIsAdd=YES;
        NSInteger count =[mapViewTool shared].deliverCount.integerValue;
        [mapViewTool shared].deliverCount=[NSString stringWithFormat:@"%zd",count +1];
        _runingManCountLabel.text=[NSString stringWithFormat:@"有%@位骑士为您服务",[mapViewTool shared].deliverCount];
    }else{
        NSInteger count =[mapViewTool shared].deliverCount.integerValue;
        [mapViewTool shared].deliverCount=[NSString stringWithFormat:@"%zd",count -1];
        _runingManCountLabel.text=[NSString stringWithFormat:@"有%@位骑士为您服务",[mapViewTool shared].deliverCount];
        _deliverCountIsAdd=NO;
    }
    
}
#pragma mark - tool 代理
-(void)regionDidChange{
    _locInfoView.hidden=YES;
    _refreshLabel.hidden=NO;
    _refreshLabel.text=@"正在获取当前位置";
}

-(void)locationChangeResponse:(AMapReGeocodeSearchResponse *)response{
    [self reloadInfoView];
    _locInfoView.hidden=NO;
    _refreshLabel.hidden=YES;
}



-(void)reloadInfoView{
    NSString * str;
    NSString * location=[mapViewTool shared].model.poiName;
    int maxTextCount = iPhone4 ? 8 : iPhone5 ? 11 :iPhone6_6s ? 13 :iPhone6Plus_6sPlus ? 16: 17;
    if (location.length>=maxTextCount) {
        location=[NSString stringWithFormat:@"%@...",[location substringToIndex:maxTextCount]];
    }
    str=[NSString stringWithFormat:@"我从%@发货",location];
    
    
    NSMutableAttributedString * aStr=[[NSMutableAttributedString alloc]initWithString:str];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:APP_ORAGNE range:NSMakeRange(2, str.length-4)];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(str.length-2, 2)];
    
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 2)];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(2, aStr.length-4)];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str.length-2, 2)];
    
    _locLabel.attributedText=aStr;
    _cityLabel.text=[mapViewTool shared].model.city;
    
    if ([mapViewTool shared].deliverCount) {
        _runingManCountLabel.text=[NSString stringWithFormat:@"有%@位骑士为您服务",[mapViewTool shared].deliverCount];
    }else{
        _runingManCountLabel.text=@"有0位骑士为您服务";
    }
    
    
    CGFloat minWidth =[_runingManCountLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width+50+25+5;
    
    CGFloat locLabelWidth =[str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width+50+25;
    
    CGFloat width;
    if (minWidth>locLabelWidth) {
        width=minWidth;
    }else{
        width=locLabelWidth;
    }
    [_locInfoView updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
