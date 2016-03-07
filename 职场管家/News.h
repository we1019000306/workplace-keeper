//
//  News.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "ModelBase.h"

@interface News :ModelBase <NSCoding,NSCopying>
@property(nonatomic, strong) NSString *newsid;
@property(nonatomic, strong) NSString *newstitle;
@property(nonatomic, strong) NSString *newsimageurl;
@property(nonatomic, strong) UIImage *newsimage;
@property(nonatomic, strong) NSString *newscreatetime;
@property(nonatomic, strong) NSString *webviewurl;
@property(nonatomic, strong) NSMutableArray *subNews;
@property(nonatomic, strong) NSString *newscontent;

@end
