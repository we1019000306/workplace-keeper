//
//  Contact.m
//  职场管家
//
//  Created by Jackie Liu on 16/2/15.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "Contact.h"
NSString *const kContact_ObjectId = @"objectId";
NSString *const kContact_NickName = @"nickname";
NSString *const kContact_Gender = @"gender";
NSString *const kContact_Avatar = @"avatar";
NSString *const kContact_AvatarURL = @"avatarURL";
NSString *const kContact_UserName = @"username";
NSString *const kContact_Position = @"position";
NSString *const kContact_Email = @"email";


@implementation Contact
@synthesize objectId = _objectId;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize avatar = _avatar;
@synthesize avatarURL = _avatarURL;
@synthesize username = _username;
@synthesize position = _position;
@synthesize email = _email;
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.objectId = [dict objectOrNilForKey:kContact_ObjectId];
        self.nickname = [dict objectOrNilForKey:kContact_NickName];
        self.gender = [dict objectOrNilForKey:kContact_Gender];
        self.avatar = [dict objectOrNilForKey:kContact_Avatar];
        self.avatarURL = [dict objectOrNilForKey:kContact_AvatarURL];
        self.username = [dict objectOrNilForKey:kContact_UserName];
        self.position = [dict objectOrNilForKey:kContact_Position];
        self.email = [dict objectOrNilForKey:kContact_Email];

    }
    
    return self;
    
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.objectId = [aDecoder decodeObjectForKey:kContact_ObjectId];
    self.nickname = [aDecoder decodeObjectForKey:kContact_NickName];
    self.gender = [aDecoder decodeObjectForKey:kContact_Gender];
    self.avatar = [aDecoder decodeObjectForKey:kContact_Avatar];
    self.avatarURL = [aDecoder decodeObjectForKey:kContact_AvatarURL];
    self.username = [aDecoder decodeObjectForKey:kContact_UserName];
    self.position = [aDecoder decodeObjectForKey:kContact_Position];
    self.email = [aDecoder decodeObjectForKey:kContact_Email];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_objectId forKey:kContact_ObjectId];
    [aCoder encodeObject:_nickname forKey:kContact_NickName];
    [aCoder encodeObject:_gender forKey:kContact_Gender];
    [aCoder encodeObject:_avatar forKey:kContact_Avatar];
    [aCoder encodeObject:_avatarURL forKey:kContact_AvatarURL];
    [aCoder encodeObject:_username forKey:kContact_UserName];
    [aCoder encodeObject:_position forKey:kContact_Position];
    [aCoder encodeObject:_email forKey:kContact_Email];

}

- (id)copyWithZone:(NSZone *)zone {
    Contact *contact = [[Contact alloc] init];
    contact.objectId = [self.objectId copyWithZone:zone];
    contact.nickname = [self.nickname copyWithZone:zone];
    contact.gender = [self.gender copyWithZone:zone];
    contact.avatar = self.avatar;
    contact.avatarURL = [self.avatarURL copyWithZone:zone];
    contact.username = [self.username copyWithZone:zone];
    contact.position = [self.position copyWithZone:zone];
    contact.email = [self.email copyWithZone:zone];
    return contact;
}

@end
