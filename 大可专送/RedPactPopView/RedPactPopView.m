//
//  RedPactPopView.m
//  HHShop
//
//  Created by Macx on 2017/6/21.
//  Copyright © 2017年 huihua. All rights reserved.
//

#import "RedPactPopView.h"

#import "Masonry.h"

@interface RedPactPopView ()
{
	NSString *_gxText;
}
@property(nonatomic,strong)UILabel *gxLable;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView	*redImageView;
@property (nonatomic, strong) UIView  *whiteView;

@end



@implementation RedPactPopView

+(instancetype)redPactShow:(NSString *)msg andTishiMsg:(NSString *)tishi
{
	RedPactPopView *redPactView = [[RedPactPopView alloc]initWithTitle:msg andTishi:tishi];
	
	  [redPactView show];
	
	  return redPactView;
}

-(instancetype)initWithTitle:(NSString *)title andTishi:(NSString *)tishi
{
	
	CGRect frame = CGRectMake(0, 0, HHSCreenWidth, HHSCreenHeight);
	self = [super initWithFrame:frame];
	if (self)
 {
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
		_msgTitle = title;
		_gxText = tishi;
		[self addUI];

	}
	return self;
}

-(void)addUI
{
	
	[self addSubview:self.bgView];
		//_bgView.backgroundColor = [UIColor whiteColor];
	
	[self.bgView addSubview:self.redImageView];
 [self.redImageView addSubview:self.whiteView];
	[self.whiteView addSubview:self.msgLable];
	_bgView.clipsToBounds = YES;
	_msgLable.text = [NSString stringWithFormat:@"¥%@",_msgTitle];
	
	[self.whiteView addSubview:self.gxLable];
 NSString *str = [NSString stringWithFormat:@"有效期%@天",_gxText];

 NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:str];
 [abs addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, str.length)];
 [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, str.length)];
 [abs addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:[str rangeOfString:_gxText]];
 [abs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[str rangeOfString:_gxText]];



 _gxLable.attributedText =abs;
// _gxLable.text = (_gxText==nil)?@"恭喜您获得红包奖励！":_gxText;
	_gxLable.textAlignment = NSTextAlignmentLeft;
// UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ontap:)];
// _msgLable.userInteractionEnabled = YES;
// [_msgLable addGestureRecognizer:tap];
//
// UITapGestureRecognizer *actionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
// [self addGestureRecognizer:actionTap];

	
}

-(void)tapAction:(UIGestureRecognizer *)tap
{
	if ([tap.view isEqual:_redImageView])
	{
		return;
	}
 CGPoint point = 	[tap locationInView:self];
 CGFloat width = 	[UIScreen mainScreen].bounds.size.width-60;
	CGFloat height = [UIScreen mainScreen].bounds.size.height/1.5f;
  CGFloat y =	[UIScreen mainScreen].bounds.size.height/2.0f-height/2.0f;
BOOL isContaint = 	CGRectContainsPoint(CGRectMake(30, y, width, height),point);
	
	if (tap.state==UIGestureRecognizerStateEnded)
 {
		if (isContaint==NO)
	 {
			[self dismiss:NO];

		}
	}
}


-(void)ontap:(UIGestureRecognizer *)gesture
{
	if (gesture.state==UIGestureRecognizerStateEnded)
 {

		[self dismiss:YES];
	}
}

-(void)addlayOut
{

	
		//	_redImageView.backgroundColor = [UIColor redColor];
	_redImageView.image = [UIImage imageNamed:@"hb_bg"];
 _redImageView.userInteractionEnabled = YES;
	[_redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.mas_equalTo(0);
    make.centerY.mas_equalTo(0);
    make.height.mas_equalTo(180.0f);
	}];
 [_gxLable mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.mas_equalTo(12);
  make.bottom.mas_equalTo(-5);
 }];
 [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
  make.top.mas_equalTo(40.0f);
  make.left.mas_equalTo(40.0f);
  make.right.mas_equalTo(-40.0f);
  make.height.mas_equalTo(80.0f);
 }];
 UILabel *userLable = [UILabel new];
 userLable.textColor = [UIColor redColor];
 userLable.text = @"用户注册红包";
 userLable.font = [UIFont systemFontOfSize:14.0f];
 _whiteView.layer.cornerRadius = 3.0f;
 [_whiteView addSubview:userLable];
 [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
  make.top.mas_equalTo(8.0f);
  make.left.mas_equalTo(12.0f);
 }];

 [_msgLable mas_makeConstraints:^(MASConstraintMaker *make) {
  make.right.mas_equalTo(-5);
  make.centerY.equalTo(userLable);
 }];
 for (int i = 0; i<2; i++) {
  UIView *redV = [UIView new];
  redV.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:0 blue:0 alpha:1];
  redV.layer.cornerRadius = 10.0f;
  redV.layer.masksToBounds = YES;
  [_whiteView addSubview:redV];
  [redV mas_makeConstraints:^(MASConstraintMaker *make) {
   if (i==0) {
    make.left.mas_equalTo(-10.0f);
   }else{
    make.right.mas_equalTo(10.0f);
   }
   make.centerY.mas_equalTo(0);
   make.size.mas_equalTo((CGSize){20.0f,20.0f});
  }];
 }
 UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
 btn.backgroundColor = [UIColor colorWithRed:1 green:136.0f/255.0f blue:0 alpha:1];
 [_redImageView addSubview:btn];
 btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
 [btn setTitle:@"立即使用" forState:UIControlStateNormal];
 btn.layer.cornerRadius = 5.0f;
  [btn addTarget:self action:@selector(fastUseAction:) forControlEvents:UIControlEventTouchUpInside];
 [btn mas_makeConstraints:^(MASConstraintMaker *make) {
  make.left.equalTo(_whiteView.mas_left).offset(20.0f);
  make.right.equalTo(_whiteView.mas_right).offset(-20.0f);
  make.height.mas_equalTo(30.0f);
  make.top.equalTo(_whiteView.mas_bottom).offset(10);
 }];
 UIButton *closeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
  [_bgView addSubview:closeBtn];
 [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
 [closeBtn setImage:[UIImage imageNamed:@"pop_close"] forState:UIControlStateNormal];
 [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
  make.centerX.mas_equalTo(0);
  make.top.equalTo(_redImageView.mas_bottom).offset(40.0f);
  make.size.mas_equalTo((CGSize){30,30});
 }];
}
-(void)closeAction:(UIButton *)button
{
 [self dismiss:NO];
}
-(void)fastUseAction:(UIButton *)button
{
 [self dismiss:YES];
}


-(void)show
{
   UIWindow *window =	[[UIApplication sharedApplication].delegate window];
	  [window addSubview:self];
	  [window bringSubviewToFront:self];
			[self addBgViewLayOutWithHeight:0.0f];
	CGFloat height = [UIScreen mainScreen].bounds.size.height/1.5f;

	[self addlayOut];
	
	[self addBgViewLayOutWithHeight:height];
//  _bgView.transform =CGAffineTransformMakeScale(0.75, 0.75);
//
// [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5 options:0 animations:^{
//  _bgView.transform =CGAffineTransformMakeScale(1.0, 1.0);
// } completion:^(BOOL finished) {
// }];
}

-(void)addBgViewLayOutWithHeight:(CGFloat)height
{
	if (height>0)
	{
		[_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
						make.height.mas_equalTo(height);
		   	make.left.equalTo(@(30));
			make.right.equalTo(@(-30));
		}];
	}else{
		[_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(@(30));
			make.right.equalTo(@(-30));
			make.centerY.mas_equalTo(0);
			make.height.mas_equalTo(height);
		}];

	}

}

-(void)dismiss:(BOOL)isPush
{
	[UIView animateKeyframesWithDuration:0.2 delay:0 options:0 animations:^{
		
		self.alpha = 0.0f;
		_bgView.transform = CGAffineTransformMakeScale(1.5, 1.5);
	} completion:^(BOOL finished) {
		if (finished)
		{
			if (isPush)
			{
				if ([self.delegate respondsToSelector:@selector(hHDelegate:didSelectIndex:customString:)])
				{
					[_delegate hHDelegate:self didSelectIndex:-1 customString:@"pushToSubVC"];
				}

			}
			[self removeFromSuperview];
		}
	}];
	
}


-(void)actionClick:(id)sender
{
	
}


-(UIView *)bgView
{
	if (_bgView==nil)
	{
		_bgView = [[UIView alloc]init];
			//	_bgView.backgroundColor = [UIColor whiteColor];
		_bgView.clipsToBounds = YES;
	}
	return _bgView;
}


-(UILabel *)msgLable
{
	if (_msgLable==nil)
	{
		_msgLable = [[UILabel alloc]init];
  _msgLable.font = [UIFont boldSystemFontOfSize:14.70f];
		_msgLable.textColor = [UIColor redColor];
		_msgLable.numberOfLines = 0;
		_msgLable.textAlignment = NSTextAlignmentCenter;
	}
	return _msgLable;
}



-(UIImageView *)redImageView
{
	if (_redImageView==nil)
	{
		_redImageView = [[UIImageView alloc]init];
	}
	return _redImageView;
}

-(UILabel *)gxLable
{
	if (_gxLable==nil)
	{
		_gxLable = [[UILabel alloc]init];
		_gxLable.font = [UIFont boldSystemFontOfSize:16.0f];
		_gxLable.textColor = [UIColor yellowColor];
	}
	return _gxLable;
}

-(UIView *)whiteView
{
 if (_whiteView==nil)
  {
  _whiteView = [[UIView alloc]init];
  _whiteView.backgroundColor = [UIColor whiteColor];
  }
 return _whiteView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
