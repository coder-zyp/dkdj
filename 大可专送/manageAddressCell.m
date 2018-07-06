//
//  manageAddressCell.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "manageAddressCell.h"

@implementation manageAddressCell
+(manageAddressCell*)cellWithTableView:(UITableView *)tableView{
    manageAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[manageAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView removeConstraints:self.contentView.constraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * lableView=[[UIView alloc]init];
        [self.contentView addSubview:lableView];
        [lableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(100);
        }];
        
        _poiNameLabel=[[UILabel alloc]init];
        _poiNameLabel.font=[UIFont systemFontOfSize:17];
        [lableView addSubview:_poiNameLabel];

        
        _poiAddressLabel=[[UILabel alloc]init];
        _poiAddressLabel.font=[UIFont systemFontOfSize:15];
        _poiAddressLabel.textColor=[UIColor lightGrayColor];
        [lableView addSubview:_poiAddressLabel];
   
        
        _bulidingLabel=[[UILabel alloc]init];
        _bulidingLabel.font=[UIFont systemFontOfSize:15];
        _bulidingLabel.textColor=[UIColor lightGrayColor];
        [lableView addSubview:_bulidingLabel];
        
        [lableView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:17 leadSpacing:10 tailSpacing:10];
        [lableView.subviews makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(lableView).offset(10);
            make.right.mas_equalTo(lableView).offset(-10);
        }];
        
        UIView * lineHorizontal=[[UIView alloc]init];
        lineHorizontal.backgroundColor=APP_GARY;
        [self.contentView addSubview:lineHorizontal];
        [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineHorizontal.superview);
            make.left.mas_equalTo(lineHorizontal.superview).offset(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(lableView.mas_bottom).offset(0);
        }];
  
        _collectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"地址取消"] forState:0];
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_collectBtn];
        [_collectBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.right.bottom.mas_equalTo(self.contentView).offset(-10);

        }];

        _editBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"地址编辑"] forState:0];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editBtn];
        [_editBtn makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.right.mas_equalTo(_collectBtn.mas_left).offset(-10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
        }];
        _editBtn.hidden=YES;
        lineHorizontal=[[UIView alloc]init];
        lineHorizontal.backgroundColor=APP_GARY;
        [self.contentView addSubview:lineHorizontal];
        [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineHorizontal.superview);
            make.left.mas_equalTo(lineHorizontal.superview).offset(0);
            make.height.mas_equalTo(5);
            make.bottom.mas_equalTo(lineHorizontal.superview).offset(0);
        }];
    }
    return self;
}
-(void)collectBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageAddressCellCollectBtnClickWithModel:)]) {
        [self.delegate manageAddressCellCollectBtnClickWithModel:self.model];
    }
}
-(void)editBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageAddressCellEditBtnClickWithModel:)]) {
        [self.delegate manageAddressCellEditBtnClickWithModel:self.model];
    }
}
-(void)setModel:(mapAddressModel *)model{
    _model=model;
    _poiNameLabel.text=[NSString stringWithFormat:@"地址名称：%@",model.poiName];
    _poiAddressLabel.text=[NSString stringWithFormat:@"详细地址：%@",model.poiName];
    _bulidingLabel.text=[NSString stringWithFormat:@"楼层/门牌号：%@",model.buildName? model.buildName:@""];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
