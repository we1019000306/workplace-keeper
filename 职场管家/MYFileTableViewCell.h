//
//  MYFileTableViewCell.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/30.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

@class File;
@interface MYFileTableViewCell : UITableViewCell
@property (nonatomic,strong) File *file;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
