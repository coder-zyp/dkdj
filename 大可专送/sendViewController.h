//
//  sendViewController.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapAddressModel.h"
#import "MapDetailViewController.h"
@interface sendViewController : UIViewController<MapDetailDelegate>
@property (nonatomic, copy) mapAddressModel * sendModel;
@property (nonatomic, copy) mapAddressModel * receiptModel;

@end
