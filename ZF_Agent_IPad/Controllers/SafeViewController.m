//
//  SafeViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SafeViewController.h"
#import "NetworkInterface.h"

@interface SafeViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *oldPasswordField;
@property(nonatomic,strong)UITextField *newsPasswordField;
@property(nonatomic,strong)UITextField *makeSureField;

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    [self.swithView setSelectedBtnAtIndex:2];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthAR]] boolValue]) {
        [self initUI];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"您没有查看代理商资料权限";
    }
    self.swithView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    CGFloat btnWidth = 280.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 290.f;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"原 密 码";
    [self setLabel:nameLabel withTopView:self.swithView middleSpace:20 labelTag:1];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"新 密 码";
    [self setLabel:phoneLabel withTopView:nameLabel middleSpace:12 labelTag:1];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.text = @"确认密码";
    [self setLabel:emailLabel withTopView:phoneLabel middleSpace:12 labelTag:1];

    _oldPasswordField = [[UITextField alloc]init];
    _oldPasswordField.secureTextEntry = YES;
    _oldPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    _oldPasswordField.borderStyle = UITextBorderStyleLine;
    _oldPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPasswordField.placeholder = @"";
    [_oldPasswordField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_oldPasswordField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _oldPasswordField.delegate = self;
    _oldPasswordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _oldPasswordField.leftView = placeholderV;
    CALayer *readBtnLayer = [_oldPasswordField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_oldPasswordField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPasswordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.swithView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:46.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPasswordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPasswordField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPasswordField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _newsPasswordField = [[UITextField alloc]init];
    _newsPasswordField.secureTextEntry = YES;
    _newsPasswordField.translatesAutoresizingMaskIntoConstraints = NO;
    _newsPasswordField.borderStyle = UITextBorderStyleLine;
    _newsPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsPasswordField.placeholder = @"";
    [_newsPasswordField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_newsPasswordField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _newsPasswordField.delegate = self;
    _newsPasswordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsPasswordField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_newsPasswordField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsPasswordField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPasswordField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldPasswordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPasswordField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPasswordField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPasswordField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];

    _makeSureField = [[UITextField alloc]init];
    _makeSureField.secureTextEntry = YES;
    _makeSureField.translatesAutoresizingMaskIntoConstraints = NO;
    _makeSureField.borderStyle = UITextBorderStyleLine;
    _makeSureField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _makeSureField.placeholder = @"";
    [_makeSureField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_makeSureField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _makeSureField.delegate = self;
    _makeSureField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _makeSureField.leftView = placeholderV2;
    CALayer *readBtnLayer2 = [_makeSureField layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_makeSureField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsPasswordField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [saveBtn setBackgroundColor:kMainColor];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:saveBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_makeSureField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];

    
    

    
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 100.f;
    CGFloat leftSpace = 200.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 2.5]];
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
}

//点击了保存
-(void)saveClicked
{
    if (!_oldPasswordField.text || [_oldPasswordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入原密码";
        return;
    }
    if (!_newsPasswordField.text || [_newsPasswordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入新密码";
        return;
    }
    if (!_makeSureField.text || [_makeSureField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请再次输入新密码";
        return;
    }
    if (![_makeSureField.text isEqualToString:_newsPasswordField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"两次输入的密码不一致";
        return;
    }
    [_makeSureField becomeFirstResponder];
    [_makeSureField resignFirstResponder];
    [self modifyPassword];

}

#pragma mark - Request

- (void)modifyPassword {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyPasswordWithAgentID:delegate.agentUserID token:delegate.token primaryPassword:_oldPasswordField.text newPassword:_newsPasswordField.text finished:^(BOOL success, NSData *response) {
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"用户信息修改成功"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    _oldPasswordField.text = nil;
                    _newsPasswordField.text = nil;
                    _makeSureField.text = nil;
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
