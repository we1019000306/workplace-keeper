//
//  Settings.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/18.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//
#import "Settings.h"

NSString *const kSettings_ObjectId = @"objectId";
NSString *const kSettings_NickName = @"nickname";
NSString *const kSettings_Email = @"email";
NSString *const kSettings_Gender = @"gender";
NSString *const kSettings_Avatar = @"avatar";
NSString *const kSettings_AvatarURL = @"avatarURL";
NSString *const kSettings_Position= @"position";
@implementation Settings

@synthesize objectId = _objectId;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize avatar = _avatar;
@synthesize avatarURL = _avatarURL;
@synthesize position = _position;
@synthesize email = _email;

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.objectId = [dict objectOrNilForKey:kSettings_ObjectId];
        self.nickname = [dict objectOrNilForKey:kSettings_NickName];
        self.email = [dict objectOrNilForKey:kSettings_Email];
        self.gender = [dict objectOrNilForKey:kSettings_Gender];
        self.avatar = [dict objectOrNilForKey:kSettings_Avatar];
        self.avatarURL = [dict objectOrNilForKey:kSettings_AvatarURL];
        self.position = [dict objectOrNilForKey:kSettings_Position];

    }
    
    return self;
    
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.objectId = [aDecoder decodeObjectForKey:kSettings_ObjectId];
    self.nickname = [aDecoder decodeObjectForKey:kSettings_NickName];
    self.email = [aDecoder decodeObjectForKey:kSettings_Email];
    self.gender = [aDecoder decodeObjectForKey:kSettings_Gender];
    self.avatar = [aDecoder decodeObjectForKey:kSettings_Avatar];
    self.avatarURL = [aDecoder decodeObjectForKey:kSettings_AvatarURL];
    self.position = [aDecoder decodeObjectForKey:kSettings_Position];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_objectId forKey:kSettings_ObjectId];
    [aCoder encodeObject:_nickname forKey:kSettings_NickName];
    [aCoder encodeObject:_email forKey:kSettings_Email];
    [aCoder encodeObject:_gender forKey:kSettings_Gender];
    [aCoder encodeObject:_avatar forKey:kSettings_Avatar];
    [aCoder encodeObject:_avatarURL forKey:kSettings_AvatarURL];
    [aCoder encodeObject:_position forKey:kSettings_Position];

}

- (id)copyWithZone:(NSZone *)zone {
    Settings *copy = [[Settings alloc] init];
    copy.objectId = [self.objectId copyWithZone:zone];
    copy.nickname = [self.nickname copyWithZone:zone];
    copy.email = [self.email copyWithZone:zone];
    copy.gender = [self.gender copyWithZone:zone];
    copy.avatar = self.avatar;
    copy.avatarURL = [self.avatarURL copyWithZone:zone];
    copy.position = [self.position copyWithZone:zone];
    
    return copy;
}

@end
