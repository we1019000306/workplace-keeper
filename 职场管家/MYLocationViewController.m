//
//  MYLocationViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/24.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MYLocationViewController.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKitViewController.h"
#import "BmobUserForERP.h"
#import "MYTaskViewController.h"
@interface MYLocationViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UITableView *locationTableView;
@property(nonatomic,strong) UIImageView *avatarImageView;
@property(nonatomic ,strong) CLGeocoder *geocoder;
@property(nonatomic,copy) NSString *locateStr;
@property(nonatomic,strong) UILabel *locateLabel;
@property(nonatomic,copy) NSString *nowTimeStr;
@property(nonatomic,strong) UIImageView *taskImageView;
@end

@implementation MYLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    self.locateStr = [[NSString alloc]init];
    self.nowTimeStr = [[NSString alloc]init];
    self.locationTableView.delegate = self;
    self.locationTableView.dataSource = self;
    if ([self.locationTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.locationTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.locationTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.locationTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }

    [self.view addSubview:self.locationTableView];
    [self.locationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(ws.view.mas_top).with.offset(10);
        make.bottom.mas_equalTo(ws.view.mas_bottom);
    }];
    [self viewDidAppear:YES];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString static *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        self.avatarImageView = [[UIImageView alloc] init];
        [self.avatarImageView.layer setMasksToBounds:YES];
        [self.avatarImageView.layer setCornerRadius:60];
        [cell.contentView addSubview:self.avatarImageView];
        self.avatarImageView.tag = 100;
        
        UILabel *nameLabel =[[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:nameLabel];
        nameLabel.tag = 101;

        UILabel *firstLabel = [[UILabel alloc] init];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:firstLabel];
        firstLabel.tag = 102;
        
        UILabel *firstResultLabel = [[UILabel alloc] init];
        firstResultLabel.backgroundColor = [UIColor clearColor];
        firstResultLabel.textAlignment = NSTextAlignmentCenter;
        firstResultLabel.font = [UIFont systemFontOfSize:10.0f];
        [cell.contentView addSubview:firstResultLabel];
        firstResultLabel.tag = 103;
        
        UILabel *secondLabel    = [[UILabel alloc] init];
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        firstResultLabel.font = [UIFont systemFontOfSize:10.0f];
        [cell.contentView addSubview:secondLabel];
        secondLabel.tag = 104;
        
        UILabel *secondResultLabel = [[UILabel alloc]init];
        secondResultLabel.backgroundColor = [UIColor clearColor];
        secondResultLabel.textAlignment = NSTextAlignmentCenter;
        secondResultLabel.font = [UIFont systemFontOfSize:10.0f];
        [cell.contentView addSubview:secondResultLabel];
        secondResultLabel.tag = 105;
        
        self.taskImageView = [[UIImageView alloc] init];
//        [self.taskImageView setImage:[UIImage imageNamed:@"myava.jpg"]];
        [cell.contentView addSubview:self.taskImageView];
        self.taskImageView.tag = 106;

        UIButton *qiandaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [qiandaoBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn1@2x"] forState:UIControlStateNormal];
        [qiandaoBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn2@2x"] forState:UIControlStateHighlighted];
        [qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
        [qiandaoBtn setTitle:@"签到" forState:UIControlStateHighlighted];
        [qiandaoBtn addTarget:self action:@selector(SignIn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:qiandaoBtn];
        qiandaoBtn.tag = 107;
        self.locateLabel = [[UILabel alloc]init];
        self.locateLabel.backgroundColor = [UIColor clearColor];
        self.locateLabel.textAlignment = NSTextAlignmentCenter;
        self.locateLabel.font = [UIFont systemFontOfSize:8.0f];
        self.locateLabel.text = self.locateStr;
        [cell.contentView addSubview:self.locateLabel];
        self.locateLabel.tag = 108;
        
        }
        self.avatarImageView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *firstLabel = (UILabel *)[cell.contentView viewWithTag:102];
        UILabel *firstResultLabel = (UILabel *)[cell.contentView viewWithTag:103];
        UILabel *secondLabel = (UILabel *)[cell.contentView viewWithTag:104];
        UILabel *secondResultLabel = (UILabel *)[cell.contentView viewWithTag:105];
        UIImageView    *taskImageView = (UIImageView *)[cell.contentView viewWithTag:106];
        UIButton *qiandaoBtn = (UIButton *)[cell.contentView viewWithTag:107];
        UILabel *locateLabel = (UILabel *)[cell.contentView viewWithTag:108];
    

        switch (indexPath.row) {
            case 0:{
                [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(120, 120));
                    make.centerX.equalTo(@0);
                }];
                [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(120, 30));
                    make.top.mas_equalTo(self.avatarImageView.mas_bottom);
                    make.centerX.equalTo(@0);
                }];
                if ([Config shareInstance].settings.nickname) {
                    nameLabel.text = [Config shareInstance].settings.nickname;
                }else{
                    nameLabel.text = @"null";
                }
                if ([Config shareInstance].settings.avatar) {
                    self.avatarImageView.image = [Config shareInstance].settings.avatar;
                }else
                    self.avatarImageView.image = [UIImage imageNamed:@"avatarDefault1"];
            }
                break;
            case 1:{
                WS(ws);

                [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(cell.mas_top);
                    make.centerX.mas_equalTo(-ws.view.bounds.size.width/4);
                }];
                [firstResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(firstLabel.mas_bottom);
                    make.centerX.mas_equalTo(firstLabel.mas_centerX);
                }];
                [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.centerX.mas_equalTo(ws.view.bounds.size.width/4);
                    make.top.mas_equalTo(cell.mas_top);
                }];
                [secondResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(secondLabel.mas_bottom);

                    make.centerX.mas_equalTo(secondLabel.mas_centerX);

                }];
                firstLabel.text = @"出差位置";
                secondLabel.text = @"出差时间";
                BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Task"];
                //添加playerName不是小明的约束条件
                [bquery whereKey:@"identityID" equalTo:[Config shareInstance].settings.objectId];
                [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    for (BmobObject *obj in array) {
                        firstResultLabel.text = [obj objectForKey:@"TaskArea"];
                        secondResultLabel.text = [obj objectForKey:@"LastTime"];

                    }
                    }];
            }
                break;
            case 2:{
                WS(ws);
                
                [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(cell.mas_top);
                    make.centerX.mas_equalTo(-ws.view.bounds.size.width/4);
                }];
                [locateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(firstLabel.mas_bottom);
                    make.centerX.mas_equalTo(firstLabel.mas_centerX);
                }];
                [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.centerX.mas_equalTo(ws.view.bounds.size.width/4);
                    make.top.mas_equalTo(cell.mas_top);
                }];
                [secondResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.top.mas_equalTo(secondLabel.mas_bottom);
                    
                    make.centerX.mas_equalTo(secondLabel.mas_centerX);
                    
                }];
                
                firstLabel.text = @"当前位置";
                secondLabel.text = @"当前时间";
                locateLabel.text = self.locateLabel.text;
                
                secondResultLabel.text = self.nowTimeStr;

            }
                break;
            case 3:{
                WS(ws);
                [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2, 30));
                    make.centerX.mas_equalTo(-ws.view.bounds.size.width/4);
                    make.top.mas_equalTo(cell.mas_top).with.offset(150);
                }];
                [taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).with.offset(10);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-10);
                }];
                firstLabel.text = @"点击拍照";
                taskImageView.image = self.taskImageView.image;

            }
                break;
            case 4:{
                [qiandaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top);
                    make.bottom.mas_equalTo(cell.mas_bottom);
                    make.left.equalTo(@0);
                    make.right.mas_equalTo(0);
                }];
            }
                break;
                
            default:
                break;
        }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }
    if (indexPath.row ==3 ) {
        return 300 ;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        [self updateAvatar];
    }else if(indexPath.row == 2){
        MapKitViewController *map = [[MapKitViewController alloc]init];
        [self.navigationController pushViewController:map animated:YES];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    if([accountDefaults objectForKey:@"name"] != nil){
    
        [accountDefaults objectForKey:@"name"];
        self.locateStr =  [accountDefaults objectForKey:@"name"];
        
        NSLog(@"%@", self.locateStr);
        self.locateLabel.text = [accountDefaults objectForKey:@"name"];
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.nowTimeStr = [dateFormatter stringFromDate:now];
        [self.locationTableView reloadData];
           }
}
/**
 签到
 */
-(void)SignIn{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Task"];
    [bquery whereKey:@"identityID" equalTo:[Config shareInstance].settings.objectId];
    WS(ws);
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        
        for (BmobObject *obj in array) {
            
                if([ws.locateLabel.text isEqualToString:[accountDefaults objectForKey:@"name"]] && [[obj objectForKey:@"TaskArea"] isEqualToString:[accountDefaults objectForKey:@"locality"]] && ws.taskImageView.image ){
                    [obj setObject:[NSNumber numberWithBool:YES] forKey:@"DidSign_in"];
                    [obj setObject:ws.locateStr forKey:@"LocateArea"];
                    [obj updateInBackground];
                    
                    
                    BmobFile *file = [[BmobFile alloc] initWithFileName:@"TaskImg.jpg" withFileData:UIImageJPEGRepresentation(ws.taskImageView.image, 0.8f)];
                    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [obj setObject:file.url forKey:@"TaskImg"];
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                
                            }];
                        }
                    } withProgressBlock:^(float progress) {
                        NSLog(@"progress %.2f",progress);
                    }];
                    UIAlertView *successView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:@"您好！您已签到成功，祝您出差一帆风顺！！" delegate:ws cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [successView show];
                    [ws.view addSubview:successView];
                    //移除NSUserDefaults相应的字典。避免label重复显示地理位置
                    [accountDefaults removeObjectForKey:@"name"];
                    [accountDefaults removeObjectForKey:@"locality"];
                    
                    [ws.navigationController popViewControllerAnimated:YES];
            }
            else{
                    UIAlertView *failView = [[UIAlertView alloc] initWithTitle:@"签到失败" message:@"对不起！您签到失败了，请您确定是否已到目的城市或者是否上传图片！！！" delegate:ws cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [failView show];
                    [ws.view addSubview:failView];
                    return ;
                }
            
            

        }
        
    }];}
#pragma mark - 相册和拍照相关

-(void)updateAvatar{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"相册",@"照相", nil];
    
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pick.allowsEditing = YES;
            pick.delegate = self;
            
            [self presentViewController:pick animated:YES
                             completion:^{
                                 
                             }];
        }
            break;
        case 1:{
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.allowsEditing = YES;
            pick.delegate = self;
            
            [self presentViewController:pick animated:YES
                             completion:^{
                                 
                                 if (IS_iOS7) {
                                     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                                 }
                             }];
        }
            break;
        default:
            break;
    }
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IS_iOS7) {
            [self.taskImageView setImage:image];
            [self.locationTableView reloadData];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IS_iOS7) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }];
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(UITableView *)locationTableView{
    if (!_locationTableView) {
        _locationTableView = [[UITableView alloc]init];
    }
    return _locationTableView;
}
@end
