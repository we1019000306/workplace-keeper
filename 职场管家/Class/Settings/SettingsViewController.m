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

#import "SettingsViewController.h"

#import "ApplyViewController.h"
#import "PushNotificationViewController.h"
#import "BlackListViewController.h"
#import "DebugViewController.h"
#import "EditNicknameViewController.h"
#import "UserProfileEditViewController.h"
#import "CallViewController.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import "CommonUtil.h"
#import "Masonry.h"
//#import "BackupViewController.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) UISwitch *autoLoginSwitch;
@property (strong, nonatomic) UISwitch *ipSwitch;
@property (strong, nonatomic) UISwitch *delConversationSwitch;
@property (strong, nonatomic) UISwitch *showCallInfoSwitch;
@property (strong, nonatomic) UITableView *settingsTableView;
@end

@implementation SettingsViewController

@synthesize ipSwitch = _ipSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.setting", @"Setting");
    WS(ws);
    self.settingsTableView = [[UITableView alloc]init];
    [self.view addSubview:_settingsTableView];
    [self.settingsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width,264));
    }];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.settingsTableView.delegate = self;
    self.settingsTableView.dataSource = self;
    self.settingsTableView.scrollEnabled = NO;
    self.settingsTableView.backgroundColor = [UIColor whiteColor];
//    self.settingsTableView.tableFooterView = self.footerView;
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出" forState:UIControlStateHighlighted];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logoutBtn1@2x"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logoutBtn2@2x"] forState:UIControlStateHighlighted];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(_infoTableView.mas_bottom).with.offset(200);
        make.bottom.mas_equalTo(ws.view.mas_bottom).with.offset(-100);
        make.left.equalTo(@15);
        make.right.mas_equalTo(-15);
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (UISwitch *)autoLoginSwitch
{
    if (_autoLoginSwitch == nil) {
        _autoLoginSwitch = [[UISwitch alloc] init];
        [_autoLoginSwitch addTarget:self action:@selector(autoLoginChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _autoLoginSwitch;
}

- (UISwitch *)ipSwitch
{
    if (_ipSwitch == nil) {
        _ipSwitch = [[UISwitch alloc] init];
        [_ipSwitch addTarget:self action:@selector(useIpChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _ipSwitch;
}

- (UISwitch *)delConversationSwitch
{
    if (!_delConversationSwitch)
    {
        _delConversationSwitch = [[UISwitch alloc] init];
        _delConversationSwitch.on = [EaseMob sharedInstance].chatManager.isAutoDeleteConversationWhenLeaveGroup;
        [_delConversationSwitch addTarget:self action:@selector(delConversationChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _delConversationSwitch;
}

- (UISwitch *)showCallInfoSwitch
{
    if (!_showCallInfoSwitch)
    {
        _showCallInfoSwitch = [[UISwitch alloc] init];
        _showCallInfoSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showCallInfo"] boolValue];
        [_showCallInfoSwitch addTarget:self action:@selector(showCallInfoChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _showCallInfoSwitch;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"title.apnsSetting", @"Apns Settings");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"title.buddyBlock", @"Black List");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"setting.useIp", @"Use IP");
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.ipSwitch.frame = CGRectMake(self.settingsTableView.frame.size.width - (self.ipSwitch.frame.size.width + 10), (cell.contentView.frame.size.height - self.ipSwitch.frame.size.height) / 2, self.ipSwitch.frame.size.width, self.ipSwitch.frame.size.height);
            [cell.contentView addSubview:self.ipSwitch];
        }
        else if (indexPath.row == 3){
            cell.textLabel.text = NSLocalizedString(@"setting.deleteConWhenLeave", @"Delete conversation when leave a group");
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.delConversationSwitch.frame = CGRectMake(self.settingsTableView.frame.size.width - (self.delConversationSwitch.frame.size.width + 10), (cell.contentView.frame.size.height - self.delConversationSwitch.frame.size.height) / 2, self.delConversationSwitch.frame.size.width, self.delConversationSwitch.frame.size.height);
            [cell.contentView addSubview:self.delConversationSwitch];
        }

    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        PushNotificationViewController *pushController = [[PushNotificationViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:pushController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        BlackListViewController *blackController = [[BlackListViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:blackController animated:YES];
    }
}



#pragma mark - getter

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
               NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
            }
    
    return _footerView;
}

#pragma mark - action

- (void)useIpChanged:(UISwitch *)ipSwitch
{
    [[EaseMob sharedInstance].chatManager setIsUseIp:ipSwitch.isOn];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:ipSwitch.isOn] forKey:@"identifier_userip_enable"];
    [ud synchronize];
}

- (void)delConversationChanged:(UISwitch *)control
{
    [EaseMob sharedInstance].chatManager.isAutoDeleteConversationWhenLeaveGroup = control.isOn;
}

- (void)showCallInfoChanged:(UISwitch *)control
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:control.isOn] forKey:@"showCallInfo"];
    [userDefaults synchronize];
}

- (void)refreshConfig
{
    [self.autoLoginSwitch setOn:[[EaseMob sharedInstance].chatManager isAutoLoginEnabled] animated:YES];
    [self.ipSwitch setOn:[[EaseMob sharedInstance].chatManager isUseIp] animated:YES];
    
    [self.settingsTableView reloadData];
}

-(void)logout{

    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    [BmobUser logout];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[ApplyViewController shareController] clear];
    [BmobQuery clearAllCachedResults];
    [CommonUtil needLoginWithViewController:self animated:NO];
}
@end
