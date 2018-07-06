//
//  addressCell.h
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapAddressModel.h"

@protocol addressCellDelegat <NSObject>

-(void)collectBtnClickWithModel:(mapAddressModel *)model;

@end

@interface addressCell : UITableViewCell
@property (nonatomic, strong) UILabel * poiLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * distanceLabel;
@property (nonatomic, strong) mapAddressModel * model;
@property (nonatomic, strong) UIButton * collectBtn;
@property (nonatomic, weak) id<addressCellDelegat> delegate;
+(addressCell*)cellWithTableView:(UITableView *)tableView;
@end
