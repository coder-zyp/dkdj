//
//  shopxiangqingVC.m
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "shopxiangqingVC.h"
#import "SDCycleScrollView.h"
#import "BuyViewController.h"
#import "sendViewController.h"
#import "pickUpGoodsViewController.h"
#import "xiatuVC.h"
#import "mapViewTool.h"

@interface shopxiangqingVC ()

@end

@implementation shopxiangqingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_shopmodel.name;
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray *imgarr=[[NSArray alloc]initWithObjects:_shopmodel.imga,_shopmodel.imgb,_shopmodel.imgc,_shopmodel.imgd ,_shopmodel.imge,nil];
    SDCycleScrollView *cycview=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width/5.0*3) imageNamesGroup:imgarr];
    cycview.currentPageDotColor=WT_RGBColor(0x000000);
    cycview.pageDotColor=WT_RGBColor(0xffffff);
    [self.view addSubview: cycview];
    
    UIImageView *locimg=[UIImageView new];
    [self.view addSubview: locimg];
    locimg.image=[UIImage imageNamed:@"address_normal"];
    locimg.contentMode=UIViewContentModeScaleAspectFill;
    locimg.sd_layout
    .leftSpaceToView(self.view,px_scale(40))
    .topSpaceToView(cycview,px_scale(30))
    .heightIs(px_scale(40))
    .widthIs(px_scale(35));
    
    UILabel *addresslab=[UILabel new];
    [self.view addSubview: addresslab];
    addresslab.sd_layout
    .leftSpaceToView(locimg,px_scale(20))
    .heightIs(px_scale(40))
    .widthIs(px_scale(300))
    .centerYEqualToView(locimg);
    addresslab.text=_shopmodel.address;
    addresslab.font=[UIFont systemFontOfSize:px_scale(24)];
    
    UIButton *phonebut=[UIButton new];
    [self.view addSubview: phonebut];
    [phonebut setBackgroundImage:[UIImage imageNamed:@"订单详情_phone"] forState:0];
    phonebut.sd_layout
    .rightSpaceToView(self.view,px_scale(30))
    .centerYEqualToView(addresslab)
    .widthIs(px_scale(45))
    .heightIs(px_scale(45));
    [phonebut addTarget: self action:@selector(phoneclick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *xmimg=[UIImageView new];
    [self.view addSubview: xmimg];
    xmimg.image=[UIImage imageNamed:@"服务条款"];
    xmimg.contentMode=UIViewContentModeScaleAspectFill;
    xmimg.sd_layout
    .leftSpaceToView(self.view,px_scale(40))
    .topSpaceToView(addresslab,px_scale(30))
    .heightIs(px_scale(40))
    .widthIs(px_scale(35));
    
    UILabel *xmlab=[UILabel new];
    [self.view addSubview: xmlab];
    xmlab.sd_layout
    .leftSpaceToView(xmimg,px_scale(20))
    .heightIs(px_scale(40))
    .widthIs(px_scale(300))
    .centerYEqualToView(xmimg);
    xmlab.text=_shopmodel.xiangmu;
    xmlab.font=[UIFont systemFontOfSize:px_scale(24)];
    
    UILabel *showlab=[UILabel new];
    [self.view addSubview: showlab];
    showlab.sd_layout
    .leftEqualToView(xmimg)
    .heightIs(px_scale(40))
    .widthIs(px_scale(160))
    .topSpaceToView(xmimg,px_scale(30));
    showlab.text=@"商家收款码：";
    showlab.font=[UIFont systemFontOfSize:px_scale(24)];
    
    UIButton *shoubut=[UIButton new];
    [self.view addSubview: shoubut];
    NSURL *url = [NSURL URLWithString:_shopmodel.ewmMoney];
    shoubut.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [shoubut setBackgroundImage: [UIImage imageWithData: [NSData dataWithContentsOfURL:url]] forState:0];
    shoubut.sd_layout
    .leftSpaceToView(showlab,0)
    .widthIs(px_scale(130))
    .heightIs(px_scale(130))
    .topEqualToView(showlab);
    [shoubut addTarget: self action:@selector(showclick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tishilab=[UILabel new];
    tishilab.numberOfLines=0;
    [self.view addSubview: tishilab];
    
    tishilab.text=@"点击二维码，将收款二维码保存到本地，使用微信/支付宝扫一扫，选择上一步保存好的二维码图片即可";
    tishilab.textAlignment=1;
    tishilab.font=[UIFont systemFontOfSize:px_scale(24)];

    tishilab.sd_layout
    .leftSpaceToView(self.view ,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(shoubut,0)
    .heightIs(px_scale(60));
    
    UIButton *zhaobut=[UIButton new];
    [zhaobut setTitle:@"召唤附近骑兵" forState:0];
    [self.view addSubview: zhaobut];
    zhaobut.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(px_scale(120))
    .bottomSpaceToView(self.view,0);
    zhaobut.titleLabel.font=[UIFont systemFontOfSize:12];
    [zhaobut setBackgroundColor:WT_RGBColor(0x016bb7)];
    [zhaobut setTitleColor:[UIColor whiteColor] forState:0];
    [zhaobut addTarget: self action:@selector(zhaoclick) forControlEvents:UIControlEventTouchUpInside];

    
    // Do any additional setup after loading the view.
}
-(void)showclick
{
    NSURL *url = [NSURL URLWithString:_shopmodel.ewmMoney];
    UIImage *img= [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    if (img) {
        xiatuVC *xiavc=[[xiatuVC alloc]init];
        xiavc.image=img;
        [self.navigationController pushViewController:xiavc animated:YES];
    }
}
-(void)zhaoclick
{
    
    mapAddressModel * addressModel = [mapAddressModel new];
    addressModel.poiName = _shopmodel.name;
    addressModel.buildName = _shopmodel.address;
    addressModel.location = [AMapGeoPoint locationWithLatitude:_shopmodel.lat.floatValue longitude:_shopmodel.lng.floatValue];
    addressModel.lat = _shopmodel.lat;
    addressModel.lng = _shopmodel.lng;
    UIViewController *  vc =[self.navigationController viewControllers][1];
    
    if ([vc isKindOfClass:[BuyViewController class]]) {
        ((BuyViewController *)vc).buyModel = addressModel;
    }else if([vc isKindOfClass:[sendViewController class]]){
        ((sendViewController *)vc).receiptModel = addressModel;
    }else{
        ((pickUpGoodsViewController *)vc).pickUpModel = addressModel;
    }

    [self.navigationController popToViewController:vc animated:YES];
}
-(void)phoneclick
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",_shopmodel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
   
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
