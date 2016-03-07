//
//  Settings.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/18.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ModelBase.h"

@interface Settings : ModelBase <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *gender; //性别：1男 0女
@property (nonatomic, strong) UIImage  *avatar;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *position;


@end
