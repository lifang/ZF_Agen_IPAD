//
//  LoginViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkInterface.h"
#import "AccountTool.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *userField;
@property(nonatomic,strong)UITextField *passwordField;
@end
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0&&8.0>[UIDevice currentDevice].systemVersion.floatValue )
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    [self setLoginView];
}

-(void)setLoginView
{
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.userInteractionEnabled = YES;
    imageV.image = kImageName(@"login_Bg");
    imageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (iOS7) {
        imageV.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    }
    [self.view addSubview:imageV];
    
    UIView *loginView = [[UIView alloc]init];
    loginView.frame = CGRectMake(300, 140, 430, 380);
    loginView.backgroundColor = [UIColor whiteColor];
    UIImageView *exitImage = [[UIImageView alloc]init];
    exitImage.userInteractionEnabled = YES;
    UIButton *btnClick = [[UIButton alloc]init];
    btnClick.frame = CGRectMake(0, 0, 30, 30);
    [btnClick addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [exitImage addSubview:btnClick];
    exitImage.image = kImageName(@"exit");
    exitImage.frame = CGRectMake(15, 15, 30, 30);
    [loginView addSubview:exitImage];
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(loginView.frame.size.width * 0.5 - 20, 10, 50, 40)];
    loginLabel.font = [UIFont boldSystemFontOfSize:22];
    loginLabel.text = @"登录";
    [loginView addSubview:loginLabel];
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(0, CGRectGetMaxY(loginLabel.frame)+ 10, loginView.frame.size.width, 1);
    line.backgroundColor = kColor(147, 147, 147, 1.0);
    [loginView addSubview:line];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(line.frame)+ 30, 40, 40)];
    userImage.image = kImageName(@"user");
    [loginView addSubview:userImage];
    UIImageView *passwordImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(userImage.frame)+ 30, 40, 40)];
    passwordImage.image = kImageName(@"password");
    [loginView addSubview:passwordImage];
    
    _userField = [[UITextField alloc]init];
    _userField.borderStyle = UITextBorderStyleLine;
    _userField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userField.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 10, userImage.frame.origin.y, loginView.frame.size.width * 0.65, userImage.frame.size.height);
    _userField.placeholder = @"请输入手机号/邮箱";
    AccountModel *account = [AccountTool userModel];
    if (account.username) {
        _userField.text = account.username;
    }
    [_userField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _userField.delegate = self;
    _userField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _userField.leftView = placeholderV;
    CALayer *readBtnLayer = [_userField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [loginView addSubview:_userField];
    
    _passwordField = [[UITextField alloc]init];
    _passwordField.secureTextEntry = YES;
    _passwordField.borderStyle = UITextBorderStyleLine;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 10, passwordImage.frame.origin.y, loginView.frame.size.width * 0.65, userImage.frame.size.height);
    _passwordField.placeholder = @"请输入密码";
    [_passwordField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _passwordField.delegate = self;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _passwordField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_passwordField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [loginView addSubview:_passwordField];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundColor:kColor(10, 87, 204, 1.0)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.tintColor = [UIColor whiteColor];
    loginBtn.frame = CGRectMake(_userField.frame.origin.x, CGRectGetMaxY(_passwordField.frame) + 30, _userField.frame.size.width, userImage.frame.size.height);
    [loginView addSubview:loginBtn];
    
    UIButton *findPasswordBtn = [[UIButton alloc]init];
    [findPasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:kColor(10, 87, 204, 1.0) forState:UIControlStateNormal];
    [findPasswordBtn addTarget:self action:@selector(findClick:) forControlEvents:UIControlEventTouchUpInside];
    findPasswordBtn.frame = CGRectMake(20, loginView.frame.size.height - 40, 80, 20);
    [loginView addSubview:findPasswordBtn];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitleColor:kColor(10, 87, 204, 1.0) forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registe:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(loginView.frame.size.width - 60, findPasswordBtn.frame.origin.y, 40, 20);
    [loginView addSubview:registerBtn];
    [self.view addSubview:imageV];
    [imageV addSubview:loginView];
}

-(void)loginClick:(UIButton *)sender
{
    [[AppDelegate shareRootViewController] showMainViewController];
//    if (!_userField.text || [_userField.text isEqualToString:@""] || !_passwordField.text || [_passwordField.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"用户名或密码不能为空!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"正在登录...";
//    [NetworkInterface loginWithUsername:_userField.text password:_passwordField.text isAlreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:0.3f];
//        if (success) {
//            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"~~~~~%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
//            if ([object isKindOfClass:[NSDictionary class]]) {
//                [hud hide:YES];
//                int errorCode = [[object objectForKey:@"code"] intValue];
//                if (errorCode == RequestFail) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                                    message:[object objectForKey:@"message"]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                }
//                else if (errorCode == RequestSuccess) {
////                    [self parseLoginDataWithDictionary:object];
//                }
//            }
//            else {
//                hud.labelText = kServiceReturnWrong;
//            }
//        }
//        else {
//            hud.labelText = kNetworkFailed;
//        }
//    }];
    
}

//-(void)parseLoginDataWithDictionary:(NSDictionary *)dict
//{
//    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"]isKindOfClass:[NSDictionary class]
//       ]) {
//        return;
//    }
//    NSDictionary *infoDict = [dict objectForKey:@"result"];
//    NSString *token = @"123";
//    NSString *userID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"id"]];
//    NSString *username = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"username"]];
//    AppDelegate *delegate = [AppDelegate shareAppDelegate];
//    delegate.token = token;
//    delegate.userID = userID;
//    AccountModel *account = [[AccountModel alloc]init];
//    account.username = username;
//    account.token = token;
//    account.password = _passwordField.text;
//    account.userID = userID;
//    account.token = token;
//    [AccountTool save:account];
//    if (_LoginSuccessDelegate && [_LoginSuccessDelegate respondsToSelector:@selector(LoginSuccess)]) {
//        [self.LoginSuccessDelegate LoginSuccess];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)exitClick
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)findClick:(UIButton *)sender
//{
//    NSLog(@"点击了找回密码！");
//    FindPasswordViewController *findV = [[FindPasswordViewController alloc]init];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:findV animated:YES];
//}
//
//-(void)registe:(UIButton *)sender
//{
//    NSLog(@"点击了注册！");
//    RegisterViewController *registeVC = [[RegisterViewController alloc]init];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController pushViewController:registeVC animated:YES];
//}

@end
