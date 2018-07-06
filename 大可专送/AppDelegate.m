//
//  AppDelegate.m
//  大可专送
//
//  Created by 张允鹏 on 2016/11/26.
//  Copyright © 2016年 张允鹏. All rights reserved.
//
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AppDelegate.h"
#import "baseNavigationController.h"
#import "ViewController.h"
#import "mapViewTool.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>
#import <IQKeyboardManager.h>
#import "WebViewController.h"
#import "HTMLViewController.h"
//#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#define XLJVersion @"LocationVersion"
#define kGtAppId           @"4xTIzKY62D7FOt8esAbZ45"
#define kGtAppKey          @"1YxlBwXMmW5nrD80I2Umd4"
#define kGtAppSecret       @"v19QLdoc2o7NEOyXY3fML6"

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) baseNavigationController *navigationController;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.navigationController=[[baseNavigationController alloc]initWithRootViewController:[[ViewController alloc]init] ];
    //设置窗口的根控制器
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //========================
    [UINavigationBar appearance].translucent = NO;
    
    //微信
    [WXApi registerApp:@"wxed83bb8c8a49d5ea"];
    //地图
    [AMapServices sharedServices].apiKey = @"a4aecb0f785e42f77c1bd082b5b16e10";
    

    #pragma mark-推送
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    return YES;
}


#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    
}
/** 远程通知注册成功委托 */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0){
    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0){
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
//    [JPUSHSaervice handleRemoteNotification:userInfo];
}

- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册通知成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
    
    
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册失败委托 */


#pragma mark - APP运行中接收到通知(推送)处理


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSdk ]：个推SDK已注册，返回clientId
    self.cid=clientId;
    NSLog(@">>[GTSdk RegisterClient]:%@", clientId);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetuiNotification" object:self userInfo:nil];
    
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 页面显示：上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"record:%@",record);
    //    [_viewController logMsg:record];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // 页面显示：个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    
    NSLog(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

#pragma mark 接收本地通知时触发

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    //应用在前台收到通知
//    NSLog(@"========%@", notification);
//}
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    //点击通知进入应用
//    NSLog(@"response:%@", response);
//}
//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    //    application.applicationIconBadgeNumber = 0;
//    // //判断应用程序当前的运行状态
//    if (application.applicationState == UIApplicationStateActive) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    }
//    
//}

//新的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSNotification* notification;
            NSString * state=[resultDic objectForKey:@"resultStatus"];
            NSLog(@"result = %@   %@",resultDic,state);
            if ([state isEqualToString:@"9000"]) {
                NSLog(@"支付成功");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"isjiaoyi"];
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付成功",@"msg":@"刷新查看余额变化，最晚3分钟到账"}];
                
            }else if ([state isEqualToString:@"6001"]) {
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付取消"}];
                NSLog(@"用户取消");
            }else{
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付异常"}];
                NSLog(@"支付异常");
            }
            [self.navigationController popToRootViewControllerAnimated:NO];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
    }
 
    return [WXApi handleOpenURL:url delegate:self];
}

//被废弃的方法. 但是在低版本中会用到.建议写上
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSNotification* notification;
            NSString * state=[resultDic objectForKey:@"resultStatus"];
            NSLog(@"result = %@   %@",resultDic,state);
            if ([state isEqualToString:@"9000"]) {
                NSLog(@"支付成功");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"isjiaoyi"];

//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付成功"}];
                
            }else if ([state isEqualToString:@"6001"]) {
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付取消"}];
                NSLog(@"用户取消");
            }else{
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付异常"}];
                NSLog(@"支付异常");
            }
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
//被废弃的方法. 但是在低版本中会用到.建议写上

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSNotification* notification;
            NSString * state=[resultDic objectForKey:@"resultStatus"];
            NSLog(@"result = %@   %@",resultDic,state);
            if ([state isEqualToString:@"9000"]) {
                NSLog(@"支付成功");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"isjiaoyi"];

//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付成功"}];
                
            }else if ([state isEqualToString:@"6001"]) {
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付取消"}];
                NSLog(@"用户取消");
            }else{
//                notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:@{@"info":@"支付异常"}];
                NSLog(@"支付异常");
            }
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToRootViewControllerAnimated:NO];

        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
-(void) onResp:(BaseResp*)resp
{
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSDictionary * infoDict=@{@"info":strMsg};
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                [defaults1 setObject:nil forKey:@"isjiaoyi"];
                infoDict=@{@"info":@"支付成功",@"msg":@"刷新查看余额变化，最晚3分钟到账"};
                
                break;
            case WXErrCodeUserCancel:
                infoDict=@{@"info":@"支付取消"};
                break;
            default:
                infoDict=@{@"info":@"微信支付异常，请稍后再试！"};
                break;
        }
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        return;
    }
//    NSNotification * notification = [NSNotification notificationWithName:@"payNotifiComeBack" object:nil userInfo:infoDict];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"____"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
