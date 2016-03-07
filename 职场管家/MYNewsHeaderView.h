//
//  MYNewsHeaderView.h
//  职场管家
//
//  Created by Jackie Liu on 16/2/9.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

@class News;
@class MYNewsHeaderView;
//@protocol MYHeaderViewDelegate <NSObject>

//- (void)headerViewButtonDidClick:(MYNewsHeaderView *)headerView;

//@end
@interface MYNewsHeaderView : UITableViewHeaderFooterView

//返回一个headerView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) News *news;

//headerView的代理属性
//@property (weak, nonatomic) id<MYHeaderViewDelegate> delegate;
@end
