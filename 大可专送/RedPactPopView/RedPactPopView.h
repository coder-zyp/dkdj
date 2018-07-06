//
//  RedPactPopView.h
//  HHShop
//
//  Created by Macx on 2017/6/21.
//  Copyright © 2017年 huihua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HHDelegate.h"

@interface RedPactPopView : UIView

@property (nonatomic, strong) UILabel		*msgLable;
@property (nonatomic, assign) id <HHDelegate>delegate;

@property (nonatomic, strong) NSString		*msgTitle;

+(instancetype)redPactShow:(NSString *)msg andTishiMsg:(NSString *)tishi;

-(instancetype)initWithTitle:(NSString *)title andTishi:(NSString *)tishi;

-(void)show;

-(void)dismiss:(BOOL)isPush;

@end
