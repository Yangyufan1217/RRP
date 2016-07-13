//
//  AppDelegate.m
//  RRP
//
//  Created by sks on 16/2/15.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "AppDelegate.h"
#import "RRPHomeViewController.h"
#import "RRPFindViewController.h"
#import "RRPMyViewController.h"
#import "RRPGuideView.h"
#import <SMS_SDK/SMSSDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//友盟统计
#import "UMMobClick/MobClick.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"


@interface AppDelegate ()<WeiboSDKDelegate,UITabBarControllerDelegate,WXApiDelegate>
@property (nonatomic,strong)RRPGuideView *guideView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    RRPHomeViewController *home = [[RRPHomeViewController alloc] init];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:home];
    RRPFindViewController *find = [[RRPFindViewController alloc] init];
    UINavigationController *findNC = [[UINavigationController alloc] initWithRootViewController:find];
    RRPMyViewController *my = [[RRPMyViewController alloc] init];
    UINavigationController *myNC = [[UINavigationController alloc] initWithRootViewController:my];
    
    
    //创建tabbar并指定viewControllers
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[homeNC, findNC, myNC];
    homeNC.tabBarItem.title = @"首页";
    findNC.tabBarItem.title = @"发现";
    myNC.tabBarItem.title = @"我的";
    homeNC.tabBarItem.image = [UIImage imageNamed:@"首页"];
    findNC.tabBarItem.image = [UIImage imageNamed:@"发现"];
    myNC.tabBarItem.image = [UIImage imageNamed:@"我的"];
    tabBar.tabBar.tintColor = IWColor(77, 218, 253);
    //指定为根视图控制器
    self.window.rootViewController = tabBar;
    
    tabBar.delegate = self;
    
    //给单列数据接口
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"ios" forKey:@"system"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"R1.0.0" forKey:@"edition"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:kSigned forKey:@"signed"];
    
    
    
    //引导页面
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user boolForKey:@"First"]) {
        
        //不是第一次运行
        
    }else{
        //第一次运行
        self.guideView = [[RRPGuideView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, RRPHeight)];
        [self.window addSubview:self.guideView];
        [user setBool:YES forKey:@"First"];
        
        /**
         *  标记用户是否登
         *  register  key
         *  YES登录了  NO未登录
         */
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"register"];
        [[NSUserDefaults standardUserDefaults] setValue:@"登录/注册" forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
               
    }
    
    //(注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误，新浪微博的外部库如果不要客户端分享或者不需要加关注微博的功能可以不添加，否则要添加，QQ，微信，google＋这些外部库文件必须要加)
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"115577265b8e0"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1335711467" appSecret:@"b65b023c2218457238485973a6f94588"
                                         redirectUri:@"sns.whalecloud.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxe6dd197ef305900d"
                                       appSecret:@"cd9a5ec6010f6b5094b750eea8d17526"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105309180"
                                      appKey:@"gDPuIK8yaHb5EEje"
                                    authType:SSDKAuthTypeBoth];
                 break;
            default:
                 break;
         }
     }];

    //初始化应用，appKey和appSecret从后台申请得
<<<<<<< HEAD
    [SMSSDK registerApp:@"115577265b8e0"
             withSecret:@"fa38965cb92420aa64e60262270f1583"];
    //微信支付
    [WXApi registerApp:@"wxe6dd197ef305900d" withDescription:@"renrenpiao"];
=======
    [SMSSDK registerApp:@"11f6f973fb67c"
             withSecret:@"8a50885a2aacbfe6e7ca570fdd11154a"];
>>>>>>> yangchao970093824/master
    
    //友盟统计
    UMConfigInstance.appKey = @"570380de67e58e5b6f0008b9";
    UMConfigInstance.channelId = @"x.co/rrpapp";
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //统计:APP启动
    [MobClick event:@"4"];
    
    return YES;
}
+ (AppDelegate*)getDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    if (tabBarController.selectedIndex == 0) {
        //统计:首页按钮点击
        [MobClick event:@"34"];
    }else if (tabBarController.selectedIndex == 1)
    {
        [MobClick event:@"35"];
    }else
    {
        [MobClick event:@"36"];
    }

}
#pragma mark - 微信支付回调方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"跳转到URL schema中配置的地址-->%@",url);//跳转到URL schema中配置的地址
    return [WXApi handleOpenURL:url delegate:self];
}
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
            }
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "yangchao.RRP" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RRP" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RRP.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
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

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
