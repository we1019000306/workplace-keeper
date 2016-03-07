 
//
//  main.m
//  职场管家
//
//  Created by Jackie Liu on 15/12/6.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"d3bc0a097d27eedb229331b2262dba72";
        [Bmob registerWithAppKey: appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
