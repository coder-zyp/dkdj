//
//  MapDetailViewController.h
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapAddressModel.h"
@protocol MapDetailDelegate <NSObject>

-(void)okBtnClickWith:(mapAddressModel *)model withBtnTag:(NSInteger )tag;

@end


@interface MapDetailViewController : UIViewController

@property (nonatomic,weak) id<MapDetailDelegate> delegate;
@property (nonatomic,assign) NSInteger pushBtnTag;

@end
