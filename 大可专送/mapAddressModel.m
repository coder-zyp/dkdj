//
//  mapAddressModel.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "mapAddressModel.h"

#import "mapViewTool.h"
@implementation mapAddressModel


+(mapAddressModel * )modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
       
        self.poiAddress=[dict objectForKey:@"poiAddress"];
        self.poiName=[dict objectForKey:@"poiName"];
        self.buildName=[dict objectForKey:@"detailAddress"];
        self.addressId=[dict objectForKey:@"aid"];
        self.location=[[AMapGeoPoint alloc]init];
        self.location.latitude=[[dict objectForKey:@"lat"] floatValue];;
        self.location.longitude=[[dict objectForKey:@"lng"] floatValue];
    }
    return self;
}
-(NSDictionary *)getDictByModel{
    return @{@"poiAddress":self.poiAddress?self.poiAddress:@"",
             @"poiName":self.poiName?self.poiName:@"",
             @"detailAddress":self.buildName?self.buildName:@"",
             @"lat":[NSString stringWithFormat:@"%f",self.location.latitude],
             @"lng":[NSString stringWithFormat:@"%f",self.location.longitude]
             };
}


+(mapAddressModel* )modelWithPOI:(AMapPOI *)POI{
    return [[self alloc]initWithPOI:POI];
}
-(instancetype)initWithPOI:(AMapPOI *)POI{
    if (self=[super init]) {
        self.poiAddress=POI.address;
        self.poiName=POI.name;
        self.location=POI.location;
        self.city=POI.city;
        self.distance=[NSString stringWithFormat:@"%ld",POI.distance] ;
        self.buildName=@"";
    }
    return self;
}
+(mapAddressModel* )modelWithTip:(AMapTip *)tip{
    return [[self alloc]initWithTip:tip];
}
-(instancetype)initWithTip:(AMapTip *)Tip{//搜索结果
    if (self=[super init]) {
        self.poiAddress=Tip.address;
        self.poiName=Tip.name;
        self.location=Tip.location;
        self.buildName=@"";
    }
    return self;
}
-(NSString *)lat{
    return [NSString stringWithFormat:@"%f",self.location.latitude];
}
-(NSString *)lng{
    return [NSString stringWithFormat:@"%f",self.location.longitude];
}
-(NSString *)buildName{
    if (_buildName==nil) {
        _buildName=@"";
    }
    return _buildName;
}
-(instancetype)initWithModle:(mapAddressModel *)model{
    if (self=[super init]) {
        self.poiAddress=model.poiAddress;
        self.poiName=model.poiName;
        self.city=model.city;
        self.buildName=model.buildName?model.buildName:@"";
        self.distance=model.distance;
        self.location=model.location;
        self.addressId=model.addressId;
        self.cityid=model.cityid;
    }
    return self;
}
-(void)saveToUserDefaults{
    
    if (self==nil &&self.poiName==nil) {
        return;
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[prefs objectForKey:@"historyAddressArray"] mutableCopy];
    if (arr==nil) {
        arr=[NSMutableArray array];
    }
    [arr addObject:[self getDictByModel]];
    NSLog(@"%@",arr);
    [prefs setObject:arr forKey:@"historyAddressArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
