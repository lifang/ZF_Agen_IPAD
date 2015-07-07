//
//  ApplyViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/5/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ApplyViewController.h"
#import "CityHandle.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"
#import "ApplySuccessController.h"
#import "ProtocolController.h"

@interface ApplyViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPopoverControllerDelegate,UIPickerViewDelegate>


@property(nonatomic,strong)UIPopoverController *popViewController;

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

@property(nonatomic,strong)UITableView *agentTypeTableView;

//选择城市
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSString *cityId;

@property(nonatomic,assign)BOOL isChange;
@property(nonatomic,strong)NSString *selectedCityID;

@property(nonatomic,assign)AgentType agentType;

@property(nonatomic,strong)UILabel *makeSureWrongLabel;

@end

@implementation ApplyViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgreen = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.cityId = @"1";
    self.agentType = AgentTypeNone;
    [self setupNavBar];
    [self initAndLayoutUI];
}

-(void)setupNavBar
{
    self.title = @"申请成为合作伙伴";
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
    CGFloat mainMargin = 25.f;
    
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
                                                        constant:mainMargin ]];
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
                                                           constant:mainMargin ]];
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
    _makeSureBtn.hidden = YES;
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
    CGFloat fieldWidth = 260.f;
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
                                                               constant:leftSpace + 200.f]];
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
                                                               constant:leftSpace + 200.f]];
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
#pragma mark - 创建选择代理商
-(void)initAgentTableView
{
    [self.view addSubview:self.agentTypeTableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_agentTypeTableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_agentTypeField
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

#pragma mark - Action
-(void)commitClicked
{
    //提交按钮
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机号";
        return;
    }
    
    if (!_authCodeField.text || [_authCodeField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写验证码";
        return;
    }
    
    if (!_locationField.text || [_locationField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    
    if (_agentType == AgentTypeNone) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择代理商类型";
        return;
    }
    
    [self registerApply];
}



-(void)btnClicked
{
    if (_isSelected == NO) {
        self.isAgreen = NO;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        if (_phoneField.text.length > 0 && _nameField.text.length > 0 && _authCodeField.text.length > 0 && _agentTypeField.text.length > 0 && _locationField.text.length > 0 && _isChecked) {
            _commitBtn.userInteractionEnabled = NO;
            [_commitBtn setBackgroundColor:kColor(208, 227, 247, 1.0)];
        }
    }
    else{
        self.isAgreen = YES;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        if (_phoneField.text.length > 0 && _nameField.text.length > 0 && _authCodeField.text.length > 0 && _agentTypeField.text.length > 0 && _locationField.text.length > 0 && _isChecked) {
            _commitBtn.userInteractionEnabled = YES;
            [_commitBtn setBackgroundColor:kMainColor];
        }
    }
    _isSelected = !_isSelected;
}

//右方按钮事件
-(void)BlueBtnClicked:(UIButton *)button
{
    if (button.tag == 1334) {
        NSLog(@"点击了验证码！");
        [_phoneField resignFirstResponder];
        if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"手机号不能为空";
            return;
        }
        [self authApply];
    }
    if (button.tag == 1335) {
        NSLog(@"点击了检查！");
        [_authCodeField resignFirstResponder];
        [self makeSureClicked];
    }
}

-(void)agreenmentClicked
{
    NSLog(@"进入协议");
    ProtocolController *protocolVC = [[ProtocolController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

//textfield按钮事件
-(void)rightBtnClicked:(UIButton *)sender
{
    if (sender.tag == 1236) {
        //注册类型选择
        [_authCodeField resignFirstResponder];
        [self initAgentTableView];
    }else{
        //城市选择
        [self initPickerView:_locationField];
    }
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
            _authCodeField.rightViewMode = UITextFieldViewModeAlways;
            _authCodeField.rightView = rightBigV;
            _isChecked = YES;
            [_makeSureWrongLabel removeFromSuperview];
            if (_phoneField.text.length > 0 && _nameField.text.length > 0 && _authCodeField.text.length > 0 && _agentTypeField.text.length > 0 && _locationField.text.length > 0 && _isChecked) {
                _commitBtn.userInteractionEnabled = YES;
                [_commitBtn setBackgroundColor:kMainColor];
            }
        }else
        {
            UIView *rightBigV = [[UIView alloc]init];
            rightBigV.frame = CGRectMake(0, 0, 60, 40);
            UIImageView *rightV = [[UIImageView alloc]init];
            rightV.frame = CGRectMake(20, 8, 23, 23);
            rightV.image = kImageName(@"check_wrong");
            [rightBigV addSubview:rightV];
            _authCodeField.rightViewMode = UITextFieldViewModeAlways;
            _authCodeField.rightView = rightBigV;
            _isChecked = NO;
            _commitBtn.userInteractionEnabled = NO;
            [_commitBtn setBackgroundColor:kColor(208, 227, 247, 1.0)];
            
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
                                                                   constant:- 130.f]];
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
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"验证码错误!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        
        UIView *rightBigV = [[UIView alloc]init];
        rightBigV.frame = CGRectMake(0, 0, 60, 40);
        UIImageView *rightV = [[UIImageView alloc]init];
        rightV.frame = CGRectMake(20, 8, 23, 23);
        rightV.image = kImageName(@"check_wrong");
        [rightBigV addSubview:rightV];
        _authCodeField.rightViewMode = UITextFieldViewModeAlways;
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
                                                               constant:- 130.f]];
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
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    _authCodeField.rightViewMode = UITextFieldViewModeAlways;
    [rightBigV addSubview:rightV];
    _authCodeField.rightView = rightBigV;
    [_makeSureWrongLabel removeFromSuperview];
    _isChecked = YES;
    
    if (_phoneField.text.length > 0 && _nameField.text.length > 0 && _authCodeField.text.length > 0 && _agentTypeField.text.length > 0 && _locationField.text.length > 0 && _isChecked) {
        _commitBtn.userInteractionEnabled = YES;
        [_commitBtn setBackgroundColor:kMainColor];
    }
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
        cell.textLabel.text = @"我是个人";
    }else{
        cell.textLabel.text = @"我是公司";
    }
    cell.backgroundColor = kColor(191, 191, 191, 1.0);
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_agentTypeField becomeFirstResponder];
    [_agentTypeField resignFirstResponder];
    if (indexPath.row == 0) {
        _agentTypeField.text = @"我是个人";
        _agentType = AgentTypePerson;
        [_agentTypeTableView removeFromSuperview];
    }else{
        _agentTypeField.text = @"我是公司";
        _agentType = AgentTypeCompany;
        [_agentTypeTableView removeFromSuperview];
    }
}

#pragma mark - 选择城市控件
//选择城市
- (void)pickerHide
{
    [_popViewController dismissPopoverAnimated:NO];
    
}
- (void)initPickerView:(id)sender {
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:_toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    if (_isChange) {
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_cityId] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:_cityId] inComponent:1 animated:NO];
    }else{
        
    }
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(120, 0, 0, 42) inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
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
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        _cityId = [NSString stringWithFormat:@"%@",[provinceDict objectForKey:@"id"]];
        NSLog(@"省得id为%@",_cityId);
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
    [_popViewController dismissPopoverAnimated:NO];
    [_locationField becomeFirstResponder];
    [_locationField resignFirstResponder];
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    self.selectedCityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[self.cityArray objectAtIndex:index] objectForKey:@"name"];
    _locationField.text = cityName;
}

#pragma mark - Request
//发送验证码请求
-(void)authApply
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface sendValidateWithMobileNumber:_phoneField.text finished:^(BOOL success, NSData *response) {
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
                    _makeSureBtn.userInteractionEnabled = YES;
                    [_makeSureBtn setBackgroundColor:kMainColor];
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

//注册请求
-(void)registerApply
{
    NSString *str = @"";
    if (_agentType == AgentTypeCompany) {
        str = @"公司";
    }
    if (_agentType == AgentTypePerson) {
        str = @"个人";
    }
    NSString *cityID = @"";
    cityID = [NSString stringWithFormat:@"%@_%@",_cityId,_selectedCityID];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface applyRegisterWithName:_nameField.text Phone:_phoneField.text AgentType:str Address:cityID finished:^(BOOL success, NSData *response) {
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
                    ApplySuccessController *applyVC = [[ApplySuccessController alloc]init];
                    [self.navigationController pushViewController:applyVC animated:YES];
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
@end
