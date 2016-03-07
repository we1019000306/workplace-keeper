//
//  MYAnnouncementViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/13.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import "MYNewsViewController.h"
#import "News.h"
#import "MainNewsTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "Masonry.h"
#import "MJRefresh.h"
#import "MYNewsWebViewController.h"
#import "MYAnnouncementViewController.h"
#pragma mark - 侧拉头文件
#import "RESideMenu.h"
#import "SideMenuViewController.h"
#import "UIButton+Util.h"
#import "UIViewController+Util.h"
@interface MYNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *newsTableView;
@property (strong, nonatomic) NSMutableArray *newses;

@end

@implementation MYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBarButton];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.newsTableView.dataSource = self;
    self.newsTableView.delegate = self;
    self.newsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newses = [[NSMutableArray alloc] initWithCapacity:1];
    [self Refresh];
    [self pullRefresh];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.newses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.newses.count > indexPath.section) {
        MainNewsTableViewCell *cell = [MainNewsTableViewCell cellView:self.newses[indexPath.section]];
        [cell pushHeaderVc:^(NSString *title, NSString *content, NSString *imageURL) {
            MYAnnouncementViewController *headerVc = [[MYAnnouncementViewController alloc]init];
            [headerVc loadNewsWithTitle:title Content:content imgURL:imageURL];
            [self.navigationController pushViewController:headerVc animated:YES];

        }];
        [cell pushCellVc:^(NSString *title, NSString *content, NSString *imageURL) {
            MYAnnouncementViewController *cellVc = [[MYAnnouncementViewController alloc]init];
            [cellVc loadNewsWithTitle:title Content:content imgURL:imageURL];
            [self.navigationController pushViewController:cellVc animated:YES];

        }];

        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 495;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    if (self.newses.count > section) {
        News *sub = self.newses[section];
        label.text = sub.newscreatetime;
    }
    
    
    [view addSubview:label];
    
    
    
    return view;
}

-(UITableView *)newsTableView{
    if (!_newsTableView) {
        _newsTableView = [[UITableView alloc]init];
        _newsTableView.allowsMultipleSelection = NO;
        _newsTableView.allowsSelection = NO;
        _newsTableView.userInteractionEnabled = YES;
        [self.view addSubview:_newsTableView];
        WS(ws);
        [_newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(-20);
            make.bottom.mas_equalTo(ws.view.mas_bottom).with.offset(-44);
        }];
    }
    return _newsTableView;
}


/**
 *  下拉刷新
 */
- (void)Refresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.newsTableView.mj_header beginRefreshing];
}
-(void)loadNewData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"News"];
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;
    query.limit = 3;
    [query orderByDescending:@"newsId"];
//    [query orderByAscending:@"newsId"];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:array.count forKey:@"count"];
        [self.newses removeAllObjects];
        for (BmobObject *obj in array) {
            
            News *n = [[News alloc]init];
            n.subNews = [[NSMutableArray alloc]initWithCapacity:1];
            n.newstitle = [[obj objectForKey:@"HeaderNews"] objectAtIndex:0];
            n.newsimageurl = [[obj objectForKey:@"HeaderNews"] objectAtIndex:1];
            n.newscontent = [[obj objectForKey:@"HeaderNews"] objectAtIndex:2];
            n.newscreatetime = [obj objectForKey:@"NewsCreatTime"];
            News *subN1 = [[News alloc]init];
            subN1.newstitle = [[obj objectForKey:@"CellOne"] objectAtIndex:0];
            subN1.newsimageurl = [[obj objectForKey:@"CellOne"] objectAtIndex:1];
            subN1.newscontent = [[obj objectForKey:@"CellOne"] objectAtIndex:2];
            News *subN2 = [[News alloc]init];
            subN2.newstitle = [[obj objectForKey:@"CellTwo"] objectAtIndex:0];
            subN2.newsimageurl = [[obj objectForKey:@"CellTwo"] objectAtIndex:1];
            subN2.newscontent = [[obj objectForKey:@"CellTwo"] objectAtIndex:2];
            News *subN3 = [[News alloc]init];
            subN3.newstitle = [[obj objectForKey:@"CellThree"] objectAtIndex:0];
            subN3.newsimageurl = [[obj objectForKey:@"CellThree"] objectAtIndex:1];
            subN3.newscontent = [[obj objectForKey:@"CellThree"] objectAtIndex:2];
            [n.subNews addObject:subN1];
            [n.subNews addObject:subN2];
            [n.subNews addObject:subN3];
            [self.newses addObject:n];
            
            
        }
      
        [self.newsTableView reloadData];
        
        if (array.count == 3) {
            
            [self.newsTableView.mj_footer resetNoMoreData];
            
        }

    }];
    [self.newsTableView.mj_header endRefreshing];
    
    
}


/**
 *  上拉加载更多
 */
- (void)pullRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreData];
    }];
    
    //进入刷新状态
    [self.newsTableView.mj_footer beginRefreshing];
}

- (void)loadMoreData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"News"];
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;
    query.skip = 3;
    query.limit = 3;
    [query orderByDescending:@"newsId"];
//    [query orderByAscending:@"newsId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    

        for (BmobObject *obj in array) {
            
            News *n = [[News alloc]init];
            n.subNews = [[NSMutableArray alloc]initWithCapacity:1];
            n.newstitle = [[obj objectForKey:@"HeaderNews"] objectAtIndex:0];
            n.newsimageurl = [[obj objectForKey:@"HeaderNews"] objectAtIndex:1];
            n.newscontent = [[obj objectForKey:@"HeaderNews"] objectAtIndex:2];
            n.newscreatetime = [obj objectForKey:@"NewsCreatTime"];
            News *subN1 = [[News alloc]init];
            subN1.newstitle = [[obj objectForKey:@"CellOne"] objectAtIndex:0];
            subN1.newsimageurl = [[obj objectForKey:@"CellOne"] objectAtIndex:1];
            subN1.newscontent = [[obj objectForKey:@"CellOne"] objectAtIndex:2];
            News *subN2 = [[News alloc]init];
            subN2.newstitle = [[obj objectForKey:@"CellTwo"] objectAtIndex:0];
            subN2.newsimageurl = [[obj objectForKey:@"CellTwo"] objectAtIndex:1];
            subN2.newscontent = [[obj objectForKey:@"CellTwo"] objectAtIndex:2];
            News *subN3 = [[News alloc]init];
            subN3.newstitle = [[obj objectForKey:@"CellThree"] objectAtIndex:0];
            subN3.newsimageurl = [[obj objectForKey:@"CellThree"] objectAtIndex:1];
            subN3.newscontent = [[obj objectForKey:@"CellThree"] objectAtIndex:2];
            [n.subNews addObject:subN1];
            [n.subNews addObject:subN2];
            [n.subNews addObject:subN3];
            [self.newses addObject:n];
            
            
        }
        
        [self.newsTableView reloadData];
        
        [self.newsTableView.mj_footer endRefreshingWithNoMoreData];


    }];
    
    
    
    
    //声明该次查询需要将author关联对象信息一并查询出来
    //结束刷新
    
}





- (void)createNavBarButton {
    self.leftBarButtonItem = [self createBarButtonItemWithNormalImageName:png_Btn_LeftMenu selectedImageName:png_Btn_LeftMenu selector:@selector(leftMenuAction:)];
}

- (void)leftMenuAction:(UIButton *)button {
    [self.sideMenuViewController presentLeftMenuViewController];
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
