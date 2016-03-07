//
//  Config.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "Settings.h"
#import <Foundation/Foundation.h>

@interface Config : NSObject
@property (nonatomic, strong) Settings *settings;
+ (instancetype)shareInstance;

@end
