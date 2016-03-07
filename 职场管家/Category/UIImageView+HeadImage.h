/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


#import <UIKit/UIKit.h>

@interface UIImageView (HeadImage)

- (void)imageWithUsername:(NSString*)username placeholderImage:(UIImage*)placeholderImage;
- (void)imageWithUsernameTwo:(NSString *)username placeholderImage:(UIImage*)placeholderImage;

@end

@interface UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username;

@end
