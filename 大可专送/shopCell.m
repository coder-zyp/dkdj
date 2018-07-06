//
//  shopCell.m
//  大可专送
//
//  Created by Mac on 18/2/8.
//  Copyright © 2018年 张允鹏. All rights reserved.
//

#import "shopCell.h"

@implementation shopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=[UIColor whiteColor];

        UIImageView *shopimg=[UIImageView new];
        [self.contentView addSubview: shopimg];
        shopimg.sd_layout
        .leftSpaceToView(self.contentView, px_scale(10))
        .topSpaceToView(self.contentView,px_scale(13))
        .widthIs(px_scale(160))
        .heightIs(px_scale(160));
        self.shopimg=shopimg;
        
        UILabel *shopname=[UILabel new];
        shopname.text=@"商";
        [self.contentView addSubview: shopname];
        shopname.font=[UIFont systemFontOfSize:px(30)];
        shopname.textColor=[UIColor blackColor];
        shopname.sd_layout
        .leftSpaceToView(shopimg, px_scale(10))
        .topSpaceToView(self.contentView,px_scale(24))
        .rightSpaceToView(self.contentView, px_scale(20))
        .autoHeightRatio(0);
        //.heightIs([shijianlab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
        self.shopname=shopname;
        
        UILabel *shopphone=[UILabel new];
        shopphone.text=@"电话";
        [self.contentView addSubview: shopphone];
        shopphone.font=[UIFont systemFontOfSize:13];
        shopphone.textColor=WT_RGBColor(0xcccccc);
        shopphone.sd_layout
        .leftEqualToView(shopname)
        .topSpaceToView(shopname,px_scale(10))
        .rightSpaceToView(self.contentView,px_scale(10))
        .autoHeightRatio(0);
        //.heightIs([chulilab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
        self.shopphone=shopphone;
        
        UILabel *jingying=[UILabel new];
        jingying.text=@"经营";
        [self.contentView addSubview: jingying];
        jingying.font=[UIFont systemFontOfSize:12];
        jingying.textColor=WT_RGBColor(0xcccccc);
        jingying.sd_layout
        .leftEqualToView(shopname)
        .topSpaceToView(shopphone,px_scale(10))
        .rightSpaceToView(self.contentView,px_scale(10))
        .autoHeightRatio(0);
        //.heightIs([chulilab sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].height);
        self.jingying=jingying;
        
        self.juli =[UILabel new];
//        juli.text=@"0.0km";
        _juli.textAlignment=2;
        [self.contentView addSubview: _juli];
        _juli.font=[UIFont systemFontOfSize:px(24)];
        _juli.textColor=WT_RGBColor(0xcccccc);
        _juli.sd_layout
        .rightSpaceToView(self.contentView,px_scale(15))
        .centerYEqualToView(shopphone)
        .widthIs(80)
        .autoHeightRatio(0);
        self.jingying=jingying;

        UIView *linview=[UIView new];
        [self.contentView addSubview: linview];
        linview.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1)
        .topSpaceToView(shopimg,px_scale(13));
        linview.backgroundColor=WT_RGBColor(0xcccccc);
        [self setupAutoHeightWithBottomView:linview bottomMargin:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
