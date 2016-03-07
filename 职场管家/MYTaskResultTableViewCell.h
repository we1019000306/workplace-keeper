//
//  TaskResultTableViewCell.h
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/27.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

@class Task;
@interface MYTaskResultTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *resultImgView;
@property (nonatomic,strong) Task *task;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
