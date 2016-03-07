/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UserProfileViewController.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "UIImageView+HeadImage.h"
#import "Contact.h"
#import "ERPCache.h"
@interface UserProfileViewController ()<UITableViewDataSource,UITabBarControllerDelegate>

@property (strong, nonatomic) UserProfileEntity *user;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation UserProfileViewController

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
   
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人信息";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setupBarButtonItem];
}

- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(20, 10, 60, 60);
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
//        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _headImageView;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10.f, 10, 200, 20);

        _usernameLabel.text = @"昵称";
        _usernameLabel.textColor = [UIColor lightGrayColor];
    }
    return _usernameLabel;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *contact = [ERPCache getContact:_username];

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        //cell.textLabel.text = NSLocalizedString(@"setting.personalInfoUpload", @"Upload HeadImage");
        Contact *contact = [ERPCache getContact:_username];
        [self.headImageView setImage:contact.avatar];
        [self.usernameLabel setText:contact.nickname];
        [cell.contentView addSubview:self.headImageView];
        [cell.contentView addSubview:self.usernameLabel];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"职位";
        if (contact.position) {
            cell.detailTextLabel.text = contact.position;
        }else{
            cell.detailTextLabel.text = @"职员";
        }

        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2){
        cell.textLabel.text = @"性别";
        
        if ([contact.gender isEqualToString:@"1"]) {
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            cell.detailTextLabel.text = @"男";
        } else {
            cell.detailTextLabel.text = @"女";
        }

            }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

//- (void)loadUserProfile
//{
//    [self hideHud];
//    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//    __weak typeof(self) weakself = self;
//    [[UserProfileManager sharedInstance] loadUserProfileInBackground:@[_username] saveToLoacal:YES completion:^(BOOL success, NSError *error) {
//        [weakself hideHud];
//        if (success) {
//            [weakself.tableView reloadData];
//        }
//    }];
//}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
