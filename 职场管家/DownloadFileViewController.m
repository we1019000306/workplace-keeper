//
//  DownloadFileViewController.m
//  职场管家
//
//  Created by Jackie Liu on 16/2/6.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "DownloadFileViewController.h"
#import "MYFileTableViewCell.h"
#import "MBProgressHUD+Add.h"
#import <BmobSDK/Bmob.h>
#import "File.h"
#import "MJRefresh/MJRefresh.h"
@interface DownloadFileViewController()<UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic,strong) NSMutableArray *fileArray;
@property(nonatomic,strong) UITableView *fileTableView;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSURLSession *session;


@end

@implementation DownloadFileViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.fileTableView.delegate = self;
    self.fileTableView.dataSource = self;
    [self Refresh];
    [self pullRefresh];
}
-(void)xwPageViewController:(XWPageViewController *)xwPageViewController visibleFrame:(CGRect)visibleFrame{
    self.view.frame = visibleFrame;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MYFileTableViewCell *cell = [MYFileTableViewCell cellWithTableView:tableView];
    cell.file = (File *)[self.fileArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openOrUpLoadFile];
    File *selectFile = [self.fileArray objectAtIndex:indexPath.row];
    NSString *fileName = selectFile.fileName;
    NSString *pathExtension = selectFile.pathExtension;
    NSURL *fileURL = selectFile.fileURL;
    
    NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
    [fileDefaults setObject:fileName forKey:@"filename"];
    [fileDefaults setURL:fileURL forKey:@"fileurl"];
    [fileDefaults setInteger:indexPath.row forKey:@"indexpath"];
    [fileDefaults setObject:pathExtension forKey:@"pathextension"];
    [fileDefaults synchronize];
    
    
}

/**
 *  下拉刷新
 */
- (void)Refresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.fileTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.fileTableView.mj_header beginRefreshing];
}
-(void)loadNewData{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"File"];
    bquery.limit = 20;
    bquery.cachePolicy = kBmobCachePolicyNetworkElseCache;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.fileArray removeAllObjects];
        for (BmobObject *obj in array) {
            File *file = [[File alloc]init];
            NSString *fileURLStr = [obj objectForKey:@"fileURL"];
            file.fileURL = [NSURL URLWithString:fileURLStr];
            file.fileName = [obj objectForKey:@"fileName"];
            file.pathExtension = [obj objectForKey:@"fileType"];
            [self.fileArray addObject:file];
        }
        [self.fileTableView reloadData];
        if (array.count == 20) {
            
            [self.fileTableView.mj_footer resetNoMoreData];
            
        }

    }];
    [self.fileTableView.mj_header endRefreshing];

}

/**
 *  上拉加载更多
 */
- (void)pullRefresh
{
    WS(ws);
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.fileTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreData];
    }];
    
    //进入刷新状态
    [self.fileTableView.mj_footer beginRefreshing];
}

- (void)loadMoreData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"File"];
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;
    query.skip = 20;
    query.limit = 20;
//    [query orderByDescending:@"newsId"];
    //    [query orderByAscending:@"newsId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            File *file = [[File alloc]init];
            NSString *fileURLStr = [obj objectForKey:@"fileURL"];
            file.fileURL = [NSURL URLWithString:fileURLStr];
            file.fileName = [obj objectForKey:@"fileName"];
            file.pathExtension = [obj objectForKey:@"fileType"];
            [self.fileArray addObject:file];
        }
        
        [self.fileTableView reloadData];
        
        [self.fileTableView.mj_footer endRefreshingWithNoMoreData];
        
        
    }];
    
    
    
    
    //声明该次查询需要将author关联对象信息一并查询出来
    //结束刷新
    
}



-(void)openOrUpLoadFile{
    UIAlertController *as = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    UIAlertAction *downLoad = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *fileURL = [fileDefaults URLForKey:@"fileurl"];
        NSLog(@"%@",fileURL);
        [self startWithURL:fileURL];
    }];
    
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [as didMoveToParentViewController:self];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [as didMoveToParentViewController:self];
    }];
    
    [as addAction:downLoad];
    [as addAction:report];
    [as addAction:cancel];
    
    [self presentViewController:as animated:YES completion:nil];
    
}

-(NSMutableArray *)fileArray{
    if (!_fileArray) {
        _fileArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _fileArray;
}

-(UITableView *)fileTableView{
    if (!_fileTableView) {
        WS(ws);
        _fileTableView = [[UITableView alloc]init];
        [self.view addSubview:_fileTableView];
        [_fileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(ws.view.mas_bottom);
        }];
    }
    return _fileTableView;
}
//懒加载
- (NSURLSession *)session
{
    if (!_session) {
        // 获得session
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
- (void)startWithURL:(NSURL *)url
{
    // 1.创建一个下载任务
    self.task = [self.session downloadTaskWithURL:url];
    
    // 2.开始任务
    [self.task resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
     NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
    NSString *FileName = [fileDefaults objectForKey:@"filename"];
    NSString *PathExtension = [fileDefaults objectForKey:@"pathextension"];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [[document stringByAppendingPathComponent:FileName] stringByAppendingPathExtension:PathExtension];
    NSLog(@"%@",file);
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"获得下载进度--%@", [NSThread currentThread]);
    // 获得下载进度
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"正在下载";
//    
//    //设置模式为进度框形的
//    HUD.mode = MBProgressHUDModeDeterminate;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        float progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
//        HUD.progress = progress;
//           } completionBlock:^{
//        [HUD removeFromSuperview];
//        HUD = nil;
//    }];
    UIAlertController *downloadSuccess = [UIAlertController alertControllerWithTitle:@"下载成功" message:@"恭喜您！！文件下载成功" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [downloadSuccess addAction:ok];
    [self presentViewController:downloadSuccess animated:YES completion:nil];

    


}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
@end
