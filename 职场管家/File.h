//
//  File.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/30.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

@class File;
@interface File : ModelBase
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *pathExtension;//文件类型
@property (nonatomic,strong) NSString *uploadTime;//上传时间
@property (nonatomic,strong) NSString *downloadTime;//下载时间
@property (nonatomic,strong) NSURL *fileURL;
@end
