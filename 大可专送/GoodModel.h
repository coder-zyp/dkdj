//
//  GoodModel.h
//  大可专送
//
//  Created by Amitabha on 2018/6/15.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodWeight : NSObject
@property (nonatomic, strong) NSString * name;
@end

@interface GoodVolume : NSObject
@property (nonatomic, strong) NSString * name;
@end

@interface CarInfo : NSObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * mone;
@end

@interface GoodModel : NSObject

@property (nonatomic, strong) NSArray * GoodWeights;
@property (nonatomic, strong) NSArray * GoodVolumes;
@property (nonatomic, strong) NSArray * CarInfos;

@end
