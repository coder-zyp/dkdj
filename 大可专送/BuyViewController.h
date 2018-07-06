//
//  BuyViewController.h
//  国警骑士
//
//  Created by 张允鹏 on 2016/11/30.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapAddressModel.h"
#import "MapDetailViewController.h"
#import "butmodel.h"

@interface BuyViewController : UIViewController<MapDetailDelegate>


@property (nonatomic, copy) mapAddressModel * buyModel;
@property (nonatomic, copy) mapAddressModel * sendModel;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lng;
@property (nonatomic, strong) NSString * lat2;
@property (nonatomic, strong) NSString * lng2;
@property (nonatomic, strong) NSString * adress;
@property (nonatomic, assign) BOOL isfromlist;

@end
