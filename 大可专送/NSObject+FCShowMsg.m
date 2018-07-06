//
//  NSObject+FCShowMsg.m
//  FriendChat
//
//  Created by ios2 on 2018/2/5.
//  Copyright © 2018年 石家庄光耀. All rights reserved.
//

#import "NSObject+FCShowMsg.h"

@implementation NSObject (FCShowMsg)

-(void)showMsg:(NSString *)msgTitle andAnimationCompletion:(void(^)(void))completion
{
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    UILabel *msglable = [UILabel new];
    [window addSubview:msglable];
    msglable.textColor = [UIColor whiteColor];
    msglable.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
    msglable.font = [UIFont systemFontOfSize:13.0f];
    [window bringSubviewToFront:msglable];
    msglable.layer.cornerRadius = 10.0f;
    msglable.layer.masksToBounds = YES;
    msglable.text = msgTitle;
    msglable.textAlignment = NSTextAlignmentCenter;
    msglable.numberOfLines = 0;
    CGFloat width = [msglable sizeThatFits:CGSizeMake(DEVICE_WIDTH-80.0f, CGFLOAT_MAX)].width+10.0f;
    if (width<40) {
        width = 40.0f;
    }
    CGFloat height =[msglable sizeThatFits:CGSizeMake(DEVICE_WIDTH-80.0f, CGFLOAT_MAX)].height+10.0f;
    if (height<20.0f) {
        height = 20.0f;
    }
    [msglable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    msglable.transform = CGAffineTransformMakeScale(0, 0);
    msglable.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        msglable.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        msglable.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [msglable removeFromSuperview];
            if (completion) {
                completion();
            }
    });
}

@end
