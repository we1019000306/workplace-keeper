//
//  DataCenter.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//
#import <BmobSDK/Bmob.h>
@interface DataCenter : NSObject
+(void)syncServerToLocalForSettings:(BmobObject *)obj;
+(void)addToContact:(BmobObject *)obj;
@end
