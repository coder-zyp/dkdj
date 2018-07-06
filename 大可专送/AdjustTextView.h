//
//  AdjustTextView.h
//  adfaf
//
//  Created by IVT502 on 2016/11/7.
//  Copyright © 2016年 Djiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdjustTextView;
@protocol AdjustTextViewDelegate <NSObject>

@optional
- (void)AdjustTextViewDidChange:(AdjustTextView *)textView height:(CGFloat)height;

@end

@interface AdjustTextView : UIView

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, assign) CGFloat mixHegith;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, weak) id<AdjustTextViewDelegate> textDelegate;

@end
