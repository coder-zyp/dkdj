//
//  shoplistVC.h
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "butmodel.h"

@interface shoplistVC : UIViewController
@property(strong,nonatomic) butmodel *butmodel;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lng;
@end
