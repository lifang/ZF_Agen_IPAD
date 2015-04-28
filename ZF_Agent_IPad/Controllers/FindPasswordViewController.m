//
//  FindPasswordViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "FindPasswordSuccessController.h"
#import "FindPasswordWithPhoneSuccessController.h"

@interface FindPasswordViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UITextField *authField;
@property(nonatomic,strong)UITextField *newsPassword;
@property(nonatomic,strong)UITextField *makeSurePassword;

@property(nonatomic,assign) BOOL isMobile;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)UILabel *authLabel;
@property(nonatomic,strong)UILabel *newpassworLabel;
@property(nonatomic,strong)UILabel *makesurepasswordLabel;
@property(nonatomic,strong)UIButton *makeSureBtn;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UIButton *presentBtn;

@property(nonatomic,strong)NSString *authCode;

@property(nonatomic,assign)BOOL isChecked;

@property(nonatomic,strong)UIImageView *imageV;

@end

@implementation FindPasswordViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kDeviceVersion < 8.0) {
        UIImageView *v = [[UIImageView alloc]init];
        v.frame = CGRectMake(0, -40, kScreenWidth * 2, 40);
        v.backgroundColor = kColor(231, 95, 53, 1.0);
        
        [self.navigationController.navigationBar addSubview:v];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *mainColor = kColor(10, 87, 204, 1.0);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBarHidden = NO;
    
    CGFloat mainBtnWidth = 100.f;
    CGFloat mainFieldWidth = 240.f;
    
    UILabel *phoneOrEmail = [[UILabel alloc]init];
    phoneOrEmail.font = [UIFont systemFontOfSize:20];
    phoneOrEmail.text = @"手机号/邮箱";
    phoneOrEmail.frame = CGRectMake(280, 120, 140, 40);
    [self.view addSubview:phoneOrEmail];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.borderStyle = UITextBorderStyleLine;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.frame = CGRectMake(CGRectGetMaxX(phoneOrEmail.frame) , phoneOrEmail.frame.origin.y, mainFieldWidth, phoneOrEmail.frame.size.height);
    _phoneField.placeholder = @"请输入手机号/邮箱";
    [_phoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _phoneField.leftView = placeholderV;
    CALayer *readBtnLayer = [_phoneField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_phoneField];
    
    UIButton *authGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, mainBtnWidth, _phoneField.frame.size.height)];
    _sendButton = authGetBtn;
    [authGetBtn addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
    [authGetBtn setBackgroundColor:mainColor];
    [authGetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:authGetBtn];
    
    UILabel *authCode = [[UILabel alloc]init];
    _authLabel = authCode;
    authCode.font = [UIFont systemFontOfSize:20];
    authCode.text = @"输入验证码";
    authCode.frame = CGRectMake(280, CGRectGetMaxY(phoneOrEmail.frame) + 20, 140, 40);
    [self.view addSubview:authCode];
    
    _authField = [[UITextField alloc]init];
    _authField.borderStyle = UITextBorderStyleLine;
    _authField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authField.frame = CGRectMake(CGRectGetMaxX(phoneOrEmail.frame) , authCode.frame.origin.y,mainFieldWidth, phoneOrEmail.frame.size.height);
    _authField.placeholder = @"请输入验证码";
    [_authField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _authField.delegate = self;
    _authField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _authField.leftView = placeholderV1;
    _authField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer1 = [_authField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authField];
    
    UIButton *makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _authField.frame.origin.y, mainBtnWidth, _phoneField.frame.size.height)];
    _makeSureBtn = makeSureBtn;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:mainColor];
    [makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:makeSureBtn];
    
    UILabel *password = [[UILabel alloc]init];
    _newpassworLabel = password;
    password.font = [UIFont systemFontOfSize:20];
    password.text = @"输入新密码";
    password.frame = CGRectMake(280, CGRectGetMaxY(authCode.frame)+ 40, 140, 40);
    [self.view addSubview:password];
    
    _newsPassword = [[UITextField alloc]init];
    _newsPassword.secureTextEntry = YES;
    _newsPassword.borderStyle = UITextBorderStyleLine;
    _newsPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsPassword.frame = CGRectMake(CGRectGetMaxX(password.frame) , password.frame.origin.y, mainFieldWidth, password.frame.size.height);
    _newsPassword.placeholder = @"请输入新密码";
    [_newsPassword setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsPassword.delegate = self;
    _newsPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsPassword.leftView = placeholderV2;
    CALayer *readBtnLayer2 = [_newsPassword layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsPassword];
    
    UILabel *makeSurepassword = [[UILabel alloc]init];
    _makesurepasswordLabel = makeSurepassword;
    makeSurepassword.font = [UIFont systemFontOfSize:20];
    makeSurepassword.text = @"确认新密码";
    makeSurepassword.frame = CGRectMake(280, CGRectGetMaxY(password.frame)+ 10, 140, 40);
    [self.view addSubview:makeSurepassword];
    
    _makeSurePassword = [[UITextField alloc]init];
    _makeSurePassword.secureTextEntry = YES;
    _makeSurePassword.borderStyle = UITextBorderStyleLine;
    _makeSurePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _makeSurePassword.frame = CGRectMake(CGRectGetMaxX(makeSurepassword.frame) , makeSurepassword.frame.origin.y, mainFieldWidth, makeSurepassword.frame.size.height);
    _makeSurePassword.placeholder = @"请确认新密码";
    [_makeSurePassword setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _makeSurePassword.delegate = self;
    _makeSurePassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _makeSurePassword.leftView = placeholderV3;
    CALayer *readBtnLayer3 = [_makeSurePassword layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_makeSurePassword];
    
    UIView *line = [[UIView alloc]init];
    _line = line;
    line.frame = CGRectMake(40, CGRectGetMaxY(_makeSurePassword.frame) + 50, SCREEN_WIDTH - 50, 1);
    if (iOS7) {
        line.frame = CGRectMake(40, CGRectGetMaxY(_makeSurePassword.frame) + 50, SCREEN_HEIGHT - 50, 1);
        
    }
    line.backgroundColor = kColor(225, 224, 224, 1.0);
    [self.view addSubview:line];
    
    UIButton *presentBtn = [[UIButton alloc]init];
    _presentBtn = presentBtn;
    [presentBtn addTarget:self action:@selector(presentClick:) forControlEvents:UIControlEventTouchUpInside];
    [presentBtn setTitle:@"提交" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [presentBtn setBackgroundColor:mainColor];
    presentBtn.frame = CGRectMake(CGRectGetMaxX(password.frame) + 20, CGRectGetMaxY(line.frame) + 40, 240, 40);
    [self.view addSubview:presentBtn];
}

-(void)presentClick:(UIButton *)sender
{
    FindPasswordWithPhoneSuccessController *findSuccessVC = [[FindPasswordWithPhoneSuccessController alloc]init];
    [self.navigationController pushViewController:findSuccessVC animated:YES];

    if (![_authField.text isEqualToString:_authCode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_newsPassword.text || [_newsPassword.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"密码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([_newsPassword.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"密码不能少于6位!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_newsPassword.text isEqualToString:_makeSurePassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"两次密码不一致!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_isChecked == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请先验证验证码!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }

    [self findPasswordWithMobile];

}

-(void)backHome
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)authClick:(UIButton *)sender
{
        if (_isMobile) {
            if ([RegularFormat isMobileNumber:_phoneField.text]) {
                [self sendMobileValidate];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"请输入正确的手机号";
            }

        }
        if (!_isMobile) {
        NSLog(@"点击了邮箱！");
        if ([RegularFormat isCorrectEmail:_phoneField.text]) {
            [self sendEmailValidate];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入正确的邮箱号";
        }
    }
}

-(void)makeSureClick:(UIButton *)sender
{
    if (!_authField.text || [_authField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_authField.text isEqualToString:_authCode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码错误!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        UIView *rightBigV = [[UIView alloc]init];
        rightBigV.frame = CGRectMake(0, 0, 60, 40);
        UIImageView *rightV = [[UIImageView alloc]init];
        rightV.frame = CGRectMake(20, 8, 23, 23);
        rightV.image = kImageName(@"check_wrong");
        [rightBigV addSubview:rightV];
        _authField.rightView = rightBigV;
        _isChecked = NO;
        return;
    }
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _authField.rightView = rightBigV;
    _isChecked = YES;
}


- (void)setIsMobile:(BOOL)isMobile {
    _isMobile = isMobile;
    if (_isMobile) {
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _authLabel.hidden = NO;
        _makeSureBtn.hidden = NO;
        _authField.hidden = NO;
        _newpassworLabel.hidden = NO;
        _newsPassword.hidden = NO;
        _makesurepasswordLabel.hidden = NO;
        _makeSurePassword.hidden = NO;
        _presentBtn.hidden = NO;
        _line.hidden = NO;
    }
    else {
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitle:@"发送重置邮箱" forState:UIControlStateNormal];
        _authLabel.hidden = YES;
        _makeSureBtn.hidden = YES;
        _authField.hidden = YES;
        _newpassworLabel.hidden = YES;
        _newsPassword.hidden = YES;
        _makesurepasswordLabel.hidden = YES;
        _makeSurePassword.hidden = YES;
        _presentBtn.hidden = YES;
        _line.hidden = YES;
    }
}

#pragma mark - Request
//发送手机验证码
-(void)sendMobileValidate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendValidateWithMobileNumber:_phoneField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    NSString *validate = [object objectForKey:@"result"];
                    [self resetStatus];
                    self.authCode = validate;
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
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

//发送邮箱
-(void)sendEmailValidate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendEmailValidateWithEmail:_phoneField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    FindPasswordSuccessController *findVC = [[FindPasswordSuccessController alloc]init];
                    findVC.email = _phoneField.text;
                    [self.navigationController pushViewController:findVC animated:YES];
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
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

//通过手机找回密码
-(void)findPasswordWithMobile
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface findPasswordWithUsername:_phoneField.text password:_newsPassword.text validateCode:_authCode finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    FindPasswordWithPhoneSuccessController *findSuccessVC = [[FindPasswordWithPhoneSuccessController alloc]init];
                    [self.navigationController pushViewController:findSuccessVC animated:YES];
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

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneField) {
        if ([string isEqualToString:@""]) {
            //删除
            if ([textField.text length] > 0 && [[textField.text substringToIndex:[textField.text length] - 1] containsString:@"@"]) {
                self.isMobile = NO;
            }
            else {
                self.isMobile = YES;
            }
        }
        else if ([textField.text rangeOfString:@"@"].length != 0 || [string rangeOfString:@"@"].length != 0) {
            self.isMobile = NO;
        }
        else {
            self.isMobile = YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField==_phoneField) {
        self.isMobile = YES;
    }
    return YES;
}

- (void)resetStatus {
    self.isChecked = NO;
    [self countDownStart];
}

//倒计时
- (void)countDownStart {
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendButton.userInteractionEnabled = YES;
                _sendButton.frame = CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height);
                [_sendButton setBackgroundColor:kMainColor];
                [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendButton.userInteractionEnabled = NO;
                _sendButton.frame = CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.6, _phoneField.frame.size.height);
                [_sendButton setBackgroundColor:[UIColor lightGrayColor]];
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_sendButton setBackgroundImage:nil forState:UIControlStateNormal];
                [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_sendButton setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
