//
//  RegisterViewController.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/18.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import "MYMainViewController.h"
#import "RegisterViewController.h"

@interface RegisterViewController ()<IChatManagerDelegate,EMChatManagerLoginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *avatarname;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@end

@implementation RegisterViewController
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
}

-(void)dealloc{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dismissSelf{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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

- (IBAction)register:(id)sender {
    [self checkIfEmailHadRegisted];
}
- (IBAction)selectSex:(id)sender {
    UIAlertController *sexContronller = [UIAlertController alertControllerWithTitle:@"请选择您的性别" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *male = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.sexBtn setTitle:@"男" forState:UIControlStateNormal];
        [self.sexBtn setTitle:@"男" forState:UIControlStateHighlighted];
        
    }];
    UIAlertAction *female = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self.sexBtn setTitle:@"女" forState:UIControlStateNormal];
        [self.sexBtn setTitle:@"女" forState:UIControlStateHighlighted];
    }];
    [sexContronller addAction:male];
    [sexContronller addAction:female];
    [self presentViewController:sexContronller animated:YES completion:nil];
}

-(BOOL)isCorrectUsername{
    if ([self.username.text containsString:@"@"] &&[self.username.text containsString:@".com"]) {
        return YES;
    }
    return NO;
}
-(BOOL)isNotNull{
    if ([self.username.text isEqualToString: @""]||[self.password.text isEqualToString: @""]||[self.avatarname.text isEqualToString:@""]||[self.sexBtn.titleLabel.text isEqualToString:@"性别"]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)checkIfEmailHadRegisted {
    __weak typeof(self) weakSelf = self;
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:self.username.text];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error){
            //进行错误处理
        } else {
            if (array && array.count > 0) {//已存在
                [AlertCenter alertButtonMessage:str_Register_Tips5];
            } else {//可注册
                [weakSelf registerUser];
            }
        }
    }];
}

-(void)registerUser{
    if([self isCorrectUsername] ==YES && [self isNotNull] == YES){
        NSString *username = [self.username.text stringByReplacingOccurrencesOfString:@"@" withString:@"-"];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username password:self.password.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if(error){
                WS(ws);
                UIAlertController *errorHuan = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"对不起，该账号已存在!!!请您更换其他账号进行注册!!!" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [errorHuan didMoveToParentViewController:self];
                }];
                [errorHuan addAction:ok];
                [self presentViewController:errorHuan animated:YES completion:nil];
            }else{
                WS(ws);
                BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
                [bquery whereKey:@"username" equalTo:self.username.text];
                [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    
                    if (error){
                        //进行错误处理
                    } else {
                        if (array && array.count > 0) {//已存在
                            UIAlertController *errorBmob = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"对不起，该账号已存在!!!请您更换其他账号进行注册!!!" preferredStyle:(UIAlertControllerStyleAlert)];
                            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                                [errorBmob didMoveToParentViewController:self];
                                
                            }];
                            [errorBmob addAction:ok];
                            [self presentViewController:errorBmob animated:YES completion:nil];
                            
                        } else {//可注册
                            
                            NSURL *urlBmob = [NSURL URLWithString:@"https://api.bmob.cn/1/classes/_User"];
                            // 2.请求
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlBmob];
                            // 3.请求方法
                            request.HTTPMethod = @"POST";
                            // 4.设置请求体（请求参数）
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request setValue:@"d3bc0a097d27eedb229331b2262dba72" forHTTPHeaderField:@"X-Bmob-Application-Id"];
                            [request setValue:@"6be23ffaa46090ead9c005d6dcc6ab62" forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
                            // 创建一个描述订单信息的JSON数据
                            NSString *gender = [[NSString alloc]init];
                            if([ws.sexBtn.titleLabel.text isEqualToString:@"男"]){
                                gender = @"1";
                            }
                            if([ws.sexBtn.titleLabel.text isEqualToString:@"女"]){
                                gender = @"0";
                            }
                            NSDictionary *orderInfo = @{
                                                        @"username":username,
                                                        @"password":self.password.text,
                                                        @"name":self.avatarname.text,
                                                        @"email":self.username.text,
                                                        @"gender":gender,
                                                        @"avatar":@"http://file.bmob.cn/M03/AB/C3/oYYBAFbK0kaANB3AAAYkMYcc-n8945.jpg",
                                                        @"userPosition":@"职员"
                                                        };
                            NSData *json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
                            request.HTTPBody = json;
                            
                            // 5.设置请求头：这次请求体的数据不再是普通的参数，而是一个JSON数据
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            
                            // 6.发送请求
                            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                if (data == nil || connectionError) return;
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                NSString *error = dict[@"error"];
                                if (error) {
                                    NSLog(@"error");
                                } else {
                                    NSLog(@"请求成功！！");
                                    UIAlertController *registController = [UIAlertController alertControllerWithTitle:@"恭喜您注册成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                                        [ws dismissSelf];
                                    }];
                                    [registController addAction:ok];
                                    [ws presentViewController:registController animated:YES completion:nil];
                                    
                                }
                            }];
                            
                            
                        }
                    }
                }];
                
                
            }
        } onQueue:dispatch_get_main_queue()];
        
    }else if ([self isNotNull] == NO ){
        UIAlertController *usernameIsNull = [UIAlertController alertControllerWithTitle:@"信息填写不完全！请正确填写所有信息后再进行注册！" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [usernameIsNull didMoveToParentViewController:self];
        }];
        [usernameIsNull addAction:ok];
        [self presentViewController:usernameIsNull animated:YES completion:nil];
    }else if([self isCorrectUsername]==NO){
        UIAlertController *usernameIsNotCorrect = [UIAlertController alertControllerWithTitle:@"请输入正确的邮箱格式" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [usernameIsNotCorrect didMoveToParentViewController:self];
        }];
        [usernameIsNotCorrect addAction:ok];
        [self presentViewController:usernameIsNotCorrect animated:YES completion:nil];
    }

}

@end
