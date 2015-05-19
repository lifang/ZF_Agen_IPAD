//
//  StaffManagerController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffManagerController.h"
#import "NetworkInterface.h"
#import "StaffManagerCell.h"
#import "RefreshView.h"
#import "StaffManagerModel.h"
#import "StaffManagerDetailController.h"

@interface StaffManagerController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate,StaffManagerDeleteClickedDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *createdBtn;

@property(nonatomic,strong)UIView *headerView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
//********************************

@property(nonatomic,strong)StaffManagerModel *model;

@property(nonatomic,strong)NSMutableArray *dataItem;

@end

@implementation StaffManagerController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshStaffManagerList:)
                                                 name:RefreshStaffManagerListNotification
                                               object:nil];
    _dataItem = [[NSMutableArray alloc]init];
    [self setLeftViewWith:ChooseViewApplyplan];
    [self setupHeaderView];
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initAndLayoutUI
{
    CGFloat topSpace = 90.f;
    CGFloat leftSpace = 160.f;
    
    _createdBtn = [[UIButton alloc]init];
    _createdBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_createdBtn addTarget:self action:@selector(createdClick) forControlEvents:UIControlEventTouchUpInside];
    [_createdBtn setBackgroundColor:kMainColor];
    [_createdBtn setTitle:@"创建员工账号" forState:UIControlStateNormal];
    [_createdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_createdBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_createdBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:30.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_createdBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.chooseView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:740.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_createdBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:140.f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_createdBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];


    
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:kScreenHeight - 160.f]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:kScreenWidth - 160.f]];
    }
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:kScreenWidth - topSpace]];

    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:kScreenHeight - topSpace]];
    }
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(-120, -80,wide, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(-120, 0, wide, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

-(void)setupHeaderView
{
    CGFloat originX = 160.f;
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = kColor(228, 228, 228, 1.0);
    _headerView.frame = CGRectMake(originX, 0, kScreenWidth - originX, 30);
    if (iOS7) {
       _headerView.frame = CGRectMake(originX, 0, kScreenHeight - originX, 30);
    }
    
    CGFloat leftSpace = 140.f;
    CGFloat mainMargin = 140.f;
    UILabel *loginIDLabel = [[UILabel alloc]init];
    loginIDLabel.text = @"登录ID";
    loginIDLabel.font = [UIFont systemFontOfSize:15.f];
    loginIDLabel.frame = CGRectMake(leftSpace, 0, 50, 30);
    [_headerView addSubview:loginIDLabel];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont systemFontOfSize:15.f];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(loginIDLabel.frame) + mainMargin, 0, 50, 30);
    [_headerView addSubview:nameLabel];
    
    UILabel *createdTimeLabel = [[UILabel alloc]init];
    createdTimeLabel.text = @"创建时间";
    createdTimeLabel.font = [UIFont systemFontOfSize:15.f];
    createdTimeLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + mainMargin, 0, 80, 30);
    [_headerView addSubview:createdTimeLabel];
                                    
}

#pragma mark - UITableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

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
    StaffManagerModel *model = [_dataItem objectAtIndex:indexPath.row];
    StaffManagerCell *cell = [StaffManagerCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell setContentWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffManagerModel *model = [_dataItem objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StaffManagerDetailController *staffVC = [[StaffManagerDetailController alloc]init];
    staffVC.staffModel = model;
    staffVC.statffStatus = staffStatusDetail;
    staffVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:staffVC animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = kColor(199, 197, 204, 1.0);
    v.frame = CGRectMake(10, 0, kScreenWidth - 170.f, 0.7);
    if (iOS7) {
        v.frame = CGRectMake(10, 0, kScreenHeight - 170.f, 0.7);
    }
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.7f;
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
//创建员工
-(void)createdClick
{
    StaffManagerDetailController *staffVC = [[StaffManagerDetailController alloc]init];
    staffVC.statffStatus = staffStatusCreated;
    staffVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:staffVC animated:NO];
}

-(void)deleteClickedWithStaffManagerModel:(StaffManagerModel *)model
{
    NSLog(@"删除了员工！");
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要删除此员工吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.tag = 23456;
    self.model = model;
    [alertV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 23456) {
        if (buttonIndex == 1){
            [self deletedStaffWithStaffModel:_model];
        }
    }
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
    [NetworkInterface getStaffListWithAgentID:delegate.agentID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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

//删除员工
-(void)deletedStaffWithStaffModel:(StaffManagerModel *)model
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteStaffWithAgentID:delegate.agentID Token:delegate.token loginID:model.loginID staffID:model.userID finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES afterDelay:1.f];
                    hud.labelText = @"删除员工成功";
                    [self firstLoadData];
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
                StaffManagerModel *model = [[StaffManagerModel alloc] initWithParseDictionary:csDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(-120, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(-120, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}
#pragma mark - NSNotification

- (void)refreshStaffManagerList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

@end
