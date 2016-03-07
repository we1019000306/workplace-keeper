//
//  MainNewsTableViewCell.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MainNewsTableViewCell.h"
#import "SubNewsTableViewCell.h"
#import "MYNewsWebViewController.h"
#import "MYNewsHeaderView.h"
@interface MainNewsTableViewCell()
@end
@implementation MainNewsTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (MainNewsTableViewCell *)cellView:(News *)news {
  MainNewsTableViewCell *cellView = [[NSBundle mainBundle] loadNibNamed:@"MainNewsTableViewCell" owner:self options:nil].lastObject;
    cellView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 510);
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.contentNews = news;
    cellView.subTableView.delegate = cellView;
    cellView.subTableView.dataSource = cellView;
    cellView.subTableView.scrollEnabled = NO;
    cellView.subTableView.tableHeaderView = [[MYNewsHeaderView alloc]init];
    cellView.subTableView.tableFooterView = [[UIView alloc] init];
    return cellView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentNews.subNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubNewsTableViewCell *subcell = [SubNewsTableViewCell cellView];
    if (self.contentNews.subNews.count > indexPath.row) {
        subcell.news = (News *)[self.contentNews.subNews objectAtIndex:indexPath.row];
    }
    return subcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pushCellBlock != nil) {
        News *news = self.contentNews.subNews[indexPath.row];
        NSString *title = news.newstitle;
        NSString *content = news.newscontent;
        NSString *imgURL = news.newsimageurl;
        self.pushCellBlock(title,content,imgURL);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
   self.headerView = [MYNewsHeaderView headerViewWithTableView:tableView];
    //存储组
    self.headerView.tag = section;
    
    
    self.headerView.news = self.contentNews;
    
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewButtonDidClick)];
    
    [self.headerView addGestureRecognizer:tapGeture];
    return self.headerView;

}

-(void)headerViewButtonDidClick{
    if (self.pushHeaderBlock != nil) {
        NSString *title = self.contentNews.newstitle;
        NSString *content = self.contentNews.newscontent;
        NSString *imgURL = self.contentNews.newsimageurl;
        self.pushHeaderBlock(title,content,imgURL);
    }
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }  
}

-(void)pushHeaderVc:(PushHeaderWithURLBlock)headerblock{
    self.pushHeaderBlock = headerblock;
}
-(void)pushCellVc:(PushHeaderWithURLBlock)cellblock{
    self.pushCellBlock = cellblock;
}

@end
