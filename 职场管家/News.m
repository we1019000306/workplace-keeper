//
//  News.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "News.h"

NSString *const kNews_NewsId = @"newsid";
NSString *const kNews_Title = @"newstitle";
NSString *const kNews_WebViewUrl = @"webviewurl";
NSString *const kNews_NewsImageUrl = @"newsimageurl";
NSString *const kNews_NewsImage = @"newsimage";
NSString *const kNews_NewsCreateTime = @"newscreatetime";
NSString *const kNews_NewsContent = @"newscontent";

@implementation News

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.newsid = [dict objectOrNilForKey:kNews_NewsId];
        self.newstitle = [dict objectOrNilForKey:kNews_Title];
        self.webviewurl = [dict objectOrNilForKey:kNews_WebViewUrl];
        self.newsimageurl = [dict objectOrNilForKey:kNews_NewsImageUrl];
        self.newsimage = [dict objectOrNilForKey:kNews_NewsImage];
        self.newscreatetime = [dict objectOrNilForKey:kNews_NewsCreateTime];
        self.newscontent = [dict objectOrNilForKey:kNews_NewsContent];

    }
    return self;
}

#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.newsid = [aDecoder decodeObjectForKey:kNews_NewsId];
    self.newstitle = [aDecoder decodeObjectForKey:kNews_Title];
    self.webviewurl = [aDecoder decodeObjectForKey:kNews_WebViewUrl];
    self.newsimageurl = [aDecoder decodeObjectForKey:kNews_NewsImageUrl];
    self.newsimage = [aDecoder decodeObjectForKey:kNews_NewsImage];
    self.newscreatetime = [aDecoder decodeObjectForKey:kNews_NewsCreateTime];
    self.newscontent = [aDecoder decodeObjectForKey:kNews_NewsContent];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_newsid forKey:kNews_NewsId];
    [aCoder encodeObject:_newstitle forKey:kNews_Title];
    [aCoder encodeObject:_webviewurl forKey:kNews_WebViewUrl];
    [aCoder encodeObject:_newsimageurl forKey:kNews_NewsImageUrl];
    [aCoder encodeObject:_newsimage forKey:kNews_NewsImage];
    [aCoder encodeObject:_newscreatetime forKey:kNews_NewsCreateTime];
    [aCoder encodeObject:_newscontent forKey:kNews_NewsContent];


}

- (id)copyWithZone:(NSZone *)zone {
    News *copy = [[News alloc] init];
    copy.newsid = [self.newsid copyWithZone:zone];
    copy.newstitle = [self.newstitle copyWithZone:zone];
    copy.webviewurl = [self.webviewurl copyWithZone:zone];
    copy.newsimageurl = [self.newsimageurl copyWithZone:zone];
    copy.newsimage = self.newsimage;
    copy.newscreatetime = [self.newscreatetime copyWithZone:zone];
    copy.newscontent = [self.newscontent copyWithZone:zone];

    return copy;
}

@end
