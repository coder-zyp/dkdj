//
//  AppDelegate.h
//  大可专送
//
//  Created by 张允鹏 on 2016/11/26.
//  Copyright © 2016年 张允鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//#import "GeTuiSdk.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@property (nonatomic,strong) NSString  * token;

@property (nonatomic,strong) NSString  * cid;

- (void)saveContext;

@property (assign, nonatomic) int lastPayloadIndex;

@end

