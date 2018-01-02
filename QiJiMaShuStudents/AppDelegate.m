//
//  AppDelegate.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/8/5.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "SideBarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AssistiveTouch.h"
#import "MyOrderViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<AssistiveTouchDelegate,JPUSHRegisterDelegate>{
    //悬浮框
    AssistiveTouch * _Win;
}

@end

@implementation AppDelegate

-(void)setNew
{
    _Win = [[AssistiveTouch alloc] initWithFrame:CGRectMake(0, 100, 80, 80)];
    _Win.delegate = self;
}

- (void)indeterminateExample {
    
    [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];//加载指示器出现
    
}

- (void)delayMethod{
    
    [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];//加载指示器消失
    
}

- (void)aKeyClickBookin {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        LogInViewController *FYLPageVC =[[LogInViewController alloc]init];
        UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
        [self.window.rootViewController setHidesBottomBarWhenPushed:YES];
        [self.window.rootViewController presentViewController:NAVC animated:YES completion:nil];
        return;
    }
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"" message:@"亲爱的会员,您可直接到俱乐部前台办理马术训练手册!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"立即预约" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self indeterminateExample];
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/quickMakeReservation",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"stuId"] =[UserDataSingleton mainSingleton].studentsId;
        __weak  AppDelegate *VC = self;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.requestSerializer.timeoutInterval = 10;
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            [VC delayMethod];
            if ([resultStr isEqualToString:@"1"]) {
                [VC showAlert:responseObject[@"msg"]];
                MyOrderViewController *FYLPageVC =[[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
                UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
                [VC.window.rootViewController setHidesBottomBarWhenPushed:YES];
                [VC.window.rootViewController presentViewController:NAVC animated:YES completion:nil];
            }else {
                [VC showAlert:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC delayMethod];
            [VC showAlert:@"网络超时请重试!"];
            NSLog(@"error%@", error);
        }];
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self.window.rootViewController presentViewController:alertV animated:YES completion:^{
        nil;
    }];

    
   

    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
   // [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
      //  [rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    //    [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //  InstallUncaughtExceptionHandler();
  /*
    @param activePlatforms
    使用的分享平台集合
    @param importHandler (onImport)
    导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
    @param configurationHandler (onConfiguration)
    配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
    */
    // 这句话很重要，要先将rootview加载完成之后在显示悬浮框，如没有这句话，将可能造成程序崩溃
    [self performSelector:@selector(setNew) withObject:nil afterDelay:3];
    
    [self.window makeKeyAndVisible];
    
    
    [ShareSDK registerApp:@"21ed803626c70" activePlatforms:@[@(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformTypeQQ),] onImport:^(SSDKPlatformType platformType) {
                                                                 switch (platformType){
                                                                     case SSDKPlatformTypeWechat:
                                                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                         break;
                                                                     case SSDKPlatformTypeQQ:
                                                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                         break;
                                                                     default:
                                                                         break;
                                                                 }
                                                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                                 switch (platformType){
                                                                     case SSDKPlatformTypeWechat:
                                                                         [appInfo SSDKSetupWeChatByAppId:@"wx3fbcf0d51a2e675e"
                                                                                               appSecret:@"2231aa718a55856af0397d3c64282da9"];
                                                                         break;
                                                                     case SSDKPlatformTypeQQ:
                                                                         [appInfo SSDKSetupQQByAppId:@"1106149369"
                                                                                              appKey:@"pWiT1m7XoJppzilg"
                                                                                            authType:SSDKAuthTypeBoth];
                                                                         break;
                                                                     default:
                                                                         break;
                                                                 }
                                                             }];
    
    
    
    NSString *str = nil;
    NSLog(@"didFinishLaunchingWithOptions%@", str?@"YES":@"NO");
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
   
    // 侧拉VC
    SideBarViewController *leftViewController = [[SideBarViewController alloc] init];
    // 主VC
    BaseTabBarViewController *VC= [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = VC;
    
    // 初始化XYSideViewController 设置为window.rootViewController
    XYSideViewController *rootViewController = [[XYSideViewController alloc] initWithSideVC:leftViewController currentVC:VC];
    rootViewController.sideContentOffset = 230.0;
    self.window.rootViewController = rootViewController;
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.baitaishangcheng.wwwssl-App.ProvideMall_App" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QiJiMaShuStudents.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSInferMappingModelAutomaticallyOption:@YES, NSMigratePersistentStoresAutomaticallyOption:@YES} error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QiJiMaShuStudents" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付跳转支付宝钱包进行支付，处理支付结果result = %@",resultDic);
            NSString *str1 = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"] ];
            if ([str1 isEqualToString:@"9000"]){
                [self showAlert:@"支付成功"];
                NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [self showAlert:@"支付成功"];
                
            }else {
                NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [self showAlert:@"支付失败"];
                
            }
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"授权跳转支付宝钱包进行支付，处理支付结果result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else {
       
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"9.0以后支付跳转result = %@",resultDic);
            NSString *str1 = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"] ];
            if ([str1 isEqualToString:@"9000"]){
                [self showAlert:@"支付成功"];
                NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [self showAlert:@"支付成功"];
            }else {
                NSNotification * notice = [NSNotification notificationWithName:@"return" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [self showAlert:@"支付失败"];
                
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"9.0以后授权跳转result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else {
    }
    return YES;
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


@end
