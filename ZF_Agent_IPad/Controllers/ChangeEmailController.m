//
//  ChangeEmailController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangeEmailController.h"
#import "ChangeEmialSuccessViewController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"

@interface ChangeEmailController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *newsEmailField;

@property(nonatomic,strong)UITextField *oldEmailField;

@property(nonatomic,strong)UITextField *authCodeField;

@property(nonatomic,strong)UIButton *getAuthCode;

@property(nonatomic,strong)UIButton *makeSureBtn;

@property(nonatomic,assign)BOOL isChecked;

@end

@implementation ChangeEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self getAuthCodeClicked];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改邮箱";
    
    CGFloat mainWidth = 280.f;
    CGFloat mainHeight = 40.f;
    
    UILabel *newEmail = [[UILabel alloc]init];
    newEmail.text = @"新 邮 箱 号";
    [self setLabel:newEmail withTopView:self.view middleSpace:120 labelTag:1];
    
    UILabel *oldEmail = [[UILabel alloc]init];
    oldEmail.text = @"原 邮 箱 号";
    [self setLabel:oldEmail withTopView:newEmail middleSpace:30 labelTag:2];
    
    UILabel *authCode = [[UILabel alloc]init];
    authCode.text = @"验   证   码";
    [self setLabel:authCode withTopView:oldEmail middleSpace:60 labelTag:3];
    
    
    _newsEmailField = [[UITextField alloc]init];
    _newsEmailField.translatesAutoresizingMaskIntoConstraints = NO;
    _newsEmailField.font = [UIFont systemFontOfSize:20];
    _newsEmailField.borderStyle = UITextBorderStyleLine;
    _newsEmailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsEmailField.placeholder = @"请输入新邮箱号";
    [_newsEmailField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsEmailField.delegate = self;
    _newsEmailField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsEmailField.leftView = placeholderV;
    CALayer *readBtnLayer = [_newsEmailField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsEmailField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsEmailField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsEmailField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newEmail
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsEmailField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsEmailField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    _oldEmailField = [[UITextField alloc]init];
    _oldEmailField.userInteractionEnabled = NO;
    _oldEmailField.translatesAutoresizingMaskIntoConstraints = NO;
    _oldEmailField.borderStyle = UITextBorderStyleNone;
    _oldEmailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldEmailField.font = [UIFont systemFontOfSize:20];
    _oldEmailField.text = _oldEmail;
    //    _newsPhoneField.placeholder = @"13919022222";
    //    [_oldPhoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _oldEmailField.delegate = self;
    _oldEmailField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _oldEmailField.leftView = placeholderV2;
    [self.view addSubview:_oldEmailField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsEmailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:oldEmail
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    _getAuthCode = [[UIButton alloc]init];
    [_getAuthCode addTarget:self action:@selector(getAuthCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    _getAuthCode.translatesAutoresizingMaskIntoConstraints = NO;
    [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getAuthCode setTitleColor:kMainColor forState:UIControlStateNormal];
    [_getAuthCode setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_getAuthCode];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsEmailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldEmailField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:260.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];

    _authCodeField = [[UITextField alloc]init];
    _authCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    _authCodeField.borderStyle = UITextBorderStyleLine;
    _authCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeField.placeholder = @"请输入验证码";
    [_authCodeField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _authCodeField.delegate = self;
    _authCodeField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _authCodeField.leftView = placeholderV1;
    _authCodeField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer1 = [_authCodeField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authCodeField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldEmailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:oldEmail
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];

    
    _makeSureBtn = [[UIButton alloc]init];
    _makeSureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_makeSureBtn setBackgroundColor:kMainColor];
    [_makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:_makeSureBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldEmailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_authCodeField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];


    
    UIView *lineV = [[UIView alloc]init];
    lineV.translatesAutoresizingMaskIntoConstraints = NO;
    lineV.backgroundColor = kColor(220, 220, 220, 1.0);
    [self.view addSubview:lineV];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:30.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.f]];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [submitBtn setBackgroundColor:kMainColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:lineV
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newEmail
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:- 50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.9]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];


    
    
}


- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 200.f;
    CGFloat leftSpace = 260.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 2)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
}

-(void)getAuthCodeClicked
{
    [self sendEmailValidate];
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
                _getAuthCode.userInteractionEnabled = YES;
                [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_getAuthCode setTitleColor:kMainColor forState:UIControlStateNormal];
                [_getAuthCode setBackgroundColor:[UIColor clearColor]];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _getAuthCode.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_getAuthCode setBackgroundImage:nil forState:UIControlStateNormal];
                [_getAuthCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [_getAuthCode setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
-(void)makeSureClick:(UIButton *)sender
{
    NSLog(@"点击了检查！");
    if (!_authCodeField.text || [_authCodeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_authCodeField.text isEqualToString:_authCode]) {
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
        _authCodeField.rightView = rightBigV;
        _isChecked = NO;
        return;
    }
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _authCodeField.rightView = rightBigV;
    _isChecked = YES;
}

-(void)submitClicked
{
    if (!_newsEmailField.text || [_newsEmailField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"邮箱不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![RegularFormat isCorrectEmail:_newsEmailField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"邮箱格式不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!_isChecked) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请先验证您的验证码!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self saveDate];
}

-(void)sendEmailValidate
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getPersonModifyEmailValidateWithAgentID:delegate.agentID token:delegate.token email:_oldEmailField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    id authcode = [object objectForKey:@"result"];
                    if (authcode && [authcode isKindOfClass:[NSDictionary class]]) {
                        NSString *validate = [authcode objectForKey:@"dentcode"];
                        self.authCode = validate;
                        [self resetStatus];
                    }
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

#pragma mark - Request
-(void)saveDate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPersonEmailWithAgentID:delegate.agentID token:delegate.token newEmail:_newsEmailField.text validate:_authCode finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self.ChangeEmailSuccessDelegate ChangeEmailSuccessWithEmail:_newsEmailField.text];
                    //点击了提交
                    ChangeEmialSuccessViewController *changeEmailSuccessVC = [[ChangeEmialSuccessViewController alloc]init];
                    changeEmailSuccessVC.hidesBottomBarWhenPushed = YES;
                    changeEmailSuccessVC.email = _newsEmailField.text;
                    [self.navigationController pushViewController:changeEmailSuccessVC animated:YES];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
    
}

@end
