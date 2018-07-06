//
//  shopxiangqingVC.h
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopmodel.h"
#import "mapAddressModel.h"

@protocol MapDetailDelegate <NSObject>

-(void)okBtnClickWith:(mapAddressModel *)model withBtnTag:(NSInteger )tag;
@end

@interface shopxiangqingVC : UIViewController
@property(strong,nonatomic) shopmodel *shopmodel;
@property (nonatomic,weak) id<MapDetailDelegate> delegate;
@end
