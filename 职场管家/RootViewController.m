//
//  RootViewController.m
//  plan
//
//  Created by Fengzy on 15/11/12.
//  Copyright © 2015年 Fengzy. All rights reserved.
//

#import "RootViewController.h"
#import <BmobSDK/Bmob.h>


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    [ERPCache openDBWithObjectId:@"unkown"];
    [Config shareInstance].settings = [ERPCache getPersonalSettings];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    BmobUser *buser = [BmobUser getCurrentUser];
    if (!buser) {
        [CommonUtil needLoginWithViewController:self animated:YES];
    }
}

@end
