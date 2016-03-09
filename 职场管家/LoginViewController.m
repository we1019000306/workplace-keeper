//
//  LoginViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/14.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//
#define kMBProgressTag 9999
#define loginBGImgHeight ws.view.height/6
#define imageViewWidth 15
#import "LoginViewController.h"
#import "UIView+Extension.h"
#import "MBProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import "MYMainViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "DataCenter.h"
#import "Settings.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

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
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    //Logo ImageView
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.image = [UIImage imageNamed:@"ZhiGuan.png"];
    [self.view addSubview:logoImageView];
    //bgimage
    UIImageView  *loginBackgroundImageView = [[UIImageView alloc] init];
    loginBackgroundImageView.image         = [[UIImage imageNamed:@"login_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.view addSubview:loginBackgroundImageView];
    //breakline
    UIImageView   *lineImageView = [[UIImageView alloc] init];
    lineImageView.image          = [UIImage imageNamed:@"common_line"];
    [self.view addSubview:lineImageView];
    //username ImageView
    UIImageView *userImageView = [[UIImageView alloc]init];
    userImageView.image = [UIImage imageNamed:@"person"];
    [self.view addSubview:userImageView];
    
    //username TextFiled
    UITextField *username = [[UITextField alloc]init];
    username.backgroundColor  = [UIColor clearColor];
    username.clearButtonMode  = UITextFieldViewModeWhileEditing;
    username.placeholder      = @"请输入账号";
    username.returnKeyType    = UIReturnKeyNext;
    username.delegate         = self;
    username.tag = 101;
    [self.view addSubview:username];
    //password ImageView
    UIImageView *pwImageView = [[UIImageView alloc]init];
    pwImageView.image = [UIImage imageNamed:@"lock"];
    [self.view addSubview:pwImageView];
    //password TextFiled
    UITextField *password = [[UITextField alloc]init];
    password.backgroundColor  = [UIColor clearColor];
    password.clearButtonMode  = UITextFieldViewModeWhileEditing;
    password.placeholder      = @"请输入密码";
    password.returnKeyType    = UIReturnKeyDone;
    password.secureTextEntry  = YES;
    password.delegate         = self;
    password.tag = 102;
    [self.view addSubview:password];
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitle:@"登陆" forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn1@2x"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtn2@2x"] forState:UIControlStateHighlighted];
    loginBtn.tag = 103;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enabled   = NO;
    //MBProgressHUD
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = kMBProgressTag;
    [self.view addSubview:hud];
    //registerBtn
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"还没有账号?前去注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGB(71, 156, 245, 1.0) forState:UIControlStateNormal];
    [[registerBtn titleLabel] setFont:[CommonUtil setFontSize:14]];
    [registerBtn addTarget:self action:@selector(toRegisterMember) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    [self.view bringSubviewToFront:hud];
    
    
    //NSNotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldIsNull:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    
    
    
    //MAS_Constraints
    //logoImageView
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(74, imageViewWidth,ws.view.height-((ws.view.height-loginBGImgHeight)/2-30), imageViewWidth));
        make.bottom.mas_equalTo(loginBackgroundImageView.mas_top).with.offset(-30);
    }];
    //LoginbgImg
    [loginBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(loginBGImgHeight);
        make.width.mas_equalTo(ws.view.width);
        make.centerY.mas_equalTo(0);
    }];
    //BreakLine
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ws.view.width-imageViewWidth*2,1));
        make.left.mas_equalTo(imageViewWidth*2+25);
        //        make.top.mas_equalTo(loginBackgroundImageView.mas_top).with.offset(ws.view.height/10);
        make.centerY.mas_equalTo(0);
    }];
    //username
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageViewWidth*2,loginBGImgHeight/4));
        //        make.width.equalTo(@25);
        make.left.equalTo(@15);
        make.centerY.equalTo(username.mas_centerY);
        //        make.top.mas_equalTo(loginBackgroundImageView.mas_top).with.offset((ws.view.height/40)*2);
        make.centerY.mas_equalTo(-loginBGImgHeight/4);
        
    }];
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(userImageView.mas_right).with.offset(15);
        
    }];
    //password
    [pwImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imageViewWidth*2,loginBGImgHeight/4));
        make.left.equalTo(@15);
        make.centerY.equalTo(password.mas_centerY);
        make.centerY.mas_equalTo(loginBGImgHeight/4);
    }];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pwImageView.mas_centerY);
        make.right.mas_equalTo(-15);
        make.centerX.mas_equalTo(username.mas_centerX);
    }];
    //loginBtn
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(loginBackgroundImageView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    //registerBtn
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.mas_equalTo(loginBtn.mas_bottom).with.offset(30);
    }];

}

-(void)dealloc{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    //    [[Location shareInstance] setDelegate:nil];
}

-(void)dismissSelf{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.view endEditing:YES];
    
    
}

-(void)login{
    WS(ws);
    MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"登陆中...";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *tmpNcTextField = (UITextField *)[self.view viewWithTag:101];
    NSString *username = [tmpNcTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@"-"];
    [BmobUser loginInbackgroundWithAccount:username andPassword:tmpTextField.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud show:YES];
                hud.labelText = [[error userInfo] objectForKey:@"error"];
                hud.mode = MBProgressHUDModeText;
                usleep(200000);
                [hud hide:YES];
                
            });
            
        }else if(user){
            
            if ([[user objectForKey:@"emailVerified"] boolValue]){
                [DataCenter syncServerToLocalForSettings:user];

                BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
                [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    for (BmobObject *obj in array) {
                        [DataCenter addToContact:obj];
                    }
                }];
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                                    password:tmpTextField.text
                                                                  completion:
                 ^(NSDictionary *loginInfo, EMError *error) {
                     [self hideHud];
                     if (loginInfo && !error) {
                         //设置是否自动登录
                         [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                         
                         // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
                         [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                         //获取数据库中数据
                         [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                         
                         //获取群组列表
                         [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                         
                         //发送自动登陆状态通知
                         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                         
                         
                         
                         
                     }
                     else
                     {
                         switch (error.errorCode)
                         {
                             case EMErrorNotFound:
                                 [hud hide:YES];
                                 TTAlertNoTitle(error.description);
                                 break;
                             case EMErrorNetworkNotConnected:
                                 [hud hide:YES];
                                 
                                 TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                                 break;
                             case EMErrorServerNotReachable:
                                 [hud hide:YES];
                                 
                                 TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                                 break;
                             case EMErrorServerAuthenticationFailure:
                                 [hud hide:YES];
                                 
                                 TTAlertNoTitle(@"由于多人举报，您的聊天权限已被限制。请与管理员取得联系");
                                 [CommonUtil needLoginWithViewController:self animated:YES];
                                 break;
                             case EMErrorServerTimeout:
                                 [hud hide:YES];
                                 
                                 TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                                 break;
                             default:
                                 [hud hide:YES];
                                 TTAlertNoTitle(@"登录失败！！请检查网络是否连接正常并重新登录");
                                 [CommonUtil needLoginWithViewController:self animated:YES];

                                 break;
                         }
                         
                     }
                 } onQueue:nil];
                [hud hide:YES];
                [ws dismissSelf];
            }else {
                //用户没验证过邮箱
                [hud hide:YES];
                [BmobUser logout];
                [AlertCenter alertButtonMessage:str_LogIn_Tips2];
                [user verifyEmailInBackgroundWithEmailAddress:tmpNcTextField.text];
            }

            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldIsNull:(NSNotification*)noti{
    UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:101];
    UITextField *tmpNcTextField = (UITextField *)[self.view viewWithTag:102];
    UIButton *loginBtn = (UIButton*)[self.view viewWithTag:103];
    if ([tmpNcTextField.text length ] == 0 ||[tmpTextField.text length ] ==0 ) {
        loginBtn.enabled = NO;
    }else{
        loginBtn.enabled = YES;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 101) {
        UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:102];
        [tmpTextField becomeFirstResponder];
    }
    if (textField.tag == 102) {
        [self login];
    }
    
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)toRegisterMember{
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    rvc.title = @"注册";
    [self.navigationController pushViewController:rvc animated:YES];
    self.navigationController.navigationBarHidden = NO;
    rvc.navigationController.title = @"注册";
}


@end