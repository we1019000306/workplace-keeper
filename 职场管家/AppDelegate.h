//
//  AppDelegate.h
//  职场管家
//
//  Created by Jackie Liu on 15/12/6.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//
#import "MYMainViewController.h"
#import "ApplyViewController.h"
#import "RootViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MYMainViewController *mainController;

@property (strong, nonatomic) RootViewController *rootVC;
@end

