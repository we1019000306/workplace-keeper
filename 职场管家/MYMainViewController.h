//
//  MYMainViewController.h
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/13.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

@interface MYMainViewController : UITabBarController{
    EMConnectionState _connectionState;
}
- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
