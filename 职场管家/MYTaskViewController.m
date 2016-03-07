//
//  MYTaskViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/13.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MYTaskViewController.h"
#import "MYTaskTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "Task.h"
#import "MJRefresh.h"
#import "MYLocationViewController.h"
#import "MYTaskResultTableViewController.h"
#pragma mark - 侧拉头文件
#import "RESideMenu.h"
#import "SideMenuViewController.h"
#import "UIButton+Util.h"
#import "UIViewController+Util.h"
@interface MYTaskViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dts;
    UITableView *_infoTableView;
}

@end

@implementation MYTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    [self createNavBarButton];
//出差表
    _infoTableView = [[UITableView alloc]init];
    _infoTableView.dataSource     = self;
    _infoTableView.delegate       = self;
    if ([_infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_infoTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_infoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_infoTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:_infoTableView];
//签到按钮
    UIButton *qdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qdBtn setBackgroundImage:[UIImage imageNamed:@"hetong@3x"] forState:UIControlStateNormal];
    [qdBtn addTarget:self action:@selector(Locate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qdBtn];
    
    [_infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.mas_equalTo(-0);
        make.top.mas_equalTo(ws.view.mas_top);
        make.bottom.mas_equalTo(qdBtn.mas_top).with.offset(-20);
    }];
    [qdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(ws.view.mas_bottom).with.offset(-70);
    }];
    _dts = [[NSMutableArray alloc] initWithCapacity:1];
    [self pullDownRefresh];
    [self pullRefresh];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        return [_dts count];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYTaskTableViewCell *cell = [MYTaskTableViewCell cellWithTableView:tableView];
    cell.task = (Task *)[_dts objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

#pragma mark - 修改表格分割线宽度为整个屏幕
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
/**
 *  下拉刷新
 */
- (void)pullDownRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _infoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadNewData];
        
    }];
    
    // 马上进入刷新状态
    [_infoTableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Task"];
    query.limit = 20;
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;

    //    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [_dts removeAllObjects];
        for (BmobObject *obj in array) {
            Task *task    = [[Task alloc] init];
            if ([obj objectForKey:@"TaskName"]) {
                task.TaskName = [obj objectForKey:@"TaskName"];
            }
            if ([obj objectForKey:@"TaskArea"]) {
                task.TaskArea = [obj objectForKey:@"TaskArea"];
            }
            if ([obj objectForKey:@"LastTime"]) {
                task.LastTime = [obj objectForKey:@"LastTime"];
            }
            [_dts addObject:task];
        }
        
        [_infoTableView reloadData];
        if (array.count == 20) {
            
            [_infoTableView.mj_footer resetNoMoreData];
            
        }

        
    }];

    
    
    //声明该次查询需要将author关联对象信息一并查询出来
    //结束刷新
    [_infoTableView.mj_header endRefreshing];

}

/**
 *  上拉加载更多
 */
- (void)pullRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _infoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreData];
    }];
    
    //进入刷新状态
    [_infoTableView.mj_footer beginRefreshing];
}
/**
 *  上拉加载更多
 */
-(void)loadMoreData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Task"];
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;
    query.limit = 20;
    query.skip = 20;
    
    //    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            Task *task    = [[Task alloc] init];
            if ([obj objectForKey:@"TaskName"]) {
                task.TaskName = [obj objectForKey:@"TaskName"];
            }
            if ([obj objectForKey:@"TaskArea"]) {
                task.TaskArea = [obj objectForKey:@"TaskArea"];
            }
            if ([obj objectForKey:@"LastTime"]) {
                task.LastTime = [obj objectForKey:@"LastTime"];
            }
            [_dts addObject:task];

            
        }
        [_infoTableView reloadData];

        if (array.count < 20) {
            [_infoTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];

    //结束刷新
    [_infoTableView.mj_footer endRefreshing];
    
}

-(void)Locate{
    Config *config = [Config shareInstance];
    NSLog(@"%@",config.settings.objectId);
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Task"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"identityID"] isEqualToString:config.settings.objectId]) {
                MYLocationViewController *MYlocateVC = [[MYLocationViewController alloc]init];
                [self.navigationController pushViewController:MYlocateVC animated:YES];
                return;
            }
        }
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"无记录" message:@"出差列表里没有您！！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            [self.view addSubview:alertView];
            
        

    }];
}


- (void)createNavBarButton {
    self.leftBarButtonItem = [self createBarButtonItemWithNormalImageName:png_Btn_LeftMenu selectedImageName:png_Btn_LeftMenu selector:@selector(leftMenuAction:)];
     self.rightBarButtonItem = [self createBarButtonItemWithNormalImageName:@"icon_taskresult" selectedImageName:png_Btn_LeftMenu selector:@selector(taskResult)];
}

- (void)leftMenuAction:(UIButton *)button {
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)taskResult{
        MYTaskResultTableViewController *resultVC = [[MYTaskResultTableViewController alloc]init];
        [self.navigationController pushViewController:resultVC animated:YES];
}
- (UIBarButtonItem *)createBarButtonItemWithNormalImageName:(NSString *)normalImageName selectedImageName:(NSString*)selectedImageName selector:(SEL)selector {
    
    UIImage *imageNormal = [UIImage imageNamed:normalImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, imageNormal.size.width + 20, imageNormal.size.height);
    [button setAllImage:imageNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
