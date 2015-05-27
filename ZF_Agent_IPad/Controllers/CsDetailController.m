//
//  CsDetailController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "CsDetailController.h"
#import "AppDelegate.h"
#import "AfterSellController.h"

@interface CsDetailController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIImageView *logistView;
@property(nonatomic,strong)UITextField *logistNameField;
@property(nonatomic,strong)UITextField *loginstNumField;

@end

@implementation CsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CSDataHandle titleForDetailWithCSType:_csType];
    _records = [[NSMutableArray alloc] init];
    _resources = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadCSDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];

}

#pragma mark - Layout

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space {
    CGFloat leftSpace = 60.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 30.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = kColor(108, 108, 108, 1);
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
         WithStr:(NSString *)str{
    CGFloat leftSpace = 60.f;
    CGFloat rightSpce = 20.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = kColor(108, 108, 108, 1);
    CGSize size = CGSizeMake(SCREEN_WIDTH - 400.f,MAXFLOAT); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    label.numberOfLines = 0;
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelsize.height]];
}

- (void)layoutButton:(UIButton *)button position:(OperationBtnType)btnType
{
    CGFloat topSpace = 30.f;
    CGFloat middleSpace = 5.f;
    CGFloat btnWidth = 120.f;
    CGFloat btnHeight = 40.f;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:button];
    if (btnType == OperationBtnCancel) {
        [button addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"取消申请" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        CALayer *readBtnLayer = [button layer];
        [readBtnLayer setMasksToBounds:YES];
        [readBtnLayer setCornerRadius:2.0];
        [readBtnLayer setBorderWidth:1.0];
        [readBtnLayer setBorderColor:[kMainColor CGColor]];
        button.backgroundColor = [UIColor clearColor];
    }
    else if (btnType == OperationBtnSubmitLogist)
    {
        [button addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交物流信息" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CALayer *readBtnLayer1 = [button layer];
        [readBtnLayer1 setMasksToBounds:YES];
        [readBtnLayer1 setCornerRadius:2.0];
        [readBtnLayer1 setBorderWidth:1.0];
        [readBtnLayer1 setBorderColor:[kMainColor CGColor]];
        button.backgroundColor = kMainColor;
    }
    else if (btnType == OperationBtnSubmitCancel)
    {
        [button addTarget:self action:@selector(submitCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"重新提交注销" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CALayer *readBtnLayer1 = [button layer];
        [readBtnLayer1 setMasksToBounds:YES];
        [readBtnLayer1 setCornerRadius:2.0];
        [readBtnLayer1 setBorderWidth:1.0];
        [readBtnLayer1 setBorderColor:[kMainColor CGColor]];
        button.backgroundColor = kMainColor;
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-60.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
}

#pragma mark - Action
//取消申请
-(void)cancelClicked
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消申请？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = AlertViewCancelTag;
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == AlertViewCancelTag) {
            [self cancelApply];
        }
        else if (alertView.tag == AlertViewSubmitTag) {
            [self submitCanncelApply];
        }
    }
}

//重新提交注销
-(void)submitCancelClicked
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定重新提交注销？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = AlertViewSubmitTag;
}

//提交物流信息
-(void)submitClicked
{
    [self initLogisticsViewWithCSModel:nil];
}

-(void)initLogisticsViewWithCSModel:(CSModel *)model
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    _logistView = [[UIImageView alloc]init];
    
    _logistView.frame = CGRectMake(0, 0, width, height);
    
    [self.view.window addSubview:_logistView];
    _logistView.image=[UIImage imageNamed:@"backimage"];
    _logistView.userInteractionEnabled=YES;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 340)];
    whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    whiteView.backgroundColor = [UIColor whiteColor];
    [_logistView addSubview:whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [whiteView addSubview:leftXBtn];
    
    UILabel *FindPOSLable = [[UILabel alloc]init];
    FindPOSLable.text = @"提交物流信息";
    FindPOSLable.textColor = kColor(38, 38, 38, 1.0);
    FindPOSLable.font = [UIFont systemFontOfSize:22];
    FindPOSLable.frame = CGRectMake(150, 10, 200, 40);
    [whiteView addSubview:FindPOSLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(FindPOSLable.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UILabel *POSLable = [[UILabel alloc]init];
    POSLable.text = @"物流公司";
    POSLable.textColor = kColor(56, 56, 56, 1.0);
    POSLable.font = [UIFont systemFontOfSize:20];
    POSLable.frame = CGRectMake(40, CGRectGetMaxY(line.frame) + 40, 120, 30);
    [whiteView addSubview:POSLable];
    
    UILabel *logistNum = [[UILabel alloc]init];
    logistNum.text = @"物流单号";
    logistNum.textColor = kColor(56, 56, 56, 1.0);
    logistNum.font = [UIFont systemFontOfSize:20];
    logistNum.frame = CGRectMake(40, CGRectGetMaxY(POSLable.frame) + 30, 120, 30);
    [whiteView addSubview:logistNum];
    
    _logistNameField = [[UITextField alloc]init];
    _logistNameField.textColor = kColor(119, 120, 120, 1.0);
    _logistNameField.font = [UIFont systemFontOfSize:20];
    _logistNameField.delegate = self;
    _logistNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _logistNameField.leftView = placeholderV;
    CALayer *readBtnLayer = [_logistNameField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    _logistNameField.frame = CGRectMake(CGRectGetMaxX(POSLable.frame) - 25, POSLable.frame.origin.y - 5, 240, 40);
    [whiteView addSubview:_logistNameField];
    
    _loginstNumField = [[UITextField alloc]init];
    _loginstNumField.textColor = kColor(119, 120, 120, 1.0);
    _loginstNumField.font = [UIFont systemFontOfSize:20];
    _loginstNumField.delegate = self;
    _loginstNumField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _loginstNumField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_loginstNumField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    _loginstNumField.frame = CGRectMake(CGRectGetMaxX(POSLable.frame) - 25, logistNum.frame.origin.y - 5, 240, 40);
    [whiteView addSubview:_loginstNumField];
    
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn setBackgroundColor:kMainColor];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(FindPOSLable.frame.origin.x + 10, CGRectGetMaxY(_loginstNumField.frame)+ 60, 100, 40);
    [whiteView addSubview:saveBtn];
    
}

-(void)leftClicked
{
    [_logistView removeFromSuperview];
}

-(void)saveClicked
{
    if (!_logistNameField.text || [_logistNameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"物流公司名字不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_loginstNumField.text || [_loginstNumField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"物流单号不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self submitLogistApply];

}


#pragma mark - Request

- (void)downloadCSDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getCSDetailWithToken:delegate.token csType:_csType csID:_csID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [hud hide:YES];
                    [self parseCSDetailDataWithDictionary:object];
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

-(void)submitLogistApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self .view bringSubviewToFront:hud];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitLogistWithAgentID:delegate.agentID csID:_csID logistName:_logistNameField.text logistNum:_loginstNumField.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [_logistView removeFromSuperview];
                    
                    [hud hide:YES];
                    hud.labelText = @"提交物流信息成功";
                    [self downloadCSDetail];
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

//取消申请
- (void)cancelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csCancelApplyWithToken:delegate.token csType:_csType csID:_csID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"取消申请成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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

//重新提交注销申请
- (void)submitCanncelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csRepeatAppleyWithToken:delegate.token csID:_csID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"提交成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Data

- (void)parseCSDetailDataWithDictionary:(NSDictionary *)dict {
    //重写
}

@end
