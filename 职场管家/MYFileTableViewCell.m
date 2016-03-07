//
//  MYFileTableViewCell.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/30.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MYFileTableViewCell.h"
#import "File.h"
@implementation MYFileTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 可重用标示符
    static NSString *ID = @"Cell";
    // 2. tableView查询可重用Cell
    MYFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        // NSLog(@"加载XIB");
        // 从XIB加载自定义视图
        cell = [[MYFileTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.text = @"filename";
        self.imageView.image = [UIImage imageNamed:@"myava.jpg"];
    }
    return self;
}


-(void)setFile:(File *)file{
    _file = file;
    self.detailTextLabel.text = file.fileName;
    if ([file.pathExtension isEqualToString:@"docx"]||[file.pathExtension isEqualToString:@"doc"]) {
        self.imageView.image = [UIImage imageNamed:@"doc.jpeg"];
    }
    if([file.pathExtension isEqualToString:@"xls"]||[file.pathExtension isEqualToString:@"xlsx"]){
        self.imageView.image = [UIImage imageNamed:@"xls.jpg"];
    }
    if([file.pathExtension isEqualToString:@"pdf"]){
        self.imageView.image = [UIImage imageNamed:@"pdf.jpg"];
    }
}
@end
