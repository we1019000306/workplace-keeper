//
//  ERPCache.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "Settings.h"
#import "Contact.h"

@interface ERPCache : NSObject
+ (void)openDBWithObjectId:(NSString *)objectId;
+ (void)storePersonalSettings:(Settings *)settings;
+ (void)storeContact:(Contact *)contact;
+ (Settings *)getPersonalSettings;
+ (Contact *)getContact:(NSString *)username;
+ (NSArray *)getContact;
+ (void)deleteContact:(NSString *)username;




@end
