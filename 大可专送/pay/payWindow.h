//
//  payWindow.h
//  大可专送
//
//  Created by 张允鹏 on 2016/12/1.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sendFreeModel.h"
@interface payWindow : UIWindow

@property (nonatomic,strong) NSDictionary * param;

+ (payWindow *)shareShowWindow;
- (void)show;
- (void)close;
@end
