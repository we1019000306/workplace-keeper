//
//  MainNewsTableViewCell.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/22.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MYNewsHeaderView.h"
#import "SubNewsTableViewCell.h"
#import "News.h"
typedef void (^PushHeaderWithURLBlock)(NSString *title,NSString *content,NSString *imageURL);
typedef void (^PushCellWithURLBlock)(NSString *title,NSString *content,NSString *imageURL);


@interface MainNewsTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) News *contentNews;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (strong, nonatomic) MYNewsHeaderView *headerView;
@property (nonatomic, copy) PushHeaderWithURLBlock pushHeaderBlock;
@property (nonatomic, copy) PushCellWithURLBlock pushCellBlock;

- (void)pushHeaderVc:(PushHeaderWithURLBlock)headerblock;
- (void)pushCellVc:(PushHeaderWithURLBlock)cellblock;



+ (MainNewsTableViewCell *)cellView:(News *)news;


@end
