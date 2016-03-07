//
//  CommonUtil.h
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface CommonUtil : NSObject

#pragma mark ui
+(UILabel*)navigationTitleViewWithTitle:(NSString *)title;
+(UIFont*)setFontSize:(CGFloat)size;
+(UIColor*)setColorByR:(float)r G:(float)g   B:(float)b;

#pragma mark 
+(void)needLoginWithViewController:(UIViewController*)viewController animated:(BOOL)animated;
+(NSString *)turnStringToEmojiText:(NSString *)string;

+(NSString *)filepath;

+ (NSString*) unescapeUnicodeString:(NSString*)string;
+ (NSString*) escapeUnicodeString:(NSString*)string;

//保存图片
+(BOOL)saveImage:(UIImage*)image filepath:(NSString *)path;



@end
