//
//  Login.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/18.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "Login.h"
#import <BmobSDK/Bmob.h>
#import "CommonUtil.h"
@implementation Login
+ (BOOL)isLogin {
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        return YES;
    } else {
        return NO;
    }
}

@end
