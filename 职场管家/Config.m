//
//  Config.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/19.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "Config.h"

static Config *instance = nil;

@implementation Config

+ (Config *)shareInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[[self class] hideAlloc] init];
        }
    }
    return instance;
}

+ (id)hideAlloc {
    return [super alloc];
}

+ (id)alloc {
    return nil;
}

+ (id)new {
    return [self alloc];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

@end
