//
//  Task.h
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/22.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import <BmobSDK/Bmob.h>
@interface Task : ModelBase
@property(nonatomic,copy) NSString *TaskName;
@property(nonatomic,copy) NSString *TaskArea;
@property(nonatomic,copy) NSString *LastTime;
@property(nonatomic,assign) NSNumber *TaskResult;

@end
