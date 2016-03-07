//
//  TaskTableViewCell.h
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/22.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

@class Task;
@interface MYTaskTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *areaLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) Task *task;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
