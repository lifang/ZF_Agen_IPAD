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
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *userField;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)UIView *GuideView;
@property(nonatomic,strong)UIImageView *imageV;

@end
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0&&8.0>[UIDevice currentDevice].systemVersion.floatValue )
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AccountModel *account = [AccountTool userModel];
    if (account.password) {
        _userField.text = account.username;
        _passwordField.text = account.password;
        [self loginApply];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    [NSThread sleepForTimeInterval:3.0]; //LaunchImage 延长3秒
    [self setLoginView];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        
        [self setGuideUI];
    }
 

}

-(void)setLoginView
{
    _imageV = [[UIImageView alloc]init];
    _imageV.userInteractionEnabled = YES;
    _imageV.image = kImageName(@"login_Bg");
    _imageV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (iOS7) {
        _imageV.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    }
    [self.view addSubview:_imageV];
    
    UIView *loginView = [[UIView alloc]init];
    loginView.frame = CGRectMake(300, 140, 430, 380);
    loginView.backgroundColor = [UIColor whiteColor];
    UIImageView *exitImage = [[UIImageView alloc]init];
    exitImage.userInteractionEnabled = YES;
    UIButton *btnClick = [[UIButton alloc]init];
    btnClick.frame = CGRectMake(0, 0, 30, 30);
    [exitImage addSubview:btnClick];
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
    [registerBtn addTarget:self action:@selector(registers:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(loginView.frame.size.width - 60, findPasswordBtn.frame.origin.y, 40, 20);
    [loginView addSubview:registerBtn];
    [self.view addSubview:_imageV];
    [_imageV addSubview:loginView];
}

-(void)setGuideUI
{
    float wide;
    float high;
    
    if (iOS7) {
        wide=SCREEN_HEIGHT;
        high=SCREEN_WIDTH;
        
    }
    else
    {
        wide=SCREEN_WIDTH;
        high=SCREEN_HEIGHT;
        
    }
    _GuideView = [[UIView alloc]init];
    _GuideView.frame = CGRectMake(0, 0, wide, high);
    _GuideView.backgroundColor = [UIColor whiteColor];
    [_imageV addSubview:_GuideView];
    
    
    NSArray *arr=[NSArray arrayWithObjects:@"pad1",@"pad2",@"pad3",@"pad4", nil];
    //数组内存放的是我要显示的假引导页面图片
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize=CGSizeMake(wide*arr.count, high);
    scrollView.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [_GuideView addSubview:scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [scrollView addSubview:img];
    }
    
    
    UIButton *useBtn=[[UIButton alloc] init];
    useBtn.frame=CGRectMake(254+wide*3, high-78-50, (wide-507-77)/2.0, 50);
    useBtn.layer.masksToBounds=YES;
    useBtn.layer.borderWidth=10.0;
    useBtn.layer.cornerRadius=8.0;
    useBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    [useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useBtn setTitle:@"马上使用" forState:UIControlStateNormal];
    [useBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:useBtn];
    
    
    UIButton *applyBtn=[[UIButton alloc] init];
    applyBtn.frame=CGRectMake(254+wide*3+(wide-507-77)/2.0+77, high-78-50, (wide-507-77)/2.0, 50);
    applyBtn.layer.masksToBounds=YES;
    applyBtn.layer.borderWidth=10.0;
    applyBtn.layer.cornerRadius=8.0;
    applyBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn setTitle:@"申请成为代理商" forState:UIControlStateNormal];
    [applyBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:applyBtn];

}

-(void)useBtnClick:(id)sender
{
    [_GuideView removeFromSuperview];
   
}

-(void)applyBtnClick:(id)sender
{
    [_GuideView removeFromSuperview];
    [self gotoregister];

}


-(void)gotoregister
{
    RegisterViewController *registerV = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerV animated:YES];
}


-(void)registers:(UIButton *)sender
{
    RegisterViewController *registerV = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerV animated:YES];
}

-(void)findClick:(UIButton *)sender
{
    FindPasswordViewController *findVC = [[FindPasswordViewController alloc]init];
    [self.navigationController pushViewController:findVC animated:YES];
}

-(void)loginClick:(UIButton *)sender
{
    //进入首页
    [_passwordField resignFirstResponder];
    if (!_userField.text || [_userField.text isEqualToString:@""] || !_passwordField.text || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self loginApply];

    
}

-(void)loginApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    [NetworkInterface loginWithUsername:_userField.text password:_passwordField.text isAlreadyEncrypt:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"~~~~~%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    [[AppDelegate shareRootViewController] showMainViewController];
                    
                    [self parseLoginDataWithDictionary:object];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

-(void)parseLoginDataWithDictionary:(NSDictionary *)dict
{
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"]isKindOfClass:[NSDictionary class]
       ]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSString *token = @"123";
    NSString *userID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"id"]];
    NSString *username = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"username"]];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    delegate.token = token;
    delegate.userID = userID;
    delegate.agentID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"agentId"]];

    delegate.agentUserID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"agentUserId"]];
    delegate.cityID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"cityId"]];
    
    [[AppDelegate shareAppDelegate] saveLoginInfo:infoDict];

    AccountModel *account = [[AccountModel alloc]init];
    account.username = username;
    account.token = token;
    account.password = _passwordField.text;
    account.userID = userID;
    account.token = token;
    [AccountTool save:account];
    if (_LoginSuccessDelegate && [_LoginSuccessDelegate respondsToSelector:@selector(LoginSuccess)]) {
        [self.LoginSuccessDelegate LoginSuccess];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
