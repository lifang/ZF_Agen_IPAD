//
//  AfterSellController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AfterSellController.h"
#import "SwitchView.h"
#import "AfterSellCell.h"
#import "NetworkInterface.h"
#import "CSModel.h"
#import "ChooseStatusCell.h"
#import "AfterSellDetailController.h"
#import "CancelDetailController.h"
#import "UpdateDetailController.h"

#define searchTag 5678

@interface AfterSellController ()<SwitchViewClicked,UITextFieldDelegate,AfterSellClickedDelegate>

@property(nonatomic,strong)SwitchView *switchView;

@property(nonatomic,strong)UITextField *chooseStatusField;

@property(nonatomic,strong)UITextField *searchField;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,assign)AfterSellType afterType;

@property(nonatomic,assign)CSType csType;

@property(nonatomic,assign)CSStatus currentStatus;

@property(nonatomic,strong)NSMutableArray *dataItem;

@property(nonatomic,strong)CSModel *selectedModel;

@property(nonatomic,strong)UITableView *statusTableView;

@property(nonatomic,strong)NSArray *statusArray;

@property(nonatomic,strong)NSString *keywordStr;

@property(nonatomic,strong)UIImageView *logistView;
@property(nonatomic,strong)UITextField *logistNameField;
@property(nonatomic,strong)UITextField *loginstNumField;
@end

@implementation AfterSellController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UITableView *)statusTableView
{
    if (!_statusTableView) {
        _statusTableView = [[UITableView alloc]init];
        _statusTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _statusTableView.tag = searchTag;
        _statusTableView.delegate = self;
        _statusTableView.dataSource = self;
    }
    return _statusTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self setupSwitchView];
    [self initAndLayoutUI];
    [self SwitchViewClickedAtIndex:1];
    _dataItem = [[NSMutableArray alloc]init];
    _statusArray = [[NSArray alloc]init];
    self.currentStatus = CSStatusAll;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCSList:)
                                                 name:RefreshCSListNotification
                                               object:nil];
    [self firstLoadData];
}

-(void)setNavBar
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"售后记录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initRefreshViewWithOffset:170.f];
}

-(void)initAndLayoutUI
{
    UILabel *chooseStatus = [[UILabel alloc]init];
    chooseStatus.translatesAutoresizingMaskIntoConstraints = NO;
    chooseStatus.text = @"选择状态";
    chooseStatus.font = [UIFont systemFontOfSize:22];
    chooseStatus.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chooseStatus];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:chooseStatus
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:chooseStatus
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:chooseStatus
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:chooseStatus
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    _chooseStatusField = [[UITextField alloc]init];
    _chooseStatusField.translatesAutoresizingMaskIntoConstraints = NO;
    _chooseStatusField.userInteractionEnabled = NO;
    _chooseStatusField.textColor = kColor(119, 120, 120, 1.0);
    _chooseStatusField.text = @"全部";
    _chooseStatusField.font = [UIFont systemFontOfSize:20];
    _chooseStatusField.delegate = self;
    _chooseStatusField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _chooseStatusField.leftView = placeholderV;
    CALayer *readBtnLayer = [_chooseStatusField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_chooseStatusField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:chooseStatus
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:260.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    UIButton *statusChoose = [[UIButton alloc]init];
    statusChoose.translatesAutoresizingMaskIntoConstraints = NO;
    [statusChoose addTarget:self action:@selector(statusChooseClicked) forControlEvents:UIControlEventTouchUpInside];
    [statusChoose setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [self.view addSubview:statusChoose];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusChoose
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusChoose
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:chooseStatus
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:210.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusChoose
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusChoose
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    _searchField = [[UITextField alloc]init];
    _searchField.translatesAutoresizingMaskIntoConstraints = NO;
    _searchField.userInteractionEnabled = YES;
    _searchField.textColor = kColor(119, 120, 120, 1.0);
    _searchField.font = [UIFont systemFontOfSize:20];
    _searchField.delegate = self;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _searchField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_searchField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_searchField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:260.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_searchField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    UIButton *searchChoose = [[UIButton alloc]init];
    searchChoose.translatesAutoresizingMaskIntoConstraints = NO;
    [searchChoose addTarget:self action:@selector(searchChooseClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchChoose setBackgroundImage:[UIImage imageNamed:@"arrow_search"] forState:UIControlStateNormal];
    [self.view addSubview:searchChoose];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchChoose
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchChoose
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:- 60.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchChoose
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:60.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchChoose
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];

    


}

-(void)setupHeaderViewWithArray:(NSArray *)arr
{
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 30);
    if (iOS7) {
        _headerView.frame = CGRectMake(0, 0, kScreenHeight, 30);
    }
    _headerView.backgroundColor = kColor(228, 228, 228, 1.0);
    
    UIFont *mainFont = [UIFont systemFontOfSize:14];
    UILabel *first = [[UILabel alloc]init];
    first.textAlignment = NSTextAlignmentCenter;
    first.font = mainFont;
    first.text = [arr objectAtIndex:0];
    first.frame = CGRectMake(100, 4, 120, 25);
    [_headerView addSubview:first];
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = [arr objectAtIndex:1];
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 130, 4, 120, 25);
    [_headerView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = [arr objectAtIndex:2];
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 50, 4, 90, 25);
    [_headerView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = [arr objectAtIndex:3];
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 80, 4, 90, 25);
    [_headerView addSubview:fourth];

}

-(void)setupSwitchView
{
    NSArray *nameArr = [NSArray arrayWithObjects:@"售后单",@"注销",@"更新资料",nil];
    SwitchView *swithView = [[SwitchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) With:nameArr];
    if (iOS7) {
        swithView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 80);
    }
    self.switchView = swithView;
    _switchView.SwitchViewClickedDelegate = self;
    [self.view addSubview:_switchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)SwitchViewClickedAtIndex:(int)Index
{
    if (Index == 1) {
        NSLog(@"点击了售后单");
        _chooseStatusField.text = @"全部";
        _keywordStr = nil;
        _searchField.text = nil;
        [_searchField resignFirstResponder];
        _currentStatus = CSStatusAll;
        self.afterType = AfterSellTypeSell;
        self.csType = CSTypeAfterSale;
        NSArray *arr = [NSArray arrayWithObjects:@"售后编号",@"终端号",@"申请日期",@"售后状态", nil];
        [self setupHeaderViewWithArray:arr];
        [self firstLoadData];
        [self.tableView reloadData];
    }
    if (Index == 2) {
        NSLog(@"点击了注销");
        _chooseStatusField.text = @"全部";
        _keywordStr = nil;
        _searchField.text = nil;
        [_searchField resignFirstResponder];
        _currentStatus = CSStatusAll;
        self.afterType = AfterSellTypeCancel;
        self.csType = CSTypeCancel;
        NSArray *arr1 = [NSArray arrayWithObjects:@"注销编号",@"终端号",@"申请日期",@"注销状态", nil];
        [self setupHeaderViewWithArray:arr1];
        [self firstLoadData];
        [self.tableView reloadData];
    }
    if (Index == 3) {
        NSLog(@"点击了更新资料");
        _chooseStatusField.text = @"全部";
        _keywordStr = nil;
        _searchField.text = nil;
        [_searchField resignFirstResponder];
        _currentStatus = CSStatusAll;
        self.afterType = AfterSellTypeUpdate;
        self.csType = CSTypeUpdate;
        NSArray *arr2 = [NSArray arrayWithObjects:@"更新资料编号",@"终端号",@"申请日期",@"更新状态", nil];
        [self setupHeaderViewWithArray:arr2];
        [self firstLoadData];
        [self.tableView reloadData];
    }
}

-(void)initStatusTableView
{
    [self.view addSubview:self.statusTableView];
    
}

//选择状态
-(void)statusChooseClicked
{
    [self initStatusTableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_statusTableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_chooseStatusField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_statusTableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:180.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_statusTableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:260.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_statusTableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200.f]];

}

//终端号搜索
-(void)searchChooseClicked
{
    if (_searchField.text && [_searchField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请输入终端号!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    _keywordStr = _searchField.text;
    [self firstLoadData];
}

#pragma mark - AfterCellDelegate
//取消申请
-(void)cancelClickedWithCSModel:(CSModel *)model
{
    _selectedModel = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消申请？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
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
    [self submitLogistData];
}

-(void)leftClicked
{
    [_logistView removeFromSuperview];
}
//提交物流信息
-(void)submitLogisticsClickedWithCSModel:(CSModel *)model
{
    _selectedModel = model;
    [self initLogisticsViewWithCSModel:model];
}
//重新提交注销
-(void)submitCancelClickedWithCSModel:(CSModel *)model
{
    _selectedModel = model;
    [self submitCanncelApply];
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self cancelApply];
    }
}

-(void)CsCurrentStatusWithString:(NSString *)str
{
    _currentStatus = CSStatusAll;
    if ([str isEqualToString:@"全部"]) {
        _currentStatus = CSStatusAll;
    }
    if ([str isEqualToString:@"待处理"]) {
        _currentStatus = CSStatusFirst;
    }
    if ([str isEqualToString:@"处理中"]) {
        _currentStatus = CSStatusSecond;
    }
    if ([str isEqualToString:@"处理完成"]) {
        if (_afterType == AfterSellTypeSell) {
            _currentStatus = CSStatusThird;
        }else{
            _currentStatus =CSStatusForth;
        }
    }
    if ([str isEqualToString:@"已取消"]) {
        if (_afterType == AfterSellTypeSell) {
           _currentStatus = CSStatusForth;
        }else{
           _currentStatus = CSStatusFifth;
        }
    }
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == searchTag) {
        return 5;
    }else{
        return _dataItem.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == searchTag) {
        NSArray *arr = [NSArray arrayWithObjects:@"全部",@"待处理",@"处理中",@"处理完成",@"已取消", nil];
        _statusArray = arr;
        ChooseStatusCell *cell = [ChooseStatusCell cellWithTableView:tableView];
        cell.statusLabel.text = [_statusArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        CSModel *model = [_dataItem objectAtIndex:indexPath.row];
        AfterSellCell *cell = [AfterSellCell cellWithTableView:tableView WithAfterSellType:_afterType WithCsModel:model];
        cell.csModel = model;
        cell.delegate = self;
        [cell setContentWithData:model WithAfterType:_afterType];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == searchTag) {
        [_searchField resignFirstResponder];
        _keywordStr = nil;
        _searchField.text = nil;
        _chooseStatusField.text = [_statusArray objectAtIndex:indexPath.row];
        [self CsCurrentStatusWithString:[_statusArray objectAtIndex:indexPath.row]];
        [_statusTableView removeFromSuperview];
        [self firstLoadData];
    }else{
        
        if (_afterType == AfterSellTypeSell) {
            CSModel *model = [_dataItem objectAtIndex:indexPath.row];
            AfterSellDetailController *afterVC = [[AfterSellDetailController alloc]init];
            afterVC.hidesBottomBarWhenPushed = YES;
            afterVC.csID = model.csID;
            if (model.status == 1) {
                afterVC.operationBtnType = OperationBtnCancel;
            }
            if (model.status == 2) {
                afterVC.operationBtnType = OperationBtnSubmitLogist;
            }
            afterVC.csType = CSTypeAfterSale;
            [self.navigationController pushViewController:afterVC animated:YES];
        }
        if (_afterType == AfterSellTypeCancel) {
            CSModel *model = [_dataItem objectAtIndex:indexPath.row];
            CancelDetailController *cancelVC = [[CancelDetailController alloc]init];
            cancelVC.hidesBottomBarWhenPushed = YES;
            cancelVC.csID = model.csID;
            if (model.status == 1) {
                cancelVC.operationBtnType = OperationBtnCancel;
            }
            if (model.status == 5) {
                cancelVC.operationBtnType = OperationBtnSubmitCancel;
            }
            cancelVC.csType = CSTypeCancel;
            [self.navigationController pushViewController:cancelVC animated:YES];
        }
        if (_afterType == AfterSellTypeUpdate) {
            CSModel *model = [_dataItem objectAtIndex:indexPath.row];
            UpdateDetailController *updateVC = [[UpdateDetailController alloc]init];
            updateVC.hidesBottomBarWhenPushed = YES;
            updateVC.csID = model.csID;
            NSLog(@"~~~~%d",model.status);
            if (model.status == 1) {
                updateVC.operationBtnType = OperationBtnCancel;
            }
            updateVC.csType = CSTypeUpdate;
            [self.navigationController pushViewController:updateVC animated:YES];
        }
  
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == searchTag) {
        return KChooseStatusHeight;
    }else{
        return 80.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

//顶部栏
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == searchTag) {
        return nil;
    }else{
        return _headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == searchTag) {
        return 0;
    }else{
        return 30.f;
    }
}
#pragma mark - NSNotification

- (void)refreshCSList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - Request

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    if (_keywordStr) {
        
    }else{
        _keywordStr = nil;
    }
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getCSListWithAgentID:delegate.agentUserID token:delegate.token csType:_csType keyword:_keywordStr status:_currentStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_dataItem removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseCSListDataWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}
//提交物流信息
-(void)submitLogistData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self .view bringSubviewToFront:hud];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitLogistWithAgentID:delegate.agentID csID:_selectedModel.csID logistName:_logistNameField.text logistNum:_loginstNumField.text finished:^(BOOL success, NSData *response) {
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
    NSLog(@"!!!!!!%@",_selectedModel.csID);
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csCancelApplyWithToken:delegate.token csType:_csType csID:_selectedModel.csID finished:^(BOOL success, NSData *response) {
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
    [NetworkInterface csRepeatAppleyWithToken:delegate.token csID:_selectedModel.csID finished:^(BOOL success, NSData *response) {
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

- (void)parseCSListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id csList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([csList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [csList count]; i++) {
            id csDict = [csList objectAtIndex:i];
            if ([csDict isKindOfClass:[NSDictionary class]]) {
                CSModel *model = [[CSModel alloc] initWithParseDictionary:csDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 上下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
