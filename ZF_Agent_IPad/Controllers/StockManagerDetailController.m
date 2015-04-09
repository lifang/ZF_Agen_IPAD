//
//  StockManagerDetailController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StockManagerDetailController.h"
#import "StockManagerCell.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface StockManagerDetailController ()<UISearchBarDelegate,StockCellDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) NSString *searchAgentName; //搜索的代理商名

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIImageView *changeNameView;

@property(nonatomic,strong)UITextField *shopNameField;

@property(nonatomic,strong)UIView *middleView;

@property(nonatomic,strong)UIButton *searchBtn;
@end

@implementation StockManagerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存详情";
    _dataItem = [[NSMutableArray alloc]init];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initAndLayoutUI
{
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self setMiddleView];
}
- (void)setHeaderAndFooterView {
    [self setupHeaderView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

//创建中间标题 View
-(void)setMiddleView
{
    _middleView = [[UIView alloc]init];
    _middleView.backgroundColor = kColor(229, 228, 228, 1.0);
    _middleView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    if (iOS7) {
        _middleView.frame = CGRectMake(0, 0, kScreenHeight, 60);
    }
    
    _searchBtn = [[UIButton alloc]init];
    [_searchBtn setBackgroundImage:kImageName(@"searchBT") forState:UIControlStateNormal];
    _searchBtn.frame = CGRectMake(50, 18, 25, 25);
    [_middleView addSubview:_searchBtn];
    
    UILabel *downAgentLabel = [[UILabel alloc]init];
    downAgentLabel.text = @"下级代理商";
    [self setLabel:downAgentLabel WithX:CGRectGetMaxX(_searchBtn.frame) + 10];
    
    UILabel *totalCountLabel = [[UILabel alloc]init];
    totalCountLabel.text = @"配货总量";
    [self setLabel:totalCountLabel WithX:CGRectGetMaxX(downAgentLabel.frame) + 70];
    
    UILabel *openCountLabel = [[UILabel alloc]init];
    openCountLabel.text = @"已开通量";
    [self setLabel:openCountLabel WithX:CGRectGetMaxX(totalCountLabel.frame) + 50];
    
    UILabel *allocationLabel = [[UILabel alloc]init];
    allocationLabel.text = @"上次配货日期";
    [self setLabel:allocationLabel WithX:CGRectGetMaxX(openCountLabel.frame) + 50];
    
    UILabel *lastOpenLabel = [[UILabel alloc]init];
    lastOpenLabel.text = @"上次开通日期";
    [self setLabel:lastOpenLabel WithX:CGRectGetMaxX(allocationLabel.frame) + 50];
    
}

-(void)setLabel:(UILabel *)label WithX:(CGFloat)labelX
{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 120.f;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kColor(67, 67, 67, 1.0);
    label.font = [UIFont systemFontOfSize:16];
    label.frame = CGRectMake(labelX, 18, labelWidth, labelHeight);
    [_middleView addSubview:label];
}

//顶部工具栏View
-(void)setupHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50);
    }
    UIView *bottomView = [[UIView alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:14];
    
    UILabel *first = [[UILabel alloc]init];
    first.font = mainFont;
    first.text = @"商品";
    first.frame = CGRectMake(165, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"历史进货数量";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 150, 0, 120, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"已开通数量";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 20, 0, 90, 25);
    [bottomView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"代理商库存";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 40, 0, 90, 25);
    [bottomView addSubview:fourth];
    
    UILabel *fifth = [[UILabel alloc]init];
    fifth.font = mainFont;
    fifth.text = @"总库存";
    fifth.frame = CGRectMake(CGRectGetMaxX(fourth.frame) + 50, 0, 90, 25);
    [bottomView addSubview:fifth];
    
    bottomView.frame = CGRectMake(0, 26, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 26, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.headerView = headerView;
    self.tableView.tableHeaderView = _headerView;
}

#pragma mark - UITabelView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StockManagerCell *cell = [[StockManagerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"stockDetailCell"];
        cell.delegate = self;
        [cell setContentWithData:_stockModel];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cweq"];
        cell.textLabel.text = @"dassadasdasdasd";
        return cell;
    }
}

//下方View
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _middleView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return hStockCellHeight;
    }else{
        return 100.f;
    }
}

#pragma mark - 修改商户名的代理方法
-(void)stockCellRenameForGood:(StockListModel *)model
{
    [self initChangeShopNameViewWithStockModel:model];
}

#pragma mark - 商品更名
-(void)initChangeShopNameViewWithStockModel:(StockListModel *)model
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
    _changeNameView = [[UIImageView alloc]init];
    
    _changeNameView.frame = CGRectMake(0, 0, width, height);
    
    [self.view.window addSubview:_changeNameView];
    _changeNameView.image=[UIImage imageNamed:@"backimage"];
    _changeNameView.userInteractionEnabled=YES;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 300)];
    whiteView.center = CGPointMake(width / 2, height / 2 - 40);
    whiteView.backgroundColor = [UIColor whiteColor];
    [_changeNameView addSubview:whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [whiteView addSubview:leftXBtn];
    
    UILabel *FindPOSLable = [[UILabel alloc]init];
    FindPOSLable.text = @"商品更名";
    FindPOSLable.textColor = kColor(38, 38, 38, 1.0);
    FindPOSLable.font = [UIFont boldSystemFontOfSize:22];
    FindPOSLable.frame = CGRectMake(170, 10, 200, 40);
    [whiteView addSubview:FindPOSLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(FindPOSLable.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UILabel *POSLable = [[UILabel alloc]init];
    POSLable.text = @"商品名称";
    POSLable.textColor = kColor(56, 56, 56, 1.0);
    POSLable.font = [UIFont systemFontOfSize:20];
    POSLable.frame = CGRectMake(40, CGRectGetMaxY(line.frame) + 50, 120, 30);
    [whiteView addSubview:POSLable];
    
    _shopNameField = [[UITextField alloc]init];
    _shopNameField.textColor = kColor(105, 105, 105, 1.0);
    _shopNameField.borderStyle = UITextBorderStyleLine;
    _shopNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_shopNameField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _shopNameField.delegate = self;
    _shopNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _shopNameField.leftView = leftV;
    CALayer *readBtnLayer = [_shopNameField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    _shopNameField.frame = CGRectMake(CGRectGetMaxX(POSLable.frame) - 30, POSLable.frame.origin.y - 5, 240, 40);
    [whiteView addSubview:_shopNameField];
    
    UIButton *makeSureBtn = [[UIButton alloc]init];
    [makeSureBtn addTarget:self action:@selector(changeMakeSureClicked) forControlEvents:UIControlEventTouchUpInside];
    self.stockModel = model;
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setBackgroundColor:kMainColor];
    makeSureBtn.frame = CGRectMake(_shopNameField.frame.origin.x + 30, CGRectGetMaxY(_shopNameField.frame) + 60, 140, 40);
    [whiteView addSubview:makeSureBtn];
}

-(void)leftClicked
{
    [_changeNameView removeFromSuperview];
}
#pragma mark - 修改商户名字点击事件
-(void)changeMakeSureClicked
{
    if (!_shopNameField.text || [_shopNameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"商品名不能为空";
        return;
    }
    [_shopNameField becomeFirstResponder];
    [_shopNameField resignFirstResponder];
    [self updateGoodName];
}

#pragma mark - 修改商户名字 Request
- (void)updateGoodName {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface renameStockGoodWithAgentID:delegate.agentID token:delegate.token goodID:_stockModel.stockGoodID goodName:_shopNameField.text finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"修改成功";
                    _stockModel.stockTitle = _shopNameField.text;
                    [_changeNameView removeFromSuperview];
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:EditStockGoodNameNotification object:nil];
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
