//
//  priceDetailViewController.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import "sendFreeModel.h"
#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface priceDetailViewController : UIViewController
@property (nonatomic,strong) sendFreeModel * model;
@property (nonatomic,strong) NSString * cityid;
@end
