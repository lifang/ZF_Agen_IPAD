//
//  BaseInformationViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "BaseInformationViewController.h"
#import "NetworkInterface.h"
#import "PersonModel.h"
#import "AppDelegate.h"
#import "CityHandle.h"

@interface BaseInformationViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) PersonModel *personInfo;

@property(nonatomic,strong)UIScrollView *mainScrollView;

@property(nonatomic,strong)UILabel *firstLabel;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,strong)UILabel *authCodeLabel;

@property(nonatomic,strong)UITextField *agentTypeField;
@property(nonatomic,strong)UITextField *companyNameField;
@property(nonatomic,strong)UITextField *companyBusinesslicenseField;
@property(nonatomic,strong)UITextField *companyTaxField;
@property(nonatomic,strong)UITextField *principalNameField;
@property(nonatomic,strong)UITextField *principalCardField;
@property(nonatomic,strong)UITextField *principalPhoneOrEmailField;
@property(nonatomic,strong)UITextField *authCodeField;
@property(nonatomic,strong)UITextField *locationField;
@property(nonatomic,strong)UITextField *particularLocationField;
@property(nonatomic,strong)UITextField *loginIDField;
@property(nonatomic,strong)UITextField *loginPasswordField;
@property(nonatomic,strong)UITextField *makeSurePasswordField;

@property(nonatomic,strong)UIButton *getAuthCodeBtn;
@property(nonatomic,strong)UIButton *makeSureBtn;
@property(nonatomic,strong)UIButton *IdCardNumImageBtn;
@property(nonatomic,strong)UIButton *businesslicenseImageBtn;
@property(nonatomic,strong)UIButton *taxregisterImageBtn;


@end

@implementation BaseInformationViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.swithView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getPersonDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request

- (void)getPersonDetailInfo {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getPersonDetailWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    id personDict = [object objectForKey:@"result"];
                    if ([personDict isKindOfClass:[NSDictionary class]]) {
                        _personInfo = [[PersonModel alloc] initWithParseDictionary:personDict];
                        [self initAndLayoutUI];
                    }
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

#pragma mark - UI
-(void)initAndLayoutUI
{
    CGFloat mainMargin = 20.f;
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(160, 0, kScreenWidth - 160, kScreenHeight);
    if (iOS7) {
        _mainScrollView.frame = CGRectMake(160, 0, kScreenHeight - 160, kScreenWidth);
    }
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth - 160, 1370);
    if (iOS7) {
        _mainScrollView.contentSize = CGSizeMake(kScreenHeight - 160, 1370);
    }
    [self.view addSubview:_mainScrollView];
    
#pragma mark - 创建label
    UILabel *agentTypeLable = [[UILabel alloc]init];
    self.secondLabel = agentTypeLable;
    agentTypeLable.text = @"代理商类型:";
    [self setLabel:agentTypeLable withTopView:_mainScrollView middleSpace:100.f labelTag:1];
    
    UILabel *companyNameLabel = [[UILabel alloc]init];
    self.firstLabel = companyNameLabel;
    companyNameLabel.text = @"公司名称";
    [self setLabel:companyNameLabel withTopView:agentTypeLable middleSpace:mainMargin labelTag:0];
    
    UILabel *companyBusinesslicenseLabel = [[UILabel alloc]init];
    companyBusinesslicenseLabel.text = @"公司营业执照登记号";
    [self setLabel:companyBusinesslicenseLabel withTopView:companyNameLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *companyTaxLabel = [[UILabel alloc]init];
    companyTaxLabel.text = @"公司税务登记证号";
    [self setLabel:companyTaxLabel withTopView:companyBusinesslicenseLabel middleSpace:mainMargin labelTag:0];
    
    UIView *firstLine = [[UIView alloc]init];
    [self setLine:firstLine withTopView:companyTaxLabel middleSpace:60.f];
    
    UILabel *principalNameLabel = [[UILabel alloc]init];
    principalNameLabel.text = @"负责人姓名";
    [self setLabel:principalNameLabel withTopView:firstLine middleSpace:60.f labelTag:0];
    
    UILabel *principalIDLabel = [[UILabel alloc]init];
    principalIDLabel.text = @"负责人身份证号";
    [self setLabel:principalIDLabel withTopView:principalNameLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *principalPhoneOrEmailLabel = [[UILabel alloc]init];
    principalPhoneOrEmailLabel.text = @"手机";
    [self setLabel:principalPhoneOrEmailLabel withTopView:principalIDLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *authCodeFieldLabel = [[UILabel alloc]init];
    authCodeFieldLabel.text = @"邮箱";
    self.authCodeLabel = authCodeFieldLabel;
    [self setLabel:authCodeFieldLabel withTopView:principalPhoneOrEmailLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"所在地";
    [self setLabel:locationLabel withTopView:authCodeFieldLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *particularLocationLabel = [[UILabel alloc]init];
    particularLocationLabel.hidden = YES;
    particularLocationLabel.text = @"详细地址";
    [self setLabel:particularLocationLabel withTopView:locationLabel middleSpace:mainMargin labelTag:0];
    
    UIView *secondLine = [[UIView alloc]init];
    [self setLine:secondLine withTopView:particularLocationLabel middleSpace:40.f];
    
    UILabel *idCardImageLabel = [[UILabel alloc]init];
    idCardImageLabel.text = @"身份证照片";
    [self setLabel:idCardImageLabel withTopView:secondLine middleSpace:40.f labelTag:0];
    
    UILabel *businesslicenseImageLabel = [[UILabel alloc]init];
    businesslicenseImageLabel.text = @"营业执照照片";
    [self setLabel:businesslicenseImageLabel withTopView:idCardImageLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *taxregisterImageLabel = [[UILabel alloc]init];
    taxregisterImageLabel.text = @"税务登记照片";
    [self setLabel:taxregisterImageLabel withTopView:businesslicenseImageLabel middleSpace:mainMargin labelTag:0];
    
    UIView *thirdLine = [[UIView alloc]init];
    [self setLine:thirdLine withTopView:taxregisterImageLabel middleSpace:40.f];
    
    UILabel *loginIDLabel = [[UILabel alloc]init];
    loginIDLabel.text = @"登录ID";
    [self setLabel:loginIDLabel withTopView:thirdLine middleSpace:40.f labelTag:0];
    
    UIView *fourthLine = [[UIView alloc]init];
    [self setLine:fourthLine withTopView:loginIDLabel middleSpace:40.f];
    
#pragma mark - 创建TextField
    _agentTypeField = [[UITextField alloc]init];
    NSString *typeString = nil;
    if ([_personInfo.type intValue] == AgentTypeCompany) {
        typeString = @"公司";
    }
    else {
        typeString = @"个人";
    }
    _agentTypeField.text = typeString;
    [self setField:_agentTypeField withTopView:_mainScrollView middleSpace:100.f fieldTag:1];
    
    _companyNameField = [[UITextField alloc]init];
    _companyNameField.text = _personInfo.companyName;
    [self setField:_companyNameField withTopView:_agentTypeField middleSpace:mainMargin fieldTag:0];
    
    _companyBusinesslicenseField = [[UITextField alloc]init];
    _companyBusinesslicenseField.text = _personInfo.licenseNumber;
    [self setField:_companyBusinesslicenseField withTopView:_companyNameField middleSpace:mainMargin fieldTag:0];
    
    _companyTaxField = [[UITextField alloc]init];
    _companyTaxField.text = _personInfo.taxNumber;
    [self setField:_companyTaxField withTopView:_companyBusinesslicenseField middleSpace:mainMargin fieldTag:0];
    
    _principalNameField = [[UITextField alloc]init];
    _principalNameField.text = _personInfo.personName;
    [self setField:_principalNameField withTopView:firstLine middleSpace:60.f fieldTag:0];
    
    _principalCardField = [[UITextField alloc]init];
    _principalCardField.text = _personInfo.personCardID;
    [self setField:_principalCardField withTopView:_principalNameField middleSpace:mainMargin fieldTag:0];
    
    _principalPhoneOrEmailField = [[UITextField alloc]init];
    _principalPhoneOrEmailField.text = _personInfo.mobileNumber;
    [self setField:_principalPhoneOrEmailField withTopView:_principalCardField middleSpace:mainMargin fieldTag:5];
    
    _authCodeField = [[UITextField alloc]init];
    _authCodeField.text = _personInfo.email;
    [self setField:_authCodeField withTopView:_principalPhoneOrEmailField middleSpace:mainMargin fieldTag:6];
    
    _locationField = [[UITextField alloc]init];
    _locationField.text = [CityHandle getCityNameWithCityID:_personInfo.cityID];
    [self setField:_locationField withTopView:_authCodeField middleSpace:mainMargin fieldTag:2];
    
    _particularLocationField = [[UITextField alloc]init];
    _particularLocationField.text = _personInfo.address;
    _particularLocationField.hidden = YES;
    [self setField:_particularLocationField withTopView:_locationField middleSpace:mainMargin fieldTag:0];
    
    _loginIDField = [[UITextField alloc]init];
    _loginIDField.text = _personInfo.userName;
    [self setField:_loginIDField withTopView:thirdLine middleSpace:40.f fieldTag:0];
    
#pragma mark - 创建Button
    _getAuthCodeBtn = [[UIButton alloc]init];
    [_getAuthCodeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self setBtn:_getAuthCodeBtn withTopView:_principalCardField middleSpace:mainMargin buttonTag:1];
    
    _makeSureBtn = [[UIButton alloc]init];
    [_makeSureBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self setBtn:_makeSureBtn withTopView:_getAuthCodeBtn middleSpace:mainMargin buttonTag:2];
    
    _IdCardNumImageBtn = [[UIButton alloc]init];
    [_IdCardNumImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_IdCardNumImageBtn withTopView:secondLine middleSpace:40.f buttonTag:3];
    
    _businesslicenseImageBtn = [[UIButton alloc]init];
    [_businesslicenseImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_businesslicenseImageBtn withTopView:_IdCardNumImageBtn middleSpace:mainMargin buttonTag:4];
    
    _taxregisterImageBtn = [[UIButton alloc]init];
    [_taxregisterImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_taxregisterImageBtn withTopView:_businesslicenseImageBtn middleSpace:mainMargin buttonTag:5];
    
    //创建下方Btn
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [submitBtn addTarget:self action:@selector(presentClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:kMainColor];
    [_mainScrollView addSubview:submitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:fourthLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40.f]];
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:kScreenHeight / 2 - 120.f]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:kScreenWidth / 2 - 120.f]];
        
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:240.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    [self.view bringSubviewToFront:self.swithView];

}
//创建各种Btn
//topView-上方控件
//space-距上方间距
-(void)setBtn:(UIButton *)button
  withTopView:(UIView *)topView
  middleSpace:(CGFloat)space
    buttonTag:(int)BtnTag{
    CGFloat btnWidth = 100.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 10.f;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:kMainColor forState:UIControlStateNormal];
    button.tag = 1333 + BtnTag;
    [button addTarget:self action:@selector(BlueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:button];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    if (BtnTag >= 3)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_firstLabel
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundImage:kImageName(@"haveImage") forState:UIControlStateNormal];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:40]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:40]];
    }else{
        if (BtnTag == 1) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_principalPhoneOrEmailField
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0.f]];
        }
        if (BtnTag == 2) {
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_authCodeField
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0.f]];
        }else{
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_authCodeField
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:leftSpace]];
        }
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
    
}

//创建textField
//topView-上方控件
//space-距上方间距
-(void)setField:(UITextField *)textField
    withTopView:(UIView *)topView
    middleSpace:(CGFloat)space
       fieldTag:(int)FieldTag{
    CGFloat fieldWidth = 240.f;
    CGFloat fieldHeight = 40.f;
    CGFloat leftSpace = 10.f;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.font = [UIFont systemFontOfSize:20];
    textField.textColor = kColor(105, 105, 105, 1.0);
    textField.borderStyle = UITextBorderStyleLine;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    textField.delegate = self;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    textField.leftView = leftV;
    CALayer *readBtnLayer = [textField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_mainScrollView addSubview:textField];
    textField.userInteractionEnabled = NO;
    if (FieldTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_secondLabel
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:leftSpace]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_firstLabel
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        
    }
    if (FieldTag == 5) {
        CGFloat width = [self contentWidthWithStr:_personInfo.mobileNumber];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:width + 20.f]];
    }
    if (FieldTag == 6) {
        CGFloat width = [self contentWidthWithStr:_personInfo.email];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:width + 20.f]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:fieldWidth]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:fieldHeight]];
}


//创建左边Label
//topView-上方控件
//space-距上方间距
- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 40.f;
    CGFloat labelWidth = 300.f;
    CGFloat leftSpace = 50.f;
    label.textAlignment = NSTextAlignmentRight;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [_mainScrollView addSubview:label];
    if (LabelTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace - 60.f]];
    }else{
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
    }
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

-(CGFloat)contentWidthWithStr:(NSString *)str
{
    CGFloat contentW = 0.f;
    UIFont *font = [UIFont systemFontOfSize:20];
    CGRect tempRect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    contentW = tempRect.size.width;
    return contentW;
}

//创建分割线
- (void)setLine:(UIView *)line
    withTopView:(UIView *)topView
    middleSpace:(CGFloat)space{
    
    CGFloat lineWidth = kScreenWidth - 240.f;
    if (iOS7) {
        lineWidth = kScreenHeight - 240.f;
    }
    CGFloat lineHeight = 0.7f;
    CGFloat leftSpace = 170.f;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = kColor(221, 220, 220, 1.0);
    [_mainScrollView addSubview:line];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:lineWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:lineHeight]];
    
}

#pragma mark - Action
-(void)presentClick
{
    //退出按钮
}
-(void)BlueBtnClicked:(UIButton *)sender
{
    if (sender.tag == 1336) {
        NSLog(@"第一张图片");
        UIButton *btn = (UIButton *)sender;
        CGRect convertRect = [[btn superview] convertRect:btn.frame toView:self.view];
            [self showDetailImageWithURL:_personInfo.cardImagePath imageRect:convertRect WithIdentifier:@"无导航栏"];
    }
    if (sender.tag == 1337) {
        UIButton *btn = (UIButton *)sender;
        CGRect convertRect = [[btn superview] convertRect:btn.frame toView:self.view];
        [self showDetailImageWithURL:_personInfo.licenseImagePath imageRect:convertRect WithIdentifier:@"无导航栏"];
    }
    if (sender.tag == 1338) {
        UIButton *btn = (UIButton *)sender;
        CGRect convertRect = [[btn superview] convertRect:btn.frame toView:self.view];
        [self showDetailImageWithURL:_personInfo.taxImagePath imageRect:convertRect WithIdentifier:@"无导航栏"];
    }
}
@end
