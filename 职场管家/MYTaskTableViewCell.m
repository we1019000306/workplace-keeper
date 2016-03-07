//
//  TaskTableViewCell.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/22.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MYTaskTableViewCell.h"
#import "Task.h"
@implementation MYTaskTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    MYTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        // NSLog(@"加载XIB");
        // 从XIB加载自定义视图
        cell = [[MYTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:10.0f];
        self.nameLabel.text = @"name";
        [self.contentView addSubview:self.nameLabel];
        
        self.areaLabel = [[UILabel alloc] init];
        self.areaLabel.font = [UIFont systemFontOfSize:10.0f];
        self.areaLabel.text = @"area";
        [self.contentView addSubview:self.areaLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.text = @"泰国";
        [self.contentView addSubview:self.timeLabel];
  
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.size.mas_equalTo(CGSizeMake(120, 40));
            make.right.mas_equalTo(-15);
        }];

     
    }
    return self;
}
-(void)setTask:(Task *)task
{
    _task = task;
    self.nameLabel.text = task.TaskName;
    self.areaLabel.text = task.TaskArea;
    self.timeLabel.text = task.LastTime;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
