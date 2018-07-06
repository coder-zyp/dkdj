//
//  addressCell.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/29.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "addressCell.h"

@implementation addressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(addressCell*)cellWithTableView:(UITableView *)tableView{
    addressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[addressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView removeConstraints:self.contentView.constraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * imgeview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_normal"]];
        [self.contentView addSubview:imgeview];
        [imgeview makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _poiLabel=[[UILabel alloc]init];
        _poiLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_poiLabel];
        [_poiLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(0);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.left.mas_equalTo(40);
            make.height.mas_equalTo(30);
        }];
        
        _addressLabel=[[UILabel alloc]init];
        _addressLabel.font=[UIFont systemFontOfSize:14];
        _addressLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_addressLabel];
        [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_poiLabel.mas_bottom).offset(-3);
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(self.contentView).offset(-50);
            make.height.mas_equalTo(20);
        }];
        
        _distanceLabel=[[UILabel alloc]init];
        _distanceLabel.font=[UIFont systemFontOfSize:14];
        _distanceLabel.textColor=[UIColor lightGrayColor];
        _distanceLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressLabel);
//            make.width.mas_equalTo(50);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(20);
        }];
        _collectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"collect_select"] forState:0];
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_collectBtn];
        [_collectBtn makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(42);
            make.top.right.bottom.mas_equalTo(self.contentView);
        }];
        _collectBtn.hidden=YES;
    }
     return self;
}
-(void)collectBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectBtnClickWithModel:)]) {
        [self.delegate collectBtnClickWithModel:self.model];
    }
}
-(void)setModel:(mapAddressModel *)model{
    _model=model;
    _poiLabel.text=model.poiName;
    _addressLabel.text=model.poiAddress;
    _distanceLabel.text=model.distance?[NSString stringWithFormat:@"%@m",model.distance]:@"";
    _collectBtn.hidden = model.addressId.length ? NO :YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
