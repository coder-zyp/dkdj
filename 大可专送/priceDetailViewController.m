//
//  priceDetailViewController.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "priceDetailViewController.h"
#import "HTMLViewController.h"
#import "mapViewTool.h"
#import "SelectableOverlay.h"
#import "mapViewTool.h"
@interface priceDetailViewController ()<MAMapViewDelegate>

@end

@implementation priceDetailViewController
-(void)sendFreeRule{
    NSString * url=[NSString stringWithFormat:@"%@aboutfee.aspx?cityid=%@",APP_URL,[mapViewTool shared].model.cityid];
    HTMLViewController * vc= [[HTMLViewController alloc]initWithUrl:url];
    vc.title=@"计价标准";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"价格明细";
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithTitle:@"计价标准" style:UIBarButtonItemStylePlain target:self action:@selector(sendFreeRule)];
    backBtn.tintColor=APP_ORAGNE;
    self.navigationItem.rightBarButtonItem = backBtn;
    
    UIView * lineHorizontal=[[UIView alloc]init];
    lineHorizontal.backgroundColor=APP_GARY;
    [self.view addSubview:lineHorizontal];
    [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineHorizontal.superview);
        make.left.mas_equalTo(lineHorizontal.superview).offset(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(lineHorizontal.superview).offset(64+50);
    }];
    
    UIView * lineVertical=[[UIView alloc]init];
    lineVertical.backgroundColor=APP_GARY;
    [self.view addSubview:lineVertical];
    [lineVertical makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineVertical.superview).offset(64);
        make.bottom.mas_equalTo(lineHorizontal);
        make.centerX.mas_equalTo(lineVertical.superview).offset(0);
        make.width.mas_equalTo(1);
    }];
    UILabel * label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.text=@"合计费用";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(lineVertical);
        make.height.mas_equalTo(25);
    }];
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.text=@"预计里程";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(lineVertical);
        make.height.mas_equalTo(25);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:14];
    label.text=[NSString stringWithFormat:@"￥%@",_model.totalfee];
    label.textColor=APP_ORAGNE;
    label.textAlignment=NSTextAlignmentCenter;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lineHorizontal.mas_top).offset(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(lineVertical.mas_left);
        make.height.mas_equalTo(25);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:14];
    label.text=[NSString stringWithFormat:@"%@公里",_model.alljuli];
    label.textAlignment=NSTextAlignmentCenter;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lineHorizontal.mas_top).offset(0);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(lineVertical.mas_right);
        make.height.mas_equalTo(25);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:14];
    label.text=@"实际费用可能因实际行驶里程等因素而异";
    label.textAlignment=NSTextAlignmentCenter;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineHorizontal).offset(0);
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    lineHorizontal=[[UIView alloc]init];
    lineHorizontal.backgroundColor=APP_GARY;
    [self.view addSubview:lineHorizontal];
    [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineHorizontal.superview);
        make.left.mas_equalTo(lineHorizontal.superview).offset(0);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(label.mas_bottom).offset(0);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"起步价(含3公里)";
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineHorizontal.mas_bottom).offset(0);
        make.right.mas_equalTo(self.view.centerX);
        make.left.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:15];
    label.text=[NSString stringWithFormat:@"%@元",_model.qibufee];
    label.textAlignment=NSTextAlignmentRight;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineHorizontal.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_centerX);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    lineHorizontal=[[UIView alloc]init];
    lineHorizontal.backgroundColor=APP_GARY;
    [self.view addSubview:lineHorizontal];
    [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineHorizontal.superview);
        make.left.mas_equalTo(lineHorizontal.superview).offset(0);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(label.mas_bottom).offset(0);
    }];
    
    label=[[UILabel alloc]init];
    [self.view addSubview:label];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    label.text=@"注：预估计价格根据以下路径进行计算";
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineHorizontal.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(40);
    }];
    if (_model.alljuli.floatValue>0) {
        MAMapView * mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 64+50+40+10+40+10+40, DEVICE_WIDTH, DEVICE_HEIGHT/2)];
        mapView.delegate=self;
        [self.view addSubview:mapView];
        mapView.showsScale=NO;
        mapView.rotateEnabled=NO;
        mapView.rotateCameraEnabled=NO;
        mapView.showsCompass=NO;
//        mapView.showsCompass
        [mapView removeOverlays:mapView.overlays];
        //将路径显示到地图上
        AMapNaviRoute *aRoute = [mapViewTool shared].naviRoute;
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        int i= count/2;
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake([coordinate latitude],[coordinate longitude])];
        [mapView setZoomLevel:16];
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        
        [mapView addOverlay:selectablePolyline];
        free(coords);
        
        //    更新CollectonView的信息
        NSLog(@"%@",[NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count]);
        
        [mapView showAnnotations:mapView.annotations animated:NO];
    }
    
    // Do any additional setup after loading the view.
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }
    
    return nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
