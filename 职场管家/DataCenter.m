//
//  DataCenter.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "DataCenter.h"
#import <BmobSDK/Bmob.h>
#import "Config.h"
#import "SDWebImage/SDWebImageDownloader.h"
#import "ERPCache.h"
#import "Contact.h"

@implementation DataCenter
+ (void)syncServerToLocalForSettings:(BmobObject *)obj {
    [Config shareInstance].settings.objectId = obj.objectId;
    [Config shareInstance].settings.nickname = [obj objectForKey:@"name"];
    [Config shareInstance].settings.gender = [obj objectForKey:@"gender"];
//    [Config shareInstance].settings.createtime = [obj objectForKey:@"createdTime"];
//    [Config shareInstance].settings.updatetime = [obj objectForKey:@"updatedTime"];
    [Config shareInstance].settings.position = [obj objectForKey:@"userPosition"];
    [Config shareInstance].settings.email = [obj objectForKey:@"email"];

    NSString *serverAvatarURL = [obj objectForKey:@"avatar"];

    if (!serverAvatarURL || serverAvatarURL.length == 0) {
        [Config shareInstance].settings.avatarURL = @"";
    } else {
        if (![[Config shareInstance].settings.avatarURL isEqualToString:serverAvatarURL]) {
            [Config shareInstance].settings.avatarURL = serverAvatarURL;
            
            SDWebImageDownloader *imageDownloader = [SDWebImageDownloader sharedDownloader];
            NSURL *url = [NSURL URLWithString: [Config shareInstance].settings.avatarURL];
            [imageDownloader downloadImageWithURL:url options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"下载头像图片进度： %ld/%ld",(long)receivedSize , (long)expectedSize);
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                if (image) {
                    [Config shareInstance].settings.avatar = image;
                    [ERPCache storePersonalSettings:[Config shareInstance].settings];
                }
            }];
        }
        [ERPCache storePersonalSettings:[Config shareInstance].settings];
}
//
    
//    [ERPCache storePersonalSettings:[Config shareInstance].settings];
    //    finishSettings = YES;
}
+ (void)addToContact:(BmobObject *)obj {
    Contact *contact = [[Contact alloc]init];
    contact.objectId = obj.objectId;
    contact.username = [obj objectForKey:@"username"];
    contact.nickname = [obj objectForKey:@"name"];
    contact.gender = [obj objectForKey:@"gender"];
    contact.position = [obj objectForKey:@"userPosition"];
    contact.email = [obj objectForKey:@"email"];
    NSString *serverAvatarURL = [obj objectForKey:@"avatar"];
    
    if (!serverAvatarURL || serverAvatarURL.length == 0) {
        contact.avatarURL = @"";
    } else {
        if (![contact.avatarURL isEqualToString:serverAvatarURL]) {
            contact.avatarURL = serverAvatarURL;
            
            SDWebImageDownloader *imageDownloader = [SDWebImageDownloader sharedDownloader];
            NSURL *url = [NSURL URLWithString: contact.avatarURL];
            [imageDownloader downloadImageWithURL:url options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"下载头像图片进度哈哈哈哈： %ld/%ld",receivedSize , expectedSize);
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image) {
                    contact.avatar = image;
                    NSLog(@"%@",contact.avatar);
                    [ERPCache storeContact:contact];
                }
            }];
        }
    }
    [ERPCache storeContact:contact];
}


@end
