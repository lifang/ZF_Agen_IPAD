//
//  AddMessageController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/5/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AddMessageController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "ChangeEmialSuccessViewController.h"
#import "ChangePhoneSuccessViewController.h"

@interface AddMessageController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *newsField;

@property(nonatomic,strong)UITextField *authCodeField;

@property(nonatomic,strong)UIButton *getAuthCode;

@property(nonatomic,assign)BOOL isChecked;

@property(nonatomic,strong)NSString *authCode;

@property(nonatomic,strong)UILabel *makeSureWrongLabel;

@property(nonatomic,strong)UIButton *makeSureBtn;

@end

@implementation AddMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    if (_isEmial) {
        self.title = @"添加邮箱";
    }
    if (_isPhone) {
        self.title = @"添加手机";
    }
    
    CGFloat mainWidth = 270.f;
    CGFloat mainHeight = 40.f;
    
    UILabel *newLabel = [[UILabel alloc]init];
    if (_isEmial) {
        newLabel.text = @"新 邮 箱 号";
    }
    if (_isPhone) {
        newLabel.text = @"新 手 机 号";
    }
    [self setLabel:newLabel withTopView:self.view middleSpace:115.f labelTag:1];
    
    UILabel *authCodeLabel = [[UILabel alloc]init];
    authCodeLabel.text = @"验  证  码";
    [self setLabel:authCodeLabel withTopView:newLabel middleSpace:30.f labelTag:2];
    
    _newsField = [[UITextField alloc]init];
    _newsField.translatesAutoresizingMaskIntoConstraints = NO;
    _newsField.borderStyle = UITextBorderStyleLine;
    _newsField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (_isPhone) {
        _newsField.placeholder = @"请输入新手机号";
    }
    if (_isEmial) {
        _newsField.placeholder = @"请输入新邮箱号";
    }
    [_newsField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsField.delegate = self;
    _newsField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsField.leftView = placeholderV4;
    _newsField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer4 = [_newsField layer];
    [readBtnLayer4 setMasksToBounds:YES];
    [readBtnLayer4 setCornerRadius:2.0];
    [readBtnLayer4 setBorderWidth:1.0];
    [readBtnLayer4 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    _getAuthCode = [[UIButton alloc]init];
    [_getAuthCode addTarget:self action:@selector(getAuthCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    _getAuthCode.translatesAutoresizingMaskIntoConstraints = NO;
    _getAuthCode.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCode setBackgroundColor:kMainColor];
    [self.view addSubview:_getAuthCode];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:10.f]];
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
    UIView *placeholderV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _authCodeField.leftView = placeholderV3;
    _authCodeField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer3 = [_authCodeField layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authCodeField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newLabel
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
    _makeSureBtn.hidden = YES;
    [_makeSureBtn addTarget:self action:@selector(makeSureClieked) forControlEvents:UIControlEventTouchUpInside];
    _makeSureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_makeSureBtn setBackgroundColor:kMainColor];
    [_makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:_makeSureBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:mainWidth + 20]];
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
                                                           constant:70.f]];
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
                                                           constant:50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:authCodeLabel
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
    [_newsField resignFirstResponder];
    if (_isPhone) {
        [self sendMobile];
    }
    if (_isEmial) {
        [self sendEmail];
    }
}

-(void)sendMobile
{
    if (!_newsField.text || [_newsField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"新手机号不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![RegularFormat isMobileNumber:_newsField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"手机号格式不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self sendMobileValidate];
}

-(void)sendEmail
{
    if (!_newsField.text || [_newsField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"邮箱号不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![RegularFormat isCorrectEmail:_newsField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"邮箱号格式不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
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
                [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getAuthCode setBackgroundColor:kMainColor];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _getAuthCode.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_getAuthCode setBackgroundColor:[UIColor lightGrayColor]];
                [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getAuthCode setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(void)makeSureClieked
{
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
    if (_isChecked == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请先验证验证码!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    if (_isPhone) {
        [self saveMobileDate];
    }
    if (_isEmial) {
        [self saveEmailDate];
    }
    
}

-(void)saveMobileDate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPersonMobileWithAgentID:delegate.agentUserID token:delegate.token newPhoneNumber:_newsField.text validate:_authCode finished:^(BOOL success, NSData *response) {
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
                    ChangePhoneSuccessViewController *changeSuccessVC = [[ChangePhoneSuccessViewController alloc]init];
                    changeSuccessVC.phone = _newsField.text;
                    changeSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:changeSuccessVC animated:YES];
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

#pragma mark - Request
-(void)saveEmailDate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPersonEmailWithAgentID:delegate.agentUserID token:delegate.token newEmail:_newsField.text validate:_authCode finished:^(BOOL success, NSData *response) {
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
                    ChangeEmialSuccessViewController *changeSuccessVC = [[ChangeEmialSuccessViewController alloc]init];
                    changeSuccessVC.email = _newsField.text;
                    changeSuccessVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:changeSuccessVC animated:YES];
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

//发送手机验证码
-(void)sendMobileValidate
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getPersonModifyMobileValidateWithAgentID:delegate.agentUserID token:delegate.token phoneNumber:_newsField.text finished:^(BOOL success, NSData *response) {
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


//发送邮箱
-(void)sendEmailValidate
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getPersonModifyEmailValidateWithAgentID:delegate.agentUserID token:delegate.token email:_newsField.text finished:^(BOOL success, NSData *response) {
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _authCodeField) {
        if ([_authCodeField.text isEqualToString:_authCode]) {
            UIView *rightBigV = [[UIView alloc]init];
            rightBigV.frame = CGRectMake(0, 0, 60, 40);
            UIImageView *rightV = [[UIImageView alloc]init];
            rightV.frame = CGRectMake(20, 8, 23, 23);
            rightV.image = kImageName(@"check_right");
            [rightBigV addSubview:rightV];
            _authCodeField.rightView = rightBigV;
            [_makeSureWrongLabel removeFromSuperview];
            _isChecked = YES;
        }else
        {
            UIView *rightBigV = [[UIView alloc]init];
            rightBigV.frame = CGRectMake(0, 0, 60, 40);
            UIImageView *rightV = [[UIImageView alloc]init];
            rightV.frame = CGRectMake(20, 8, 23, 23);
            rightV.image = kImageName(@"check_wrong");
            [rightBigV addSubview:rightV];
            _authCodeField.rightView = rightBigV;
            _isChecked = NO;
            
            _makeSureWrongLabel = [[UILabel alloc]init];
            _makeSureWrongLabel.font = [UIFont systemFontOfSize:10];
            _makeSureWrongLabel.textColor = kColor(230, 68, 67, 1.0);
            _makeSureWrongLabel.text = @"验证码不正确，请重新填写";
            _makeSureWrongLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:_makeSureWrongLabel];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_authCodeField
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:2.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_makeSureBtn
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:- 140.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:140.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:15.f]];
            return;
        }
    }
}

@end
