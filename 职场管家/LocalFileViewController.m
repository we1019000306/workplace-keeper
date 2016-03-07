//
//  FileTableViewController.m
//  职场管家
//
//  Created by Jackie Liu on 16/1/28.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "LocalFileViewController.h"
#import "MYFileTableViewCell.h"
#import "File.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD/MBProgressHUD+MJ.m"
#import "MJRefresh/MJRefresh.h"
@interface LocalFileViewController()<UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic,strong) NSMutableArray *fileArray;
@property(nonatomic,strong) UITableView *fileTableView;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;


@end
@implementation LocalFileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.fileTableView.delegate = self;
    self.fileTableView.dataSource = self;
    [self Refresh];
    
  
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
    NSString *filePath = selectFile.filePath;
    NSString *fileName = selectFile.fileName;
    NSString *pathExtension = selectFile.pathExtension;
    NSURL *fileURL = selectFile.fileURL;

    NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
    [fileDefaults setObject:filePath forKey:@"filepath"];
    [fileDefaults setObject:fileName forKey:@"filename"];
    [fileDefaults setURL:fileURL forKey:@"fileurl"];
    [fileDefaults setInteger:indexPath.row forKey:@"indexpath"];
    [fileDefaults setObject:pathExtension forKey:@"pathextension"];
    [fileDefaults synchronize];
    
    
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSFileManager *manager = [NSFileManager defaultManager];
//    [manager removeItemAtPath:[[self.fileArray objectAtIndex:indexPath.row] filePath]  error:nil];
//    [self.fileArray removeObjectAtIndex:indexPath.row];
//    [self.fileTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//}
-(void)listFilesFromDocumentsFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList =
    [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    [self.fileArray removeAllObjects];
    for (NSInteger i = 0; i<fileList.count ;i++) {
        NSString *pathExtension = [[[fileList objectAtIndex:i] lastPathComponent] pathExtension];
        if ([pathExtension isEqualToString:@"docx"]||[pathExtension isEqualToString:@"doc"]|| [pathExtension isEqualToString:@"xls"]|| [pathExtension isEqualToString:@"xlsx"]||[pathExtension isEqualToString:@"pdf"]) {
            File *file = [[File alloc]init];
            file.pathExtension = pathExtension;
            file.fileName = [[fileList objectAtIndex:i] stringByDeletingPathExtension];
            file.filePath = [documentsDirectory stringByAppendingPathComponent:[fileList objectAtIndex:i]];
            file.fileURL = [NSURL fileURLWithPath:file.filePath];
            [self.fileArray addObject:file];
        }else{
            
        }
    }
        NSString *Inbox = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
        NSArray *fileListInbox = [manager contentsOfDirectoryAtPath:Inbox error:nil];
        for (NSInteger i = 0; i<fileListInbox.count ;i++) {
            NSString *pathExtensionInbox = [[[fileListInbox objectAtIndex:i] lastPathComponent] pathExtension];
            if ([pathExtensionInbox isEqualToString:@"docx"]||[pathExtensionInbox isEqualToString:@"doc"]|| [pathExtensionInbox isEqualToString:@"xls"]|| [pathExtensionInbox isEqualToString:@"xlsx"]||[pathExtensionInbox isEqualToString:@"pdf"]) {
                File *file1 = [[File alloc]init];
                file1.pathExtension = pathExtensionInbox;
                file1.fileName = [[fileListInbox objectAtIndex:i] stringByDeletingPathExtension];
                file1.filePath = [Inbox stringByAppendingPathComponent:[fileListInbox objectAtIndex:i]];
                file1.fileURL = [NSURL fileURLWithPath:file1.filePath];
                [self.fileArray addObject:file1];
            }else{
                
            }
        }
    
    
}

-(void)openOrUpLoadFile{
    UIAlertController *as = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:
                             (UIAlertControllerStyleActionSheet)];
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [fileDefaults URLForKey:@"fileurl"];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        [self.documentInteractionController presentOpenInMenuFromRect:self.view.bounds
                                                               inView:self.view animated:YES];
        [fileDefaults removeObjectForKey:@"fileurl"];
    }];
    UIAlertAction *upload = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在上传";
        
        //设置模式为进度框形的
        HUD.mode = MBProgressHUDModeDeterminate;

        
        NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
        NSString *filePath = [fileDefaults objectForKey:@"filepath"];
        NSString *fileName = [fileDefaults objectForKey:@"filename"];
        NSString *pathExtension = [fileDefaults objectForKey:@"pathextension"];
        BmobObject *obj = [[BmobObject alloc] initWithClassName:@"File"];
        BmobFile *file = [[BmobFile alloc] initWithFilePath:filePath];
    

        [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [obj setObject:file  forKey:fileName];
                [obj saveInBackground];

                
                BmobObject *fileObj = [BmobObject objectWithClassName:@"File"];
                [fileObj setObject:fileName forKey:@"fileName"];
                [fileObj setObject:file.url forKey:@"fileURL"];
                [fileObj setObject:pathExtension forKey:@"fileType"];
                
                [fileObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"file1 url %@",file.url);
                        [HUD showAnimated:YES whileExecutingBlock:^{
                            float progress = 0.0f;
                            while (progress < 1.0f) {
                                progress += 0.01f;
                                HUD.progress = progress;
                                usleep(50000);
                            }
                        } completionBlock:^{  
                            [HUD removeFromSuperview];  
                            HUD = nil;
                            UIAlertController *uploadSuccess = [UIAlertController alertControllerWithTitle:@"上传成功" message:@"恭喜您！！文件上传成功" preferredStyle:(UIAlertControllerStyleAlert)];
                            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            [uploadSuccess addAction:ok];
                            [self presentViewController:uploadSuccess animated:YES completion:nil];
                        }];
                      
                    }
                }];
                [fileDefaults removeObjectForKey:@"filepath"];
                
                
                

            }
            if (error) {
                UIAlertController *uploadFail = [UIAlertController alertControllerWithTitle:@"上传失败" message:@"对不起！！文件上传失败" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [uploadFail addAction:ok];
                [self presentViewController:uploadFail animated:YES completion:nil];
            }
        } withProgressBlock:^(float progress) {
           
            
            NSLog(@"上传进度%.2f",progress);
        }];

    
    }];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该文件？" preferredStyle:(UIAlertControllerStyleAlert)];
        // 创建按钮
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            NSUserDefaults *fileDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger indexPathRow = [fileDefaults integerForKey:@"indexpath"];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:[[self.fileArray objectAtIndex:indexPathRow] filePath]  error:nil];
            [self.fileArray removeObjectAtIndex:indexPathRow];
            
            [self.fileTableView reloadData];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController didMoveToParentViewController:self];
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [as didMoveToParentViewController:self];
    }];

    [as addAction:open];
    [as addAction:upload];
    [as addAction:delete];
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
        _fileTableView = [[UITableView alloc]init];
        [self.view addSubview:_fileTableView];
        [_fileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _fileTableView;
}
-(UIDocumentInteractionController *)documentInteractionController{
    if (!_documentInteractionController) {
        _documentInteractionController = [[UIDocumentInteractionController alloc]init];
    }
    return _documentInteractionController;
}



-(void)reloadFile{
        [self listFilesFromDocumentsFolder];
        [self.fileTableView reloadData];
        [self.fileTableView.mj_header endRefreshing];
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
    [self reloadFile];
}
-(void)viewDidAppear:(BOOL)animated{
    [self reloadFile];
}
@end
