//
//  AppDelegate.m
//  职场管家
//
//  Created by Jackie Liu on 15/12/6.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//



#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "AppDelegate+Parse.h"
#import "RootViewController.h"
#import "SideMenuViewController.h"
#import <BmobSDK/Bmob.h>


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _connectionState = eEMConnectionConnected;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"my107240#d3bc0a097d27eedb229331b2262dba72" apnsCertName:@"com.jackieliu.zhichangguanjia"];
    
    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    self.mainController = [[MYMainViewController alloc]init];
    SideMenuViewController *sideVC = [[SideMenuViewController alloc]init];
    self.rootVC  = [[RootViewController alloc]initWithContentViewController:self.mainController leftMenuViewController:sideVC rightMenuViewController:nil];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
    
       
    
    
    return YES;
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}




@end
