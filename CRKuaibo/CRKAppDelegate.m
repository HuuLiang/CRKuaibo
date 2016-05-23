//
//  CRKAppDelegate.m
//  CRKuaibo
//
//  Created by Sean Yue on 16/5/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "CRKAppDelegate.h"
#import "CRKUserAccessModel.h"
#import "CRKActivateModel.h"
#import "CRKPaymentModel.h"
#import "CRKSystemConfigModel.h"
#import "CRKAppSpreadBannerModel.h"
#import "CRKPaymentManager.h"
#import "MobClick.h"

// Tab View Controllers
#import "CRKHomeViewController.h"
#import "CRKChannelViewController.h"
#import "CRKMineViewController.h"

@interface CRKAppDelegate ()

@end

@implementation CRKAppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    CRKHomeViewController *homeVC = [[CRKHomeViewController alloc] init];
    homeVC.title = @"首页";
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:homeVC.title image:[UIImage imageNamed:@"tabbar_home"] selectedImage:nil];
    
    CRKChannelViewController *channelVC = [[CRKChannelViewController alloc] init];
    UINavigationController *channelNav = [[UINavigationController alloc] initWithRootViewController:channelVC];
    channelNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar_channel_normal"] selectedImage:[UIImage imageNamed:@"tabbar_channel_selected"]];
    
    CRKMineViewController *mineVC = [[CRKMineViewController alloc] init];
    mineVC.title = @"我的";
    
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title image:[UIImage imageNamed:@"tabbar_mine"] selectedImage:nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeNav,channelNav,mineNav];
    tabBarController.tabBar.translucent = NO;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = tabBarController;
    return _window;
}

- (void)setupCommonStyles {
    //[[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#dd0077"]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#dd0077"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithHexString:@"#dd0077"]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                   forState:UIControlStateNormal|UIControlStateSelected];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationController.navigationBar.translucent = NO;
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                               } error:nil];
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:CRK_UMENG_APP_ID reportPolicy:BATCH channelId:CRK_CHANNEL_NO];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CRKUtil accumateLaunchSeq];
    [[CRKPaymentManager sharedManager] setup];
    [[CRKErrorHandler sharedHandler] initialize];
    [self setupCommonStyles];
    [self setupMobStatistics];
    [self.window makeKeyAndVisible];
    
    if (![CRKUtil isRegistered]) {
        [[CRKActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            if (success) {
                [CRKUtil setRegisteredWithUserId:userId];
                [[CRKUserAccessModel sharedModel] requestUserAccess];
            }
        }];
    } else {
        [[CRKUserAccessModel sharedModel] requestUserAccess];
    }
    
    [[CRKPaymentModel sharedModel] startRetryingToCommitUnprocessedOrders];
    [[CRKSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        
        if (!success) {
            return ;
        }
        
        if ([CRKSystemConfigModel sharedModel].startupInstall.length == 0
            || [CRKSystemConfigModel sharedModel].startupPrompt.length == 0) {
            return ;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[CRKSystemConfigModel sharedModel].startupInstall]];
    }];
    
    [[CRKAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([CRKUtil isPaid]) {
        return ;
    }
    
    UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        DLog(@"Application expired background task!");
        [application endBackgroundTask:bgTask];
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[CRKLocalNotificationManager sharedManager] scheduleLocalNotificationInEnteringBackground];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[CRKPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[CRKPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[CRKPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}
@end
