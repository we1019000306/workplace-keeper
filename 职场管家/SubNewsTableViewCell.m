//
//  SubNewsTableViewCell.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "SubNewsTableViewCell.h"
#import "News.h"
@implementation SubNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SubNewsTableViewCell *)cellView {
    SubNewsTableViewCell *cellView = [[NSBundle mainBundle] loadNibNamed:@"SubNewsTableViewCell" owner:self options:nil].firstObject;
    cellView.titleLabel.numberOfLines = 0;
    cellView.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    return cellView;
}

-(void)setNews:(News *)news{
    _news = news;
    self.titleLabel.text = news.newstitle;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:news.newsimageurl] placeholderImage:[UIImage imageNamed:@"ZhiGuan.png"]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}

@end
