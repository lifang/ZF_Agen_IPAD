//
//  StockManagerController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StockManagerController.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "StockManagerCell.h"
#import "StockManagerDetailController.h"

@interface StockManagerController ()<StockCellDelegate,UITextFieldDelegate>
//数据
@property (nonatomic, strong) NSMutableArray *dataItem;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIImageView *changeNameView;

@property(nonatomic,strong)UITextField *shopNameField;

@property(nonatomic,strong)StockListModel *stockModel;

@end

@implementation StockManagerController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏文字
    self.title = @"库存管理";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _dataItem = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editStockName:)
                                                 name:EditStockGoodNameNotification
                                               object:nil];
    [self initAndLayoutUI];
    [self setupHeaderView];
    [self firstLoadData];
}

//顶部工具栏View
-(void)setupHeaderView
{
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    if (iOS7) {
        _headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 50);
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
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 140, 0, 120, 25);
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
    fifth.frame = CGRectMake(CGRectGetMaxX(fourth.frame) + 60, 0, 90, 25);
    [bottomView addSubview:fifth];
    
    bottomView.frame = CGRectMake(0, 26, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 26, SCREEN_HEIGHT, 24);
    }
    [_headerView addSubview:bottomView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initAndLayoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}


#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataItem.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stockIdentifier = @"stockIdentifier";
    StockManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:stockIdentifier];
    if (cell == nil) {
        cell = [[StockManagerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:stockIdentifier];
    }
    cell.delegate = self;
    StockListModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StockManagerDetailController *stockDetatilVC = [[StockManagerDetailController alloc]init];
    stockDetatilVC.hidesBottomBarWhenPushed = YES;
    StockListModel *model = [_dataItem objectAtIndex:indexPath.row];
    stockDetatilVC.stockModel = model;
    [self.navigationController pushViewController:stockDetatilVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return hStockCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

//顶部栏
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

#pragma mark - StockCell Delegate
-(void)stockCellRenameForGood:(StockListModel *)model
{
    NSLog(@"点击了按钮");
    [self initChangeShopNameViewWithStockModel:model];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - NSNotification

- (void)editStockName:(NSNotification *)notification {
    [self firstLoadData];
}

#pragma mark - Request

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getStockListWithAgentID:delegate.agentID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    [self parseStockListWithDictionary:object];
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

#pragma mark - Data

- (void)parseStockListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id stockObject = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([stockObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [stockObject count]; i++) {
            id stockDict = [stockObject objectAtIndex:i];
            if ([stockDict isKindOfClass:[NSDictionary class]]) {
                StockListModel *model = [[StockListModel alloc] initWithParseDictionary:stockDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
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
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if (delegate.userType == UserEmployee || (delegate.userType == UserAgent && delegate.isFirstLevelAgent)) {
        [self updateGoodName];
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有权限";
    }
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
