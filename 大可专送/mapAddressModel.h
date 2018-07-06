//
//  mapAddressModel.h
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface mapAddressModel : NSObject


@property (nonatomic,strong) NSString * poiName;

@property (nonatomic,strong) NSString * poiAddress;

@property (nonatomic,strong) NSString * distance;

@property (nonatomic,strong) AMapGeoPoint *location;

@property (nonatomic ,strong) NSString * city;

@property (nonatomic ,strong) NSString * cityid;

@property (nonatomic, strong) NSString * buildName;

@property (nonatomic, strong) NSString * addressId;

@property (nonatomic, strong) NSString * lat;

@property (nonatomic, strong) NSString * lng;
-(void)saveToUserDefaults;
-(instancetype)initWithModle:(mapAddressModel *)model;
+(mapAddressModel* )modelWithPOI:(AMapPOI *)POI;
+(mapAddressModel* )modelWithTip:(AMapTip *)tip;
+(mapAddressModel * )modelWithDict:(NSDictionary *)dict;
@end
