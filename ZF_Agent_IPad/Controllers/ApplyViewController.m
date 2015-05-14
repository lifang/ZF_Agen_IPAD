//
//  ApplyViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/5/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ApplyViewController.h"

@interface ApplyViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *phoneField;

@property(nonatomic,strong)UITextField *authCodeField;

@property(nonatomic,strong)UITextField *agentTypeField;

@property(nonatomic,strong)UITextField *locationField;

@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,assign)BOOL isAgreen;

@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,strong)UIButton *getAuthCodeBtn;

@property(nonatomic,strong)UIButton *makeSureBtn;

@property(nonatomic,strong)UIButton *commitBtn;

@property(nonatomic,strong)UILabel *makeSureWrong;

@property(nonatomic,strong)UILabel *firstLabel;

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,strong)NSString *authCode;
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgreen = NO;
    [self setupNavBar];
    [self initAndLayoutUI];
}

-(void)setupNavBar
{
    self.title = @"申请成合作伙伴";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initAndLayoutUI
{
    CGFloat mainMargin = 15.f;
    
    _firstLabel = [[UILabel alloc]init];
    _firstLabel.text = @" 您 的 姓 名";
    [self setLabel:_firstLabel withTopView:self.view middleSpace:60.f labelTag:1];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @" 您的手机号";
    [self setLabel:phoneLabel withTopView:_firstLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *authLabel = [[UILabel alloc]init];
    authLabel.text = @" 输入验证码";
    [self setLabel:authLabel withTopView:phoneLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *agentTypeLabel = [[UILabel alloc]init];
    agentTypeLabel.text = @"合作伙伴类型";
    [self setLabel:agentTypeLabel withTopView:authLabel middleSpace:mainMargin labelTag:0];
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"所在城市";
    [self setLabel:locationLabel withTopView:agentTypeLabel middleSpace:mainMargin labelTag:0];
    
#pragma mark - 创建TextField
    _nameField = [[UITextField alloc]init];
    [self setField:_nameField withTopView:self.view middleSpace:60.f fieldTag:1];
    
    _phoneField = [[UITextField alloc]init];
    [self setField:_phoneField withTopView:_nameField middleSpace:mainMargin fieldTag:0];
    
    _authCodeField = [[UITextField alloc]init];
    [self setField:_authCodeField withTopView:_phoneField middleSpace:mainMargin fieldTag:0];
    
    _agentTypeField = [[UITextField alloc]init];
    [self setField:_agentTypeField withTopView:_authCodeField middleSpace:mainMargin fieldTag:2];
    
    _locationField = [[UITextField alloc]init];
    [self setField:_locationField withTopView:_agentTypeField middleSpace:mainMargin fieldTag:3];
    
    _selectedBtn = [[UIButton alloc]init];
    _isSelected = YES;
    [_selectedBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    _selectedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_selectedBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                          toItem:_locationField
                                                        attribute:NSLayoutAttributeBottom
                                                      multiplier:1.0
                                                        constant:mainMargin * 3]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_firstLabel
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1.0
                                                       constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:25.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:25.f]];

    [self.view addSubview:_selectedBtn];
    
    UIButton *agreementBtn = [[UIButton alloc]init];
    [agreementBtn setBackgroundColor:[UIColor clearColor]];
    [agreementBtn setTitle:@"同意《华尔街金融平台用户使用协议》" forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    agreementBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [agreementBtn addTarget:self action:@selector(agreenmentClicked) forControlEvents:UIControlEventTouchUpInside];
    [agreementBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.view addSubview:agreementBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreementBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_locationField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:mainMargin * 3]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreementBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreementBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:230.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreementBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:25.f]];

    
    UILabel *applyQuestionLabel = [[UILabel alloc]init];
    applyQuestionLabel.textAlignment = NSTextAlignmentCenter;
    CALayer *readLabelLayer = [applyQuestionLabel layer];
    [readLabelLayer setMasksToBounds:YES];
    [readLabelLayer setCornerRadius:2.0];
    [readLabelLayer setBorderWidth:1.0];
    [readLabelLayer setBorderColor:[kColor(249, 106, 104, 1.0) CGColor]];
    applyQuestionLabel.textColor = kColor(249, 106, 104, 1.0);
    applyQuestionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    applyQuestionLabel.backgroundColor = kColor(252, 226, 225, 1.0);
    applyQuestionLabel.font = [UIFont systemFontOfSize:16];
    applyQuestionLabel.text = @"若申请时遇到问题，请拨打电话400-009-0876";
    [self.view addSubview:applyQuestionLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyQuestionLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:agreementBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:mainMargin * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyQuestionLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:locationLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:80.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyQuestionLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:370.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyQuestionLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    UIView *line = [[UIView alloc]init];
    [self setLine:line withTopView:applyQuestionLabel middleSpace:40.f];
    
    _commitBtn = [[UIButton alloc]init];
    [_commitBtn setBackgroundColor:kColor(208, 227, 247, 1.0)];
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitClicked) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_commitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:line
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:mainMargin * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commitBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:- 10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:240.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    _getAuthCodeBtn = [[UIButton alloc]init];
    [_getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getAuthCodeBtn setBackgroundColor:kMainColor];
    [self setBtn:_getAuthCodeBtn withTopView:_nameField middleSpace:mainMargin buttonTag:1];
    
    _makeSureBtn = [[UIButton alloc]init];
    _makeSureBtn.userInteractionEnabled = NO;
    [_makeSureBtn setBackgroundColor:kColor(208, 227, 247, 1.0)];
    [_makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self setBtn:_makeSureBtn withTopView:_getAuthCodeBtn middleSpace:mainMargin buttonTag:2];
}

//创建各种Btn
//topView-上方控件
//space-距上方间距
-(void)setBtn:(UIButton *)button
  withTopView:(UIView *)topView
  middleSpace:(CGFloat)space
    buttonTag:(int)BtnTag{
    CGFloat btnWidth = 140.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 10.f;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 1333 + BtnTag;
    [button addTarget:self action:@selector(BlueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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


//创建左边Label
//topView-上方控件
//space-距上方间距
- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 40.f;
    CGFloat labelWidth = 140.f;
    CGFloat leftSpace = 260.f;
    label.textAlignment = NSTextAlignmentLeft;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
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
    [self.view addSubview:textField];
    if (FieldTag == 3) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
        textField.userInteractionEnabled = NO;
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.tag = 1234 + FieldTag;
        rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setBackgroundImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
        [self.view addSubview:rightBtn];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rightBtn
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
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
    }
    if (FieldTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
    }
    else{
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
        [self.view addSubview:rightBtn];
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

//创建分割线
- (void)setLine:(UIView *)line
    withTopView:(UIView *)topView
    middleSpace:(CGFloat)space{
    
    CGFloat lineWidth = kScreenWidth - 160.f;
    if (iOS7) {
        lineWidth = kScreenHeight - 160.f;
    }
    CGFloat lineHeight = 1.f;
    CGFloat leftSpace = 80.f;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = kColor(221, 220, 220, 1.0);
    [self.view addSubview:line];
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
-(void)btnClicked
{
    if (_isSelected == NO) {
        self.isAgreen = NO;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    else{
        self.isAgreen = YES;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    _isSelected = !_isSelected;
}

//右方按钮事件
-(void)BlueBtnClicked:(UIButton *)button
{
    if (button.tag == 1334) {
        NSLog(@"点击了验证码！");
        [self resetStatus];
    }
    if (button.tag == 1335) {
        NSLog(@"点击了检查！");
        [self makeSureClicked];
    }
    
}

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



@end
