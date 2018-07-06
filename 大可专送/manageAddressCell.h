//
//  manageAddressCell.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapAddressModel.h"

@protocol manageAddressCellDelegat <NSObject>

-(void)manageAddressCellCollectBtnClickWithModel:(mapAddressModel *)model;
-(void)manageAddressCellEditBtnClickWithModel:(mapAddressModel *)model;
@end
@interface manageAddressCell : UITableViewCell

@property (nonatomic, strong) UILabel * poiNameLabel;
@property (nonatomic, strong) UILabel * poiAddressLabel;
@property (nonatomic, strong) UILabel * bulidingLabel;
@property (nonatomic, strong) mapAddressModel * model;
@property (nonatomic, strong) UIButton * collectBtn;
@property (nonatomic, strong) UIButton * editBtn;
@property (nonatomic, weak) id<manageAddressCellDelegat> delegate;

+(manageAddressCell*)cellWithTableView:(UITableView *)tableView;
@end
