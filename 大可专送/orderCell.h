//
//  orderCell.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  strongright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "orderModel.h"
@protocol orderCellDelegat <NSObject>
-(void)orderCellBottomBtnClickWithModel:(orderModel *)model;
@end


@interface orderCell : UITableViewCell


@property (nonatomic, strong) orderModel * model;

@property (nonatomic,strong) UILabel *orderTimeLabel;//下单时间,
@property (nonatomic,strong) UIImageView *orderTypeImageView;//订单分类,
@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *qAddressLabel;//取货地址,
@property (nonatomic,strong) UILabel *sAddressLabel;//送货地址,
@property (nonatomic,strong) UILabel *sTellLabel;//收货人电话,
//@property (nonatomic,strong) UILabel *sTell;//送货人电话,
@property (nonatomic,strong) UILabel *orderStatusLabel;
@property (nonatomic,strong) UIImageView *orderStatusImage;
@property (nonatomic,strong) UIButton * bottomBtn;

@property (nonatomic, weak) id <orderCellDelegat> delegate;

+(orderCell *)cellWithTableView:(UITableView *)tableView;

@end
