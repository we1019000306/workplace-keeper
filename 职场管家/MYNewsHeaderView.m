//
//  MYNewsHeaderView.m
//  职场管家
//
//  Created by Jackie Liu on 16/2/9.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MYNewsHeaderView.h"
#import "News.h"
@interface MYNewsHeaderView()
@property(nonatomic, weak) UIImageView *titleImgView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIImageView *lineImgView;
@end
@implementation MYNewsHeaderView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *headerID = @"headerView";
    
    MYNewsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    if (headerView == nil) {
        headerView = [[MYNewsHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        //图像
        UIImageView *titleImgView = [[UIImageView alloc] init];
        titleImgView.backgroundColor = [UIColor clearColor];
        titleImgView.clipsToBounds = YES;
        titleImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:titleImgView];
        self.titleImgView = titleImgView;
        
        UIImageView  *lineImgView = [[UIImageView alloc]init];
        lineImgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineImgView];
        self.lineImgView = lineImgView;
        UILabel  *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor blackColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentNatural;
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
       

        
    }
    return self;
}
-(void)setNews:(News *)news{
    _news = news;
    [self.titleImgView sd_setImageWithURL:[NSURL URLWithString:news.newsimageurl] placeholderImage:[UIImage imageNamed:@"ZhiGuan.png"]];
    self.titleLabel.text = news.newstitle;
}
//按钮单击事件
//- (void)headerViewButtonDidClick {
//    if ([self.delegate respondsToSelector:@selector(headerViewButtonDidClick:)]) {
//        [self.delegate headerViewButtonDidClick:self];
//    }
//}

-(void)layoutSubviews{
    [super layoutSubviews];
     CGFloat width  =  [[UIScreen mainScreen] bounds].size.width;
    self.frame = CGRectMake(0, 0,width, 190);
    self.titleImgView.frame = CGRectMake(10, 10,width-55, 190);
    self.lineImgView.frame = CGRectMake(0, 210, width, 1);
    self.titleLabel.frame = CGRectMake(10, self.frame.size.height-30, width-55, 40);
}
@end
