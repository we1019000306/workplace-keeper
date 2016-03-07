//
//  UIBarButtonItem+Extension.h
//  58School
//
//  Created by YoKing on 15/9/10.
//  Copyright (c) 2015年 YunKu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
