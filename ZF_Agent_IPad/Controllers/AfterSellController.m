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

@interface AfterSellController ()<SwitchViewClicked,UITextFieldDelegate>

@property(nonatomic,strong)SwitchView *switchView;

@property(nonatomic,strong)UITextField *chooseStatusField;

@property(nonatomic,strong)UITextField *searchField;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,assign)AfterSellType afterType;

@property(nonatomic,assign)CSType csType;

@property(nonatomic,assign)CSStatus currentStatus;

@property(nonatomic,strong)NSMutableArray *dataItem;

@end

@implementation AfterSellController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self setupSwitchView];
    [self initAndLayoutUI];
    [self SwitchViewClickedAtIndex:1];
    _dataItem = [[NSMutableArray alloc]init];
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
    _searchField.userInteractionEnabled = NO;
    _searchField.textColor = kColor(119, 120, 120, 1.0);
    _searchField.text = @"请输入终端号";
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
        self.afterType = AfterSellTypeSell;
        self.csType = CSTypeAfterSale;
        NSArray *arr = [NSArray arrayWithObjects:@"售后单号",@"终端号",@"申请日期",@"售后状态", nil];
        [self setupHeaderViewWithArray:arr];
        [self.tableView reloadData];
    }
    if (Index == 2) {
        NSLog(@"点击了注销");
        self.afterType = AfterSellTypeCancel;
        self.csType = CSTypeCancel;
        NSArray *arr1 = [NSArray arrayWithObjects:@"注销单号",@"终端号",@"申请日期",@"注销状态", nil];
        [self setupHeaderViewWithArray:arr1];
        [self.tableView reloadData];
    }
    if (Index == 3) {
        NSLog(@"点击了更新资料");
        self.afterType = AfterSellTypeUpdate;
        self.csType = CSTypeUpdate;
        NSArray *arr2 = [NSArray arrayWithObjects:@"更新资料单号",@"终端号",@"申请日期",@"更新状态", nil];
        [self setupHeaderViewWithArray:arr2];
        [self.tableView reloadData];
    }
}

//选择状态
-(void)statusChooseClicked
{
    
}

//终端号搜索
-(void)searchChooseClicked
{
    
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
    CSModel *model = [_dataItem objectAtIndex:indexPath.row];
    AfterSellCell *cell = [AfterSellCell cellWithTableView:tableView WithAfterSellType:_afterType WithCsModel:model];
    [cell setContentWithData:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
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
    return 30.f;
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
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getCSListWithAgentID:delegate.agentID token:delegate.token csType:_csType keyword:nil status:_currentStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
