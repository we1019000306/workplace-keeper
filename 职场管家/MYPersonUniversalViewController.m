//
//  MYPersonUniversalViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/21.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "MYPersonUniversalViewController.h"
#import "UIView+Extension.h"
#import <BmobSDK/Bmob.h>
#import "BmobUserForERP.h"
#import "UIImageView+WebCache.h"
#import "DataCenter.h"
#import "ApplyViewController.h"
#import "Contact.h"
@interface MYPersonUniversalViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITableView *_infoTableView;
    NSMutableDictionary     *_infoDic;
    
    UIImageView *avatarImageView ;
}


@end

@implementation MYPersonUniversalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (IS_iOS7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    WS(ws);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _infoTableView = [[UITableView alloc]init];
    _infoTableView.scrollEnabled = NO;
    _infoTableView.dataSource     = self;
    _infoTableView.delegate       = self;
    if ([_infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_infoTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_infoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_infoTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:_infoTableView];

    [_infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.view.mas_top).with.offset(74);
        make.height.mas_equalTo(@320);
    }];


    [NotificationCenter addObserver:self selector:@selector(reload) name:Notify_Settings_Save object:nil];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *firstLabel                 = [[UILabel alloc] init];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textColor       = RGB(60, 60, 60, 1.0f);
        firstLabel.font            = [UIFont boldSystemFontOfSize:15];
        [cell.contentView addSubview:firstLabel];
        firstLabel.tag = 100;
        
        UILabel *powerLabel                 = [[UILabel alloc] init];
        powerLabel.backgroundColor = [UIColor clearColor];
        powerLabel.textColor       = RGB(136, 136, 136, 1.0f);
        powerLabel.font            = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:powerLabel];
        powerLabel.tag = 101;
        
        avatarImageView = [[UIImageView alloc] init];
        [avatarImageView.layer setMasksToBounds:YES];
        [avatarImageView.layer setCornerRadius:30];
        [cell.contentView addSubview:avatarImageView];
        avatarImageView.tag = 102;
        [avatarImageView setHidden:YES];
        
        UILabel *sexLabel = [[UILabel alloc]init];
        sexLabel.backgroundColor = [UIColor clearColor];
        sexLabel.textColor       = RGB(136, 136, 136, 1.0f);
        sexLabel.font            = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:sexLabel];
        sexLabel.tag = 103;
        
        
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor       = RGB(136, 136, 136, 1.0f);
        nameLabel.font            = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLabel];
        nameLabel.tag = 104;
        
        UILabel *emailLabel = [[UILabel alloc]init];
        emailLabel.backgroundColor = [UIColor clearColor];
        emailLabel.textColor       = RGB(136, 136, 136, 1.0f);
        emailLabel.font            = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:emailLabel];
        emailLabel.tag = 105;
        
        
    }
    UILabel *firstLabel = (UILabel*)[cell.contentView viewWithTag:100];
    
    
    UILabel *powerLabel = (UILabel*)[cell.contentView viewWithTag:101];
    
    
    avatarImageView = (UIImageView *)[cell.contentView viewWithTag:102];
    
    UILabel *sexLabel = (UILabel *)[cell.contentView viewWithTag:103];
    //
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:104];
    
    UILabel *emailLabel = (UILabel *)[cell.contentView viewWithTag:105];

    
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    sexLabel.textAlignment = NSTextAlignmentCenter;
    
    powerLabel.textAlignment = NSTextAlignmentCenter;
    
    emailLabel.textAlignment = NSTextAlignmentRight;

    
    //

    
    switch (indexPath.row) {
        case 0:{
            WS(ws);
            
            firstLabel.text = @"头像";
            [avatarImageView setHidden:NO];
            [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(cell.width/8, 80));
                make.centerY.mas_equalTo(avatarImageView.mas_centerY);
                
            }];
            [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 60));
                //                make.right.mas_equalTo(-30);
                make.top.mas_equalTo(cell.mas_top).with.offset(10);
                //                make.right.mas_equalTo(-50);
                make.centerX.mas_equalTo(ws.view.width/3);
            }];
            if ([Config shareInstance].settings.avatar) {
                [avatarImageView setImage:[Config shareInstance].settings.avatar];
            }else{
                [avatarImageView setImage:[UIImage imageNamed:@"myava.jpg"]];
            }
//                [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[Config shareInstance].settings.avatarURL] placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
//            
            }
            
//            BmobUser *user = [BmobUser getCurrentUser];
//            if ([user objectForKey:@"avatar"]) {
//                //                [avatarImageView setImage:[UIImage imageNamed:@"myava.jpg"]];
//                [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
//            }else
//                [avatarImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"myava.jpg"]];
//        }
            break;
        case 1:{
            WS(ws);
            firstLabel.text = @"昵称";
            if ([Config shareInstance].settings.nickname) {
                nameLabel.text = [Config shareInstance].settings.nickname;
            }else{
                nameLabel.text = @"昵称";
            }
            
            [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(cell.width/8, 60));
                make.centerY.mas_equalTo(nameLabel.mas_centerY);
            }];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(ws.view.width/3);
                make.size.mas_equalTo(CGSizeMake(100,60));
                
            }];
            
            
        }
            break;
        case 2:{
            WS(ws);
            firstLabel.text = @"性别";
            if ([[Config shareInstance].settings.gender isEqualToString:@"1"]) {
                sexLabel.text = @"男";
            }else {
                sexLabel.text = @"女";
            }
            [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(cell.width/8, 60));
                make.centerY.mas_equalTo(sexLabel.mas_centerY);
            }];
            [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ws.view.width/4,60));
                make.centerX.mas_equalTo(ws.view.width/3);
                
            }];
            
        }
            
            break;
        case 3:{
            WS(ws);
            firstLabel.text = @"职位";
            if ([Config shareInstance].settings.position) {
                powerLabel.text = [Config shareInstance].settings.position;
            }else{
                powerLabel.text = @"职员";
            }
            [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(cell.width/8, 60));
                make.centerY.mas_equalTo(powerLabel.mas_centerY);
            }];
            [powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100,60));
                make.centerX.mas_equalTo(ws.view.width/3);
                
            }];
        }
            break;
        case 4:{
            firstLabel.text = @"邮箱";
            if ([Config shareInstance].settings.position) {
                emailLabel.text = [Config shareInstance].settings.email;
            }else{
                emailLabel.text = @"";
            }
            [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.size.mas_equalTo(CGSizeMake(cell.width/8, 60));
                make.centerY.mas_equalTo(emailLabel.mas_centerY);
            }];
            [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.size.mas_equalTo(CGSizeMake(180,60));
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
        return 80;
    }
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self updateAvatar];
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
#pragma mark

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
    BmobUser *user = [BmobUser getCurrentUser];
    BmobFile *file = [[BmobFile alloc] initWithFileName:@"avatar.jpg" withFileData:UIImageJPEGRepresentation(image, 0.8f)];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [user setObject:file.url forKey:@"avatar"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        for (BmobObject *obj in array) {
                            if ([[obj objectForKey:@"username"] isEqualToString:[BmobUser getCurrentUser].username]) {
                                [obj setObject:file.url forKey:@"avatar"];
                                [obj saveInBackground];
                                
                                [Config shareInstance].settings.avatar = image;
                                [Config shareInstance].settings.avatarURL = file.url;
                                [ERPCache storePersonalSettings:[Config shareInstance].settings];
                              
                                [DataCenter addToContact:obj];
                                [_infoTableView reloadData];
                            }
                        }
                    }];
                }
            }];
        }
    } withProgressBlock:^(float progress) {
        NSLog(@"progress %.2f",progress);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IS_iOS7) {
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

- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_infoTableView reloadData];
    });
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}


@end
