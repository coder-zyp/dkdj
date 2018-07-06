//
//  mapViewTool.h
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "cityListModel.h"
#import "mapAddressModel.h"

@protocol MapToolDelegate <NSObject>

-(void)regionDidChange;
-(void)locationChangeResponse:(AMapReGeocodeSearchResponse *)response;
-(void)calculateRouteSuccessWithDistance:(NSString *)distance;

@end

@interface mapViewTool : NSObject

@property (nonatomic ,weak) MAMapView * mapView;
@property (nonatomic ,weak) id<MapToolDelegate> delegate;
@property (nonatomic ,strong) mapAddressModel * model;
@property (nonatomic ,strong) NSString *  deliverCount;
@property (nonatomic, strong) NSMutableArray * addressModelArr;
@property (nonatomic, strong) NSMutableArray <cityListModel *>* cityListModelArr;

@property (nonatomic, strong) AMapNaviRoute *naviRoute;

+ (mapViewTool *) sharedMapToolWithFrame:(CGRect) frame;
+ (mapViewTool *) shared;
-(void)getLocation;
-(void)setMapCenterWithLocation:(AMapGeoPoint *)location;
-(void)getNaviWithStartLocation:(AMapGeoPoint *)startLocation withEndLocation:(AMapGeoPoint *)endLocation;
-(void)getDeliveLocation;
@end
