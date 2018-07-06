//
//  mapViewTool.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//


#import "mapViewTool.h"
#import "SelectableOverlay.h"

@interface mapViewTool ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
@property (strong,nonatomic) AMapLocationManager * locationManager;
@property (nonatomic, strong) AMapNaviWalkManager *walkManager;


@end

@implementation mapViewTool

static MAMapView * mapView = nil;
static UIImageView * _locationIcon=nil;
static  mapViewTool * tool  = nil;
+ (mapViewTool *) sharedMapToolWithFrame:(CGRect) frame
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[mapViewTool allocWithZone:nil] initWithFrame:frame];
    });
    mapView.frame=frame;
    return tool;
}
+ (mapViewTool *) shared{
 
    return tool;
}
//3.重写allocWithZone:方法，保证该类型只有一个对象
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [super allocWithZone:nil];
    });
    return tool;
}
- (instancetype)initWithFrame:(CGRect) frame
{
    self = [super init];
    if (self) {
        @synchronized(self) {
            
            if (mapView == nil) {
                [self getCityList];
                [AMapServices sharedServices].apiKey = @"a4aecb0f785e42f77c1bd082b5b16e10";
                mapView = [[MAMapView alloc] initWithFrame:frame];
                
                mapView.zoomLevel=15.5;
                mapView.showsCompass=NO;//罗盘
                mapView.showsScale=NO;//比例尺
                mapView.delegate=self;
                mapView.skyModelEnable=NO;
                mapView.rotateCameraEnabled=NO;
                mapView.rotateEnabled=NO;
                
                
                _locationIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位"]];
                [mapView addSubview:_locationIcon];
                [_locationIcon makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(mapView).offset(-12);
                    make.centerX.mas_equalTo(mapView);
                    make.size.mas_equalTo(CGSizeMake(20, 24));
                }];
                [self getLocation];
                
                
//                NSLog(@"zzzzzzzzz%@",[AMapServices sharedServices].apiKey);
            }
        }
    }
    return self;
}
//获取开通城市
-(void)getCityList{
    if (_cityListModelArr==nil) {
        NSString * url=APP_URL @"GetCityList.aspx";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([[dic objectForKey:@"success"] boolValue]) {
                    _cityListModelArr=[NSMutableArray array];
                    for (NSDictionary * dict in [dic objectForKey:@"citydata"]) {
                        [_cityListModelArr addObject:[cityListModel mj_objectWithKeyValues:dict]];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
                }
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
}

-(void)getDeliveLocation{
    NSString * url=APP_URL @"Getdeliverlatlng.aspx";
    if (!self.model.cityid) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"=-=-=-=-=-%@",self.model.cityid);
    [manager POST:url parameters:@{@"cityid":self.model.cityid} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[dic objectForKey:@"success"] boolValue]) {
            NSArray * arr= [dic objectForKey:@"deliverdata"];
            self.deliverCount=[NSString stringWithFormat:@"%d",(int)arr.count];
            
            [self.mapView removeAnnotations:self.mapView.annotations];
            for (NSDictionary * dict in arr) {
                [self addAnnotationWithCooordinate:CLLocationCoordinate2DMake([[dict objectForKey:@"glat"] floatValue], [[dict objectForKey:@"glng"]floatValue])];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(locationChangeResponse:)]) {
                [self.delegate locationChangeResponse:nil];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"errorMsg"]];
        }
      
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
    
    
}
-(MAMapView *)mapView{
    if (_mapView==nil) {
        self.mapView=mapView;
    }
    return _mapView;
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    [UIView animateWithDuration:0.15 animations:^{
        _locationIcon.transform=CGAffineTransformMakeTranslation(0, -15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _locationIcon.transform=CGAffineTransformMakeTranslation(0, 0);
        } ];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(regionDidChange)]) {
        [self.delegate regionDidChange];
    }
    [self searchReGeocodeWithCoordinate:_mapView.region.center];
}
#pragma mark - 地图拖拽
-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}
-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

}
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    if (!self.search) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil )
    {
        self.addressModelArr=[NSMutableArray array];

        AMapAOI * aoi=[response.regeocode.aois firstObject];
        if (aoi) {
            
            mapAddressModel * model=[[mapAddressModel alloc]init];
            model.poiName=aoi.name;
            model.poiAddress=[NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.building];
            model.location=aoi.location;
            model.buildName=@"";
            for (cityListModel * cityModel in self.cityListModelArr) {
                if ([model.city isEqualToString:cityModel.cname]) {
                    model.cityid=cityModel.cid;
                }
            }
            [_addressModelArr addObject:model];
            
            self.model=model;
        }else{
            AMapPOI * poi = [response.regeocode.pois firstObject];

            if (poi) {
                self.model=[mapAddressModel modelWithPOI:poi];
            }else{
                self.model.poiName=@"没有位置信息，尝试其他结果";
            }
        }
        int i=0;
        for (AMapPOI * poi in response.regeocode.pois) {
            mapAddressModel * model=[mapAddressModel modelWithPOI:poi];
            for (cityListModel * cityModel in self.cityListModelArr) {
                if ([model.city isEqualToString:cityModel.cname]) {
                    model.cityid=cityModel.cid;
                }
            }

            [_addressModelArr addObject:model];
            i++;
        }
//        NSLog(@"%@",response.regeocode.addressComponent.citycode);
        self.model.city=response.regeocode.addressComponent.city;
//        NSLog(@"%@",self.cityListModelArr);
        
        for (cityListModel * model in self.cityListModelArr) {
            
            if ([self.model.city containsString:model.cname] || [model.cname isEqualToString:self.model.city]) {
                self.model.cityid=model.cid;
            }
        }
        if (self.deliverCount==nil) {
            [self getDeliveLocation];
        }
        if (self.model.poiAddress.length) {
            self.model.poiAddress=response.regeocode.formattedAddress;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationChangeResponse:)]) {
            [self.delegate locationChangeResponse:response];
        }
    }
}
-(mapAddressModel *)model{
    if (_model==nil) {
        _model=[[mapAddressModel alloc]init];
    }
    return _model;
}
//定位
-(void)getLocation{
    mapView.delegate=self;
    if (!self.locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@", location);
        [_mapView setCenterCoordinate:location.coordinate];
        if (regeocode)
        {
            
        }
    }];
}
//导航
-(void)getNaviWithStartLocation:(AMapGeoPoint *)startLocation withEndLocation:(AMapGeoPoint *)endLocation{
    AMapNaviPoint *startPoint=[AMapNaviPoint locationWithLatitude:startLocation.latitude longitude:startLocation.longitude];
    
    AMapNaviPoint * endPoint=[AMapNaviPoint locationWithLatitude:endLocation.latitude longitude:endLocation.longitude];
    if (self.walkManager == nil)
    {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
    }
    [self.walkManager calculateWalkRouteWithStartPoints:@[startPoint]
                                              endPoints:@[endPoint]];
    NSLog(@"%@%@%@",self.walkManager.delegate,startPoint,endPoint);
}
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    if (self.walkManager.naviRoute == nil){
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(calculateRouteSuccessWithDistance:)]) {
        [self.delegate calculateRouteSuccessWithDistance:[NSString stringWithFormat:@"%f",self.walkManager.naviRoute.routeLength/1000.f]];
    }
    self.naviRoute= self.walkManager.naviRoute;
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.image=[UIImage imageNamed:@"电动车"];
        }
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    
}
-(void)setMapCenterWithLocation:(AMapGeoPoint *)location{
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
}
@end
