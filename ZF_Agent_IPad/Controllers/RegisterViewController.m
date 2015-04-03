//
//  RegisterViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/3.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIScrollView *mainScrollView;

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

@property(nonatomic,strong)UIButton *IdCardNumImageBtn;
@property(nonatomic,strong)UIButton *businesslicenseImageBtn;
@property(nonatomic,strong)UIButton *taxregisterImageBtn;

@property(nonatomic,strong)UITextField *loginIDField;
@property(nonatomic,strong)UITextField *loginPasswordField;
@property(nonatomic,strong)UITextField *makeSurePasswordField;

@end

@implementation RegisterViewController

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
    [self setupNavBar];
    [self initAndLayoutUI];
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
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1270);
    if (iOS7) {
        _mainScrollView.contentSize = CGSizeMake(kScreenHeight, 1270);
    }
    [self.view addSubview:_mainScrollView];
    
    CGFloat mainBtnWidth = 100.f;
    CGFloat mainFieldWidth = 240.f;
    
    //创建左边Label
    UILabel *agentTypeLable = [[UILabel alloc]init];
    agentTypeLable.text = @"代理商类型";
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
    principalPhoneOrEmailLabel.text = @"手机/邮箱";
    [self setLabel:principalPhoneOrEmailLabel withTopView:principalIDLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *authCodeFieldLabel = [[UILabel alloc]init];
    authCodeFieldLabel.text = @"验证码";
    [self setLabel:authCodeFieldLabel withTopView:principalPhoneOrEmailLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *particularLocationLabel = [[UILabel alloc]init];
    particularLocationLabel.text = @"详细地址";
    [self setLabel:particularLocationLabel withTopView:authCodeFieldLabel middleSpace:mainMargin labelTag:0];
    
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

#pragma mark - Action
-(void)presentClick
{
    
}

@end
