//
//  RegisterViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/3.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "RegisterViewController.h"
#import "CityHandle.h"
#import "PhoneSuccessViewController.h"
#import "EmailSuccessViewController.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIScrollView *mainScrollView;

@property(nonatomic,strong)UILabel *firstLabel;
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

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,strong)NSString *authCode;

//图片相关
@property(nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic, assign) CGRect imageRect;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableDictionary *dict;
@property(nonatomic,strong)UIImage *IDCardImg;
@property(nonatomic,strong)UIImage *bussinessImg;
@property(nonatomic,strong)UIImage *taxImg;
@property(nonatomic,strong)NSString *imageStatus;

//选择城市
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSString *cityId;

@property(nonatomic,strong)NSString *selectedCityID;
@property(nonatomic,assign)BOOL isChange;

//代理商选择
@property(nonatomic,strong)UITableView *agentTypeTableView;
//判断是否是手机
@property(nonatomic,assign)BOOL isMobile;

@property(nonatomic,assign)AgentType agentType;

@property(nonatomic,strong)NSString *imageStr1;
@property(nonatomic,strong)NSString *imageStr2;
@property(nonatomic,strong)NSString *imageStr3;

@property(nonatomic,strong)UISwitch *fenrunSwitch;

@end

@implementation RegisterViewController

-(UITableView *)agentTypeTableView
{
    if (!_agentTypeTableView) {
        _agentTypeTableView = [[UITableView alloc]init];
        _agentTypeTableView.delegate = self;
        _agentTypeTableView.dataSource = self;
        _agentTypeTableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _agentTypeTableView;
}

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
    self.agentType = AgentTypeCompany;
    self.isMobile = YES;
    self.authCode = @"123";
    self.imageArray = [[NSMutableArray alloc]init];
    _IDCardImg = [[UIImage alloc]init];
    _bussinessImg = [[UIImage alloc]init];
    _taxImg = [[UIImage alloc]init];
    _dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [self setupNavBar];
    [self initAndLayoutUI];
    [self initPickerView];
}

-(void)setupNavBar
{
    self.title = @"申请成为代理商";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBarHidden = NO;
}

-(void)initAndLayoutUI
{
    CGFloat mainMargin = 10.f;
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    if (iOS7) {
        _mainScrollView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    }
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1370);
    if (iOS7) {
        _mainScrollView.contentSize = CGSizeMake(kScreenHeight, 1370);
    }
    [self.view addSubview:_mainScrollView];
    
#pragma mark - 开通分润
    _fenrunSwitch = [[UISwitch alloc]init];
    _fenrunSwitch.backgroundColor = [UIColor clearColor];
    _fenrunSwitch.onTintColor = kMainColor;
    _fenrunSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [_fenrunSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_fenrunSwitch];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fenrunSwitch
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:34.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fenrunSwitch
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:900.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fenrunSwitch
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:85]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fenrunSwitch
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:50]];
    
    UILabel *fenrunLabel = [[UILabel alloc]init];
    fenrunLabel.text = @"开通分润";
    fenrunLabel.textAlignment = NSTextAlignmentRight;
    fenrunLabel.translatesAutoresizingMaskIntoConstraints = NO;
    fenrunLabel.backgroundColor = [UIColor clearColor];
    fenrunLabel.font = [UIFont systemFontOfSize:20.f];
    fenrunLabel.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:fenrunLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:fenrunLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:30.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:fenrunLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_fenrunSwitch
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant: - 200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:fenrunLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:85]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:fenrunLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40]];
    
#pragma mark - 创建label
    UILabel *agentTypeLable = [[UILabel alloc]init];
    agentTypeLable.text = @"代理商类型";
    self.firstLabel = agentTypeLable;
    [self setLabel:agentTypeLable withTopView:_mainScrollView middleSpace:30.f labelTag:1];
    
    UILabel *companyNameLabel = [[UILabel alloc]init];
    companyNameLabel.text = @"公司名称";
    [self setLabel:companyNameLabel withTopView:agentTypeLable middleSpace:60.f labelTag:0];
    
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
    
    UILabel *loginPasswordLabel = [[UILabel alloc]init];
    loginPasswordLabel.text = @"登录密码";
    [self setLabel:loginPasswordLabel withTopView:loginIDLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *makeSureLabel = [[UILabel alloc]init];
    makeSureLabel.text = @"确认密码";
    [self setLabel:makeSureLabel withTopView:loginPasswordLabel middleSpace:mainMargin labelTag:0];
    
    UIView *fourthLine = [[UIView alloc]init];
    [self setLine:fourthLine withTopView:makeSureLabel middleSpace:40.f];
    
#pragma mark - 创建TextField
    _agentTypeField = [[UITextField alloc]init];
    [self setField:_agentTypeField withTopView:_mainScrollView middleSpace:30.f fieldTag:1];
    
    _companyNameField = [[UITextField alloc]init];
    [self setField:_companyNameField withTopView:_agentTypeField middleSpace:60.f fieldTag:0];
    
    _companyBusinesslicenseField = [[UITextField alloc]init];
    [self setField:_companyBusinesslicenseField withTopView:_companyNameField middleSpace:mainMargin fieldTag:0];
    
    _companyTaxField = [[UITextField alloc]init];
    [self setField:_companyTaxField withTopView:_companyBusinesslicenseField middleSpace:mainMargin fieldTag:0];
    
    _principalNameField = [[UITextField alloc]init];
    [self setField:_principalNameField withTopView:firstLine middleSpace:60.f fieldTag:0];
    
    _principalCardField = [[UITextField alloc]init];
    [self setField:_principalCardField withTopView:_principalNameField middleSpace:mainMargin fieldTag:0];
    
    _principalPhoneOrEmailField = [[UITextField alloc]init];
    [self setField:_principalPhoneOrEmailField withTopView:_principalCardField middleSpace:mainMargin fieldTag:0];
    
    _authCodeField = [[UITextField alloc]init];
    [self setField:_authCodeField withTopView:_principalPhoneOrEmailField middleSpace:mainMargin fieldTag:0];
    
    _locationField = [[UITextField alloc]init];
    [self setField:_locationField withTopView:_authCodeField middleSpace:mainMargin fieldTag:2];
    
    _particularLocationField = [[UITextField alloc]init];
    [self setField:_particularLocationField withTopView:_locationField middleSpace:mainMargin fieldTag:0];
    
    _loginIDField = [[UITextField alloc]init];
    [self setField:_loginIDField withTopView:thirdLine middleSpace:40.f fieldTag:0];
    
    _loginPasswordField = [[UITextField alloc]init];
    [self setField:_loginPasswordField withTopView:_loginIDField middleSpace:mainMargin fieldTag:0];
    
    _makeSurePasswordField = [[UITextField alloc]init];
    [self setField:_makeSurePasswordField withTopView:_loginPasswordField middleSpace:mainMargin fieldTag:0];

#pragma mark - 创建Button
    _getAuthCodeBtn = [[UIButton alloc]init];
    [_getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setBtn:_getAuthCodeBtn withTopView:_principalCardField middleSpace:mainMargin buttonTag:1];
    
    _makeSureBtn = [[UIButton alloc]init];
    [_makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self setBtn:_makeSureBtn withTopView:_getAuthCodeBtn middleSpace:mainMargin buttonTag:2];
    
    _IdCardNumImageBtn = [[UIButton alloc]init];
    [_dict setObject:@"YES" forKey:@"1"];
    [_IdCardNumImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_IdCardNumImageBtn withTopView:secondLine middleSpace:40.f buttonTag:3];
    
    _businesslicenseImageBtn = [[UIButton alloc]init];
    [_dict setObject:@"YES" forKey:@"2"];
    [_businesslicenseImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_businesslicenseImageBtn withTopView:_IdCardNumImageBtn middleSpace:mainMargin buttonTag:4];
    
    _taxregisterImageBtn = [[UIButton alloc]init];
    [_dict setObject:@"YES" forKey:@"3"];
    [_taxregisterImageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [self setBtn:_taxregisterImageBtn withTopView:_businesslicenseImageBtn middleSpace:mainMargin buttonTag:5];
    _makeSureBtn.hidden = YES;
    _getAuthCodeBtn.hidden = YES;
    
    //创建下方Btn
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [submitBtn addTarget:self action:@selector(presentClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
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
    [button setBackgroundColor:kMainColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [_mainScrollView addSubview:textField];
    if (FieldTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
        textField.userInteractionEnabled = NO;
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.tag = 1234 + FieldTag;
        rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setBackgroundImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
        [_mainScrollView addSubview:rightBtn];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_firstLabel
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:leftSpace + 180.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:60.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:40.f]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
            
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_firstLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:fieldWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:fieldHeight]];
    if (FieldTag == 2) {
        textField.userInteractionEnabled = NO;
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.tag = 1234 + FieldTag;
        rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setBackgroundImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
        [_mainScrollView addSubview:rightBtn];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space + 40.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_firstLabel
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:leftSpace + 180.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:60.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:40.f]];
    }
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
    CGFloat leftSpace = 20.f;
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
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
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

//创建分割线
- (void)setLine:(UIView *)line
     withTopView:(UIView *)topView
    middleSpace:(CGFloat)space{
    
    CGFloat lineWidth = kScreenWidth - 160.f;
    if (iOS7) {
        lineWidth = kScreenHeight - 160.f;
    }
    CGFloat lineHeight = 0.7f;
    CGFloat leftSpace = 80.f;
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

-(void)initAgentTableView
{
    [_mainScrollView addSubview:self.agentTypeTableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_agentTypeTableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_firstLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_agentTypeTableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_firstLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_agentTypeTableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:240.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_agentTypeTableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:90.f]];

}

#pragma mark - 判断是手机还是邮箱
-(void)setIsMobile:(BOOL)isMobile
{
    _isMobile = isMobile;
    if (_isMobile) {
        NSLog(@"是手机！");
        _authCodeLabel.hidden = YES;
        _authCodeField.hidden = YES;
        _makeSureBtn.hidden = YES;
        _getAuthCodeBtn.hidden = YES;
    }
    else {
        NSLog(@"不是手机");
        _authCodeLabel.hidden = YES;
        _authCodeField.hidden = YES;
        _makeSureBtn.hidden = YES;
        _getAuthCodeBtn.hidden = YES;
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        //删除
        if ([textField.text length] > 0 && [[textField.text substringToIndex:[textField.text length] - 1] rangeOfString:@"@"].length != 0) {
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
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == _principalPhoneOrEmailField) {
        self.isMobile = YES;
    }
    return YES;
}

#pragma mark - tabelviewDateSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"个人";
    }else{
        cell.textLabel.text = @"公司";
    }
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _agentTypeField.text = nil;
        _agentTypeField.text = @"个人";
        _agentType = AgentTypePerson;
    }
    else{
        _agentTypeField.text = nil;
        _agentTypeField.text = @"公司";
        _agentType = AgentTypeCompany;
    }
    [_agentTypeTableView removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Action
-(void)presentClick
{
    NSLog(@"点击了提交！");
    if (_isMobile) {
        [self registeApply];
       
    }else{
        [self registeApply];
//        EmailSuccessViewController *emilVC = [[EmailSuccessViewController alloc]init];
//        emilVC.email = @"78979879@qq.com";
//        [self.navigationController pushViewController:emilVC animated:YES];
    }
}

-(void)rightBtnClicked:(UIButton *)button
{
    if (button.tag == 1235) {
        NSLog(@"点击了选择代理商类型!");
        [self initAgentTableView];
    }
    if (button.tag == 1236) {
        NSLog(@"点击了所在地选择！");
        [self pickerScrollIn];
    }
    
}

-(void)BlueBtnClicked:(UIButton *)button
{
    if (button.tag == 1334) {
        NSLog(@"点击了验证码！");
        if (!_principalPhoneOrEmailField.text || [_principalPhoneOrEmailField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"手机号不能为空!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self authApply];
    }
    if (button.tag == 1335) {
        NSLog(@"点击了检查！");
        [self makeSureClicked];
    }

    if (button.tag == 1336) {
        if ([[_dict objectForKey:@"1"] isEqualToString:@"NO"]) {
            [self showDetailImageWithImg:_IDCardImg imageRect:_imageRect];
        }else{
        NSLog(@"点击了身份证照片上传！");
        self.imageRect = [[button superview] convertRect:button.frame toView:self.view];
        [self showImageOptionWithImageIndex:1336];
        }
    }
    if (button.tag == 1337) {
        if ([[_dict objectForKey:@"2"] isEqualToString:@"NO"]) {
            [self showDetailImageWithImg:_bussinessImg imageRect:_imageRect];
        }else{
        NSLog(@"点击了营业执照照片！");
        [self showImageOptionWithImageIndex:1337];
        }
    }
    if (button.tag == 1338) {
        if ([[_dict objectForKey:@"3"] isEqualToString:@"NO"]) {
            [self showDetailImageWithImg:_taxImg imageRect:_imageRect];
        }else{
        NSLog(@"点击了税务登记证照片！");
        [self showImageOptionWithImageIndex:1338];
        }
    }
}

#pragma mark - 图片上传
-(void)showImageOptionWithImageIndex:(int)index
{
    UIActionSheet *sheet = nil;
    sheet = [[UIActionSheet alloc] initWithTitle:@""
                                        delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"相册上传",@"拍照上传",nil];
    sheet.tag = index;
    [sheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.popViewController dismissPopoverAnimated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.popViewController dismissPopoverAnimated:NO];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.view.tag = actionSheet.tag;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        self.popViewController = popover;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.popViewController presentPopoverFromRect:CGRectMake(250, 250, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
        }
        else
        {
            [self.popViewController presentPopoverFromRect:CGRectMake(250, 250, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.popViewController dismissPopoverAnimated:NO];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    switch (picker.view.tag) {
        case 1336:
            [self uploadImageWithImage:editImage WithTag:1];
            _IDCardImg = editImage;
            break;
        case 1337:
            [self uploadImageWithImage:editImage WithTag:2];
            _bussinessImg = editImage;
            break;
        case 1338:
            [self uploadImageWithImage:editImage WithTag:3];
            _taxImg = editImage;
            break;

        default:
            break;
    }
    NSLog(@"%@",editImage);
}

-(void)uploadImageWithImage:(UIImage *)image WithTag:(int)tag
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在上传...";
    [NetworkInterface uploadRegisterImageWithImage:image finished:^(BOOL success, NSData *response) {
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
                    if (tag == 1) {
                        _imageStr1 = [object objectForKey:@"result"];
                      [self updateBtnBGWithBtn:_IdCardNumImageBtn WithImage:image];
                    }
                    if (tag == 2) {
                        _imageStr2 = [object objectForKey:@"result"];
                        [self updateBtnBGWithBtn:_businesslicenseImageBtn WithImage:image];
                    }
                    if (tag == 3) {
                        _imageStr3 = [object objectForKey:@"result"];
                        [self updateBtnBGWithBtn:_taxregisterImageBtn WithImage:image];
                    }
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

-(void)updateBtnBGWithBtn:(UIButton *)button WithImage:(UIImage *)image
{
    _imageStatus = [self stringWithBtnTag:button.tag];
    [_dict setObject:@"NO" forKey:_imageStatus];
    [button setBackgroundColor:[UIColor clearColor]];
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
    
}

- (NSString *)stringWithBtnTag:(int)buttonTag
{
    NSString *imageStatus = @"";
    switch (buttonTag) {
        case 1336:
            imageStatus = @"1";
            break;
        case 1337:
            imageStatus = @"2";
            break;
        case 1338:
            imageStatus = @"3";
            break;
        default:
            break;
    }
    return imageStatus;
}


#pragma mark - 验证码验证点击
-(void)makeSureClicked
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
        _authCodeField.rightViewMode = UITextFieldViewModeAlways;
        _authCodeField.rightView = rightBigV;
        _isChecked = NO;
        return;
    }
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    _authCodeField.rightViewMode = UITextFieldViewModeAlways;
    [rightBigV addSubview:rightV];
    _authCodeField.rightView = rightBigV;
    _isChecked = YES;
}

#pragma mark - 验证码倒计时
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
                _getAuthCodeBtn.userInteractionEnabled = YES;
                _getAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                [_getAuthCodeBtn setBackgroundColor:kMainColor];
                [_getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getAuthCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _getAuthCodeBtn.userInteractionEnabled = NO;
                _getAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_getAuthCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_getAuthCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [_getAuthCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_getAuthCodeBtn setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 选择城市控件
//选择城市
- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 830.f;
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    if (_isChange) {
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_cityId] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:_cityId] inComponent:1 animated:NO];
    }else{
        
    }
    
    [self.view addSubview:_pickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
        
    }
    else {
        
        _locationField.text =[[_cityArray objectAtIndex:row] objectForKey:@"name"];
        _selectedCityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:row] objectForKey:@"id"]];
    }
}

- (void)pickerScrollIn {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH - 40;
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT - 40;
    }
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height - 260, wide, 44);
        _pickerView.frame = CGRectMake(0, height - 216, wide, 216);
    }];
}

- (void)pickerScrollOut {
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH - 40;
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT - 40;
        
    }
    
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height, wide, 44);
        _pickerView.frame = CGRectMake(0, height, wide, 216);
    }];
}

- (void)modifyLocation:(id)sender {
    [self pickerScrollOut];
    
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    self.selectedCityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[self.cityArray objectAtIndex:index] objectForKey:@"name"];
    _locationField.text = cityName;
    
}

#pragma mark - Request

-(void)registeApply
{
    if (_agentTypeField.text || [_agentTypeField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择代理商类型";
        return;
    }
    if (!_companyNameField.text || [_companyNameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写公司名称";
        return;
    }
    if (!_companyBusinesslicenseField.text || [_companyBusinesslicenseField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写公司营业执照登记号";
        return;
    }
    if (!_companyTaxField.text || [_companyTaxField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写公司税务登记账号";
        return;
    }
    if (!_principalNameField.text || [_principalNameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人姓名";
        return;
    }
    if (!_principalCardField.text || [_principalCardField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写负责人身份证号";
        return;
    }
    if (!_principalPhoneOrEmailField.text || [_principalPhoneOrEmailField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机号";
        return;
    }
    if ([RegularFormat isMobileNumber:_principalPhoneOrEmailField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的手机号";
        return;
    }
    if (!_authCodeField.text || [_authCodeField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if ([RegularFormat isCorrectEmail:_authCodeField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮箱号";
        return;
    }
    if (!_locationField.text || [_locationField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }if (!_particularLocationField.text || [_particularLocationField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写详细地址";
        return;
    }
    if (!_imageStr1 || !_imageStr2 || !_imageStr3) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请完善图片信息";
        return;
    }
    if (!_loginIDField.text || [_loginIDField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写登录";
        return;
    }
    if (!_loginPasswordField.text || [_loginPasswordField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写密码";
        return;
    }
    if (!_makeSurePasswordField.text || ![_makeSurePasswordField.text isEqualToString:_loginPasswordField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"两次输入的密码不一致";
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    [NetworkInterface registerWithUsername:_loginIDField.text password:_loginPasswordField.text isAlreadyEncrypt:NO agentType:_agentType companyName:_companyNameField.text licenseID:_companyBusinesslicenseField.text taxID:_companyTaxField.text legalPersonName:_principalNameField.text legalPersonID:_principalCardField.text mobileNumber:_principalPhoneOrEmailField.text email:_authCodeField.text cityID:_cityId detailAddress:nil cardImagePath:_imageStr1 licenseImagePath:_imageStr2 taxImagePath:_imageStr3 finished:^(BOOL success, NSData *response) {
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
                    PhoneSuccessViewController *phoneVC = [[PhoneSuccessViewController alloc]init];
                    phoneVC.phoneNum = _principalPhoneOrEmailField.text;
                    [self.navigationController pushViewController:phoneVC animated:YES];
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

-(void)authApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendValidateWithMobileNumber:_principalPhoneOrEmailField.text finished:^(BOOL success, NSData *response) {
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
                    [self resetStatus];
                    _authCode = [object objectForKey:@"result"];
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

//分润开关
-(void)switchAction:(UISwitch *)sender
{
    
}


@end
