//
//  StaffManagerDetailController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffManagerDetailController.h"
#import "StaffButton.h"

@interface StaffManagerDetailController ()<UITextFieldDelegate,StaffBtnClickedDelegate>

@property(nonatomic,strong)UITextField *loginIDField;

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UITextField *makeSureField;

@property(nonatomic,strong)UIButton *bottomBtn;

/** 状态选中Btn */
@property(nonatomic,strong)StaffButton *firstBtn;
@property(nonatomic,strong)StaffButton *secondBtn;
@property(nonatomic,strong)StaffButton *thirdBtn;
@property(nonatomic,strong)StaffButton *fourthBtn;
@property(nonatomic,strong)StaffButton *fifthBtn;
@property(nonatomic,strong)StaffButton *sixBtn;
@property(nonatomic,strong)StaffButton *seventhBtn;
@property(nonatomic,strong)StaffButton *eighthBtn;

@property(nonatomic,assign)BOOL isSelected;

@end

@implementation StaffManagerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavBar
{
    //设置导航栏文字
    self.title = @"员工创建";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

-(void)initAndLayoutUI
{
    CGFloat topSpaceBig = 20.f;
    CGFloat topSpaceLittle = 10.f;
    
    UILabel *loginIDLabel = [[UILabel alloc]init];
    loginIDLabel.text = @"登录ID";
    [self setLabel:loginIDLabel WithTopSapce:topSpaceBig * 4 WithTopView:self.view WithLabelTag:1];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓名";
    [self setLabel:nameLabel WithTopSapce:topSpaceBig WithTopView:loginIDLabel WithLabelTag:0];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"登录密码";
    [self setLabel:passwordLabel WithTopSapce:topSpaceBig WithTopView:nameLabel WithLabelTag:0];
    
    UILabel *makeSureLabel = [[UILabel alloc]init];
    makeSureLabel.text = @"确认密码";
    [self setLabel:makeSureLabel WithTopSapce:topSpaceBig WithTopView:passwordLabel WithLabelTag:0];
    
    _loginIDField = [[UITextField alloc]init];
    [self setTextField:_loginIDField WithTopSapce:topSpaceBig * 4 WithTopView:self.view WithfieldTag:1];
    
    _nameField = [[UITextField alloc]init];
    [self setTextField:_nameField WithTopSapce:topSpaceBig WithTopView:_loginIDField WithfieldTag:0];
    
    _passwordField = [[UITextField alloc]init];
    [self setTextField:_passwordField WithTopSapce:topSpaceBig WithTopView:_nameField WithfieldTag:3];
    
    _makeSureField = [[UITextField alloc]init];
    [self setTextField:_makeSureField WithTopSapce:topSpaceBig WithTopView:_passwordField WithfieldTag:4];
    
    UILabel *chooseStaff = [[UILabel alloc]init];
    chooseStaff.text = @"选择员工权限:";
    chooseStaff.font = [UIFont systemFontOfSize:20];
    chooseStaff.backgroundColor = [UIColor clearColor];
    chooseStaff.frame = CGRectMake(CGRectGetMaxX(_loginIDField.frame) + 180, _loginIDField.frame.origin.y, 180, 30);
    [self.view addSubview:chooseStaff];
    
    UILabel *first = [[UILabel alloc]init];
    first.text = @"批购";
    [self setLabel:first WithTopSapce:topSpaceBig WithTopView:self.view WithLabelTag:4];
    
    UILabel *second = [[UILabel alloc]init];
    second.text = @"代购";
    [self setLabel:second WithTopSapce:topSpaceLittle WithTopView:first WithLabelTag:2];
    
    UILabel *third = [[UILabel alloc]init];
    third.text = @"终端管理/售后记录查看";
    [self setLabel:third WithTopSapce:topSpaceLittle WithTopView:second WithLabelTag:2];
    
    UILabel *fouth = [[UILabel alloc]init];
    fouth.text = @"交易分润查询";
    [self setLabel:fouth WithTopSapce:topSpaceLittle WithTopView:third WithLabelTag:2];
    
    UILabel *fifth = [[UILabel alloc]init];
    fifth.text = @"下级代理商管理";
    [self setLabel:fifth WithTopSapce:topSpaceLittle WithTopView:fouth WithLabelTag:2];
    
    UILabel *sixth = [[UILabel alloc]init];
    sixth.text = @"用户管理";
    [self setLabel:sixth WithTopSapce:topSpaceLittle WithTopView:fifth WithLabelTag:2];
    
    UILabel *seventh = [[UILabel alloc]init];
    seventh.text = @"员工账号管理";
    [self setLabel:seventh WithTopSapce:topSpaceLittle WithTopView:sixth WithLabelTag:2];
    
    UILabel *eighth = [[UILabel alloc]init];
    eighth.text = @"代理商资料/收货地址管理";
    [self setLabel:eighth WithTopSapce:topSpaceLittle WithTopView:seventh WithLabelTag:2];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(211, 211, 211, 1.0);
    line.frame = CGRectMake(30, CGRectGetMaxY(eighth.frame) + 50, kScreenWidth - 60, 0.7);
    if (iOS7) {
        line.frame = CGRectMake(30, CGRectGetMaxY(eighth.frame) + 50, kScreenHeight - 60, 0.7);
    }
    [self.view addSubview:line];
    
    _bottomBtn = [[UIButton alloc]init];
    [_bottomBtn addTarget:self action:@selector(bottomClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBtn setBackgroundColor:kMainColor];
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    _bottomBtn.frame = CGRectMake(CGRectGetMaxX(_loginIDField.frame) - 40, CGRectGetMaxY(line.frame) + 40, 260, 40);
    [self.view addSubview:_bottomBtn];
    
    //创建状态Btn
    _firstBtn = [[StaffButton alloc]init];
    [self setSelectedBtn:_firstBtn WithTopSpace:topSpaceLittle + 5 WithTopView:chooseStaff WithButtonTag:1];
    
}

-(void)setSelectedBtn:(StaffButton *)button WithTopSpace:(CGFloat)topSpace WithTopView:(UIView *)topButton WithButtonTag:(NSInteger)buttonTag
{
    CGFloat originX = CGRectGetMaxX(_loginIDField.frame) + 190.f;
    CGFloat buttonWidth = 25.f;
    CGFloat buttonHeight = 25.f;
    button.delegate = self;
    button.tag = 5000 + buttonTag;
    [button setImage:kImageName(@"noSelected") forState:UIControlStateNormal];
    button.frame = CGRectMake(originX, CGRectGetMaxY(topButton.frame) + topSpace, buttonWidth, buttonHeight);
    [self.view addSubview:button];
}

-(void)setLabel:(UILabel *)label WithTopSapce:(CGFloat)topSpace WithTopView:(UIView *)toplabel WithLabelTag:(NSInteger)labelTag
{
    CGFloat originX = 60.f;
    CGFloat labelWidth = 100.f;
    CGFloat labelHeight = 40.f;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:20];
    if (labelTag == 2) {
        originX = CGRectGetMaxX(_loginIDField.frame) + 230.f;
        labelWidth = 300.f;
        label.textAlignment = NSTextAlignmentLeft;
    }
    if (labelTag == 4) {
        originX = CGRectGetMaxX(_loginIDField.frame) + 230.f;
        labelWidth = 300.f;
        label.textAlignment = NSTextAlignmentLeft;
    }
    if (labelTag == 1) {
        label.frame = CGRectMake(originX,50 + topSpace, labelWidth, labelHeight);
    }else{
        if (labelTag == 4) {
            label.frame = CGRectMake(originX,150 + topSpace, labelWidth, labelHeight);
        }else{
            label.frame = CGRectMake(originX, CGRectGetMaxY(toplabel.frame) + topSpace, labelWidth, labelHeight);
        }
    }
    [self.view addSubview:label];
}

-(void)setTextField:(UITextField *)textfield WithTopSapce:(CGFloat)topSpace WithTopView:(UIView *)topField WithfieldTag:(NSInteger)fieldTag
{
    CGFloat textWidth = 240.f;
    CGFloat textHeight = 40.f;
    CGFloat originX = 170.f;
    if (fieldTag >= 3) {
        textfield.secureTextEntry = YES;
    }
    textfield.borderStyle = UITextBorderStyleLine;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textfield setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    textfield.delegate = self;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    textfield.leftView = placeholderV;
    CALayer *readBtnLayer = [textfield layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    if (fieldTag == 1) {
        textfield.frame = CGRectMake(originX,50 + topSpace, textWidth, textHeight);
    }else{
        textfield.frame = CGRectMake(originX, CGRectGetMaxY(topField.frame) + topSpace, textWidth, textHeight);
    }
    [self.view addSubview:textfield];

    
}

#pragma mark - Action
-(void)bottomClicked
{
    
}

#pragma mark - staffBtn Delegate
-(void)staffClickedWithButton:(UIButton *)button
{
    if (button.tag == 5001) {
        NSLog(@"点击了第一个空格 并且状态为%d",_firstBtn.isSelected);
    }
}
@end
