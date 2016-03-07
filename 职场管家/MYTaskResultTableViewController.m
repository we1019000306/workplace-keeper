//
//  TaskResultTableViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/27.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MYTaskResultTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "MJRefresh.h"
#import "Task.h"
#import "MYTaskResultTableViewCell.h"
@interface MYTaskResultTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dts;
    UITableView *_infoTableView;
}

@end

@implementation MYTaskResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到结果";
    WS(ws);
    _infoTableView = [[UITableView alloc]init];
    _dts = [[NSMutableArray alloc] initWithCapacity:1];
    _infoTableView.dataSource     = self;
    _infoTableView.delegate       = self;
    [self.view addSubview:_infoTableView];
    [_infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.view.mas_top);
        make.bottom.mas_equalTo(ws.view.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self pullDownRefresh];
    [self pullRefresh];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYTaskResultTableViewCell *cell = [MYTaskResultTableViewCell cellWithTableView:tableView];
    cell.task = (Task *)[_dts objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}/**
 *  下拉刷新
 */
- (void)pullDownRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _infoTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadNewData];
        
    }];
    
    // 马上进入刷新状态
    [_infoTableView.header beginRefreshing];
}
- (void)loadNewData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Task"];
    query.limit = 20;
    [query orderByDescending:@"updatedAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [_dts removeAllObjects];
        for (BmobObject *obj in array) {
            Task *task    = [[Task alloc] init];
            if ([obj objectForKey:@"TaskName"]) {
                task.TaskName = [obj objectForKey:@"TaskName"];
            }
            if ([obj objectForKey:@"DidSign_in"]) {
                task.TaskResult = [NSNumber numberWithBool:[obj objectForKey:@"DidSign_in"]] ;
            }
           
            [_dts addObject:task];
        }
        
        [_infoTableView reloadData];
        if (array.count == 20) {
            
            [_infoTableView.footer resetNoMoreData];
            
        }
        
        
    }];
    
    
    
    //声明该次查询需要将author关联对象信息一并查询出来
    //结束刷新
    [_infoTableView.header endRefreshing];
    
}

/**
 *  上拉加载更多
 */
- (void)pullRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _infoTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreData];
    }];
    
    //进入刷新状态
    [_infoTableView.footer beginRefreshing];
}
/**
 *  上拉加载更多
 */
-(void)loadMoreData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Task"];
    query.limit = 20;
    query.skip = 20;
        [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            Task *task    = [[Task alloc] init];
                if ([obj objectForKey:@"TaskName"]) {
                    task.TaskName = [obj objectForKey:@"TaskName"];
                }
                if ([obj objectForKey:@"DidSign_in"]) {
                    task.TaskResult = [NSNumber numberWithBool:[obj objectForKey:@"DidSign_in"]] ;
                }
            [_dts addObject:task];
            
            
        }
        [_infoTableView reloadData];
        
        if (array.count < 20) {
            [_infoTableView.footer noticeNoMoreData];
        }
        
    }];
    
    //结束刷新
    [_infoTableView.footer endRefreshing];
    
}



@end
