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


#import "UIImageView+HeadImage.h"
#import <BmobSDK/Bmob.h>
#import "UserProfileManager.h"
#import "UIImageView+EMWebCache.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
//    [self.layer setMasksToBounds:YES];
//    [self.layer setCornerRadius:30];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"username"] isEqualToString:username]) {
                if ([obj objectForKey:@"avatar"]) {
                    
                    [self sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
                }else
                    [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
                
                
            }
        }
    }];
}
- (void)imageWithUsernameTwo:(NSString *)username placeholderImage:(UIImage*)placeholderImage{
//    [self.layer setMasksToBounds:YES];
//    [self.layer setCornerRadius:17];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"username"] isEqualToString:username]) {
                if ([obj objectForKey:@"avatar"]) {
                    
                    [self sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
                }else
                    [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
                
                
            }
        }
    }];
    
}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    if (profileEntity) {
        if (profileEntity.nickname && profileEntity.nickname.length > 0) {
            [self setText:profileEntity.nickname];
            [self setNeedsLayout];
        } else {
            [self setText:username];
        }
    } else {
        [self setText:username];
    }
    
}

@end

