//
//  NSObject+FCShowMsg.h
//  FriendChat
//
//  Created by ios2 on 2018/2/5.
//  Copyright © 2018年 石家庄光耀. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSObject (FCShowMsg)

-(void)showMsg:(NSString *)msgTitle andAnimationCompletion:(void(^)(void))completion;

@end
