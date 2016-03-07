//
//  TaskResultTableViewCell.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/27.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//


#import "MYTaskResultTableViewCell.h"
#import "Task.h"
@implementation MYTaskResultTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    MYTaskResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        // NSLog(@"加载XIB");
        // 从XIB加载自定义视图
        cell = [[MYTaskResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    WS(ws);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:20.0f];
        self.nameLabel.text = @"name";
        
        [self.contentView addSubview:self.nameLabel];
        
        self.resultImgView = [[UIImageView alloc] init];

        [self.resultImgView setImage:[UIImage imageNamed:@"unsignin"]];
        
        [self.contentView addSubview:self.resultImgView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ws.bounds.size.width/4, 32));
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(ws.mas_top).with.offset(14);
        }];
        [self.resultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(ws.nameLabel.mas_centerY);
        }];
    }
    return self;
}
-(void)setTask:(Task *)task
{
    _task = task;
    self.nameLabel.text = task.TaskName;
    if ([task.TaskResult isEqualToNumber:@1]) {
        [self.resultImgView setImage:[UIImage imageNamed:@"signin"]];
    }else{
        [self.resultImgView setImage:[UIImage imageNamed:@"unsignin"]];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
