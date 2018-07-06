//
//  GoodModel.m
//  大可专送
//
//  Created by Amitabha on 2018/6/15.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "GoodModel.h"


@implementation GoodWeight

@end

@implementation GoodVolume

@end

@implementation CarInfo

@end

@implementation GoodModel
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"GoodWeights" : [GoodWeight class],
             @"CarInfos" : @"CarInfo",
             @"GoodVolumes" : @"GoodVolume"
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"GoodWeights" : @"zl",
             @"CarInfos" : @"che",
             @"GoodVolumes" : @"tj"
             };
}
@end
