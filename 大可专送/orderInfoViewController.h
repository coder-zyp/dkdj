//
//  orderInfoViewController.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/8.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderDetailModel.h"

@interface orderInfoViewController : UIViewController
@property (nonatomic,strong) NSString * dataid;
@property (nonatomic,strong) orderDetailModel * model;

@end
