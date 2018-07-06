//
//  orderCell.m
//  大可专送
//
//  Created by 张允鹏 on 2016/12/2.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import "orderCell.h"

@implementation orderCell
+(orderCell*)cellWithTableView:(UITableView *)tableView{
    orderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[orderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView removeConstraints:self.contentView.constraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=APP_GARY;
        
        UIView * backView=[[UIView alloc]init];
        backView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:backView];
        backView.layer.cornerRadius=5;
        [backView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 0, 10));
        }];
        
        _orderTypeImageView = [[UIImageView alloc]init];
        [backView addSubview: _orderTypeImageView];
        [_orderTypeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(81, 26));
            make.top.mas_equalTo(backView).offset(7);
            make.left.mas_equalTo(5);
        }];
        
        _orderTypeLabel =[[UILabel alloc]init];
        _orderTypeLabel.font=[UIFont systemFontOfSize:13];
        _orderTypeLabel.textAlignment=NSTextAlignmentRight;
        _orderTypeLabel.textColor=[UIColor whiteColor];
        [_orderTypeImageView addSubview:_orderTypeLabel];
        [_orderTypeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 9));
        }];
        
        _orderTimeLabel=[[UILabel alloc]init];
        _orderTimeLabel.font=[UIFont systemFontOfSize:12];
        _orderTimeLabel.textAlignment=NSTextAlignmentRight;
        [backView addSubview:_orderTimeLabel];
        [_orderTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerY.mas_equalTo(_orderTypeImageView);
            make.right.mas_equalTo(backView).offset(-10);
        }];
        
        UIView * lineHorizontal=[[UIView alloc]init];
        lineHorizontal.backgroundColor=APP_GARY;
        [backView addSubview:lineHorizontal];
        [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineHorizontal.superview);
            make.left.mas_equalTo(lineHorizontal.superview).offset(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(lineHorizontal.superview).offset(40);
        }];
        
        UIView * labelView=[[UIView alloc]init];
        [backView addSubview:labelView];
        [labelView makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineHorizontal);
            make.left.right.mas_equalTo(backView);
            make.height.mas_equalTo(80);
        }];
        
        _qAddressLabel=[[UILabel alloc]init];
        _qAddressLabel.font=[UIFont systemFontOfSize:14];
        [labelView addSubview:_qAddressLabel];
        
        _sAddressLabel=[[UILabel alloc]init];
        _sAddressLabel.font=[UIFont systemFontOfSize:14];
        [labelView addSubview:_sAddressLabel];
        
        _sTellLabel=[[UILabel alloc]init];
        _sTellLabel.font=[UIFont systemFontOfSize:14];
        [labelView addSubview:_sTellLabel];
        
        [labelView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [labelView.subviews makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(labelView).offset(-50);
        }];
        
        UILabel * label=[[UILabel alloc]init];
        label.text=@"从";
        label.textColor=[UIColor lightGrayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        [labelView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_qAddressLabel);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(_qAddressLabel.mas_left);
        }];
        
        label=[[UILabel alloc]init];
        label.text=@"到";
        label.textColor=[UIColor lightGrayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        [labelView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_sAddressLabel);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(_sAddressLabel.mas_left);
        }];
        
        _orderStatusImage = [[UIImageView alloc]init];
        [labelView addSubview: _orderStatusImage];
        [_orderStatusImage makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(labelView).offset(16);
            make.right.mas_equalTo(labelView).offset(-10);
        }];
        
        _orderStatusLabel=[[UILabel alloc]init];
        _orderStatusLabel.textColor=APP_ORAGNE;
        _orderStatusLabel.textAlignment=NSTextAlignmentCenter;
        _orderStatusLabel.font=[UIFont systemFontOfSize:13];
        [labelView addSubview:_orderStatusLabel];
        [_orderStatusLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_orderStatusImage.mas_bottom).offset(5);
            make.centerX.mas_equalTo(_orderStatusImage);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        
        lineHorizontal=[[UIView alloc]init];
        lineHorizontal.backgroundColor=APP_GARY;
        [backView addSubview:lineHorizontal];
        [lineHorizontal makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineHorizontal.superview);
            make.left.mas_equalTo(lineHorizontal.superview).offset(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(labelView.mas_bottom).offset(0);
        }];
        
        _bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setTitleColor:APP_ORAGNE forState:0];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bottomBtn.layer setBorderWidth:1];
        [_bottomBtn.layer setBorderColor:APP_ORAGNE.CGColor];
        [_bottomBtn.layer setCornerRadius:4];
        [_bottomBtn addTarget: self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_bottomBtn];
        [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backView).offset(-8);
            make.bottom.mas_equalTo(backView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    return self;
}
-(void)bottomBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCellBottomBtnClickWithModel:)]) {
        [self.delegate orderCellBottomBtnClickWithModel:self.model];
    }

}
-(void)setModel:(orderModel *)model{
    _model=model;
    
    _orderTypeImageView.image=[UIImage imageNamed:model.orderType];
    _orderTypeLabel.text=model.orderType;
    _orderTimeLabel.text=model.orderTime;
    _qAddressLabel.text=model.qAddress;
    _sAddressLabel.text=model.sAddress;
    _sTellLabel.text=[NSString stringWithFormat:@"收货电话:%@",model.sTell];
    _orderStatusLabel.text=model.dingdanzhuangtai;
    if (model.payState.intValue==0) {
        if (model.IsShopSet.intValue==2&&model.orderStatus.intValue==4) {//取消的订单
            _orderStatusImage.image=[UIImage imageNamed:@"沙漏"];
            _orderStatusLabel.text=@"已取消";
            _orderStatusLabel.textColor = [UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:50.0/255.0 alpha:1];
            _bottomBtn.hidden=YES;
        }else{
            _orderStatusImage.image=[UIImage imageNamed:@"待支付"];
            _orderStatusLabel.textColor = APP_BLUE;
            _bottomBtn.hidden=NO;
            [_bottomBtn setTitle:@"去支付" forState:0];
        }
        
        
    }else{
        _orderStatusImage.image=[UIImage imageNamed:@"沙漏"];
        _orderStatusLabel.textColor = [UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:50.0/255.0 alpha:1];
        if (model.orderStatus.integerValue==7 && model.sendState.integerValue==0) {//未接单
            _bottomBtn.hidden=NO;
            [_bottomBtn setTitle:@"取消订单" forState:0];
        }else{
            _bottomBtn.hidden=YES;
        }
    }

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
