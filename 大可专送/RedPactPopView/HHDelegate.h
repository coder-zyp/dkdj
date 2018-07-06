//
//  HHDelegate.h
//  HHShop
//
//  Created by LLG on 2017/2/14.
//  Copyright © 2017年 HebeiTiboshi. All rights reserved.
//
#define HHSCreenWidth [UIScreen mainScreen].bounds.size.width

#define HHSCreenHeight [UIScreen mainScreen].bounds.size.height
#import <Foundation/Foundation.h>

@protocol HHDelegate <NSObject>

@optional

/**
 * sender 调用该方法返回的对象  
 * 选中的index 
 * customString 自定义字符串
 */
- (void)hHDelegate:(id)sender didSelectIndex:(NSInteger)index customString:(NSString *)customString;


/**
 * sender 调用该方法返回的对象
 * customString 自定义字符串用于信息的传递
 */

- (void)hHDelegate:(id)sender customString:(NSString *)customString;


@end
