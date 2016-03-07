//
//  SubNewsTableViewCell.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

@class News;

@interface SubNewsTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

+ (SubNewsTableViewCell *)cellView;

@property(nonatomic, strong) News *news;
@end
