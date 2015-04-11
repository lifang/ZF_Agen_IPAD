//
//  IdentificationViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "IdentificationViewController.h"
#import "IdentificationViewCell.h"
#import "NetworkInterface.h"
#import "RefreshView.h"
#import "IdentificationModel.h"
#import "TerminalManagerModel.h"
#import "ApplyDetailController.h"

@interface IdentificationViewController ()<RefreshDelegate,LoginSuccessDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property(nonatomic,strong)NSString *status;

//终端信息数据
@property (nonatomic, strong) NSMutableArray *applyList;


@end

@implementation IdentificationViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通认证";
    self.view.backgroundColor = [UIColor whiteColor];
    _applyList = [[NSMutableArray alloc]init];
    [self setupHeaderAndFooterView];
    [self initAndLayoutUI];
    [self firstLoadData];
}


-(void)setupHeaderAndFooterView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 28);
    }
    UIView *bottomView = [[UIView alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:14];
    
    UILabel *first = [[UILabel alloc]init];
    first.font = mainFont;
    first.text = @"终端号";
    first.frame = CGRectMake(110, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"POS机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 130, 0, 70, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"支付通道";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 100, 0, 90, 25);
    [bottomView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"开通状态";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 80, 0, 90, 25);
    [bottomView addSubview:fourth];
    
    bottomView.frame = CGRectMake(0, 36, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 36, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.headerView = headerView;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kColor(210, 210, 210, 1.0);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    if (iOS7) {
        footerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    }
    _tableView.tableFooterView = footerView;
    
}

#pragma mark - UI


- (void)initAndLayoutUI {
    
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 28, SCREEN_HEIGHT-20*2, SCREEN_WIDTH-28)];
        
    }else
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 28, SCREEN_WIDTH-20*2, SCREEN_HEIGHT-28)];
        
    }
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -60,_tableView.frame.size.width, 60)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
}




-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@-%@-%d-%d",delegate.token,delegate.agentID,page,kPageSize);
    
    [NetworkInterface getApplyListWithToken:delegate.token agentId:delegate.agentID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_applyList removeAllObjects];
                    }
                    if ([[object objectForKey:@"result"] count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    NSLog(@"object:%@",object);
                    [self parseApplyDataWithDictionary:object];
                    
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

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
       // return;
   // }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"applyList"];
    for (int i = 0; i < [TM_List count]; i++) {
        IdentificationModel *IF_Model = [[IdentificationModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_applyList addObject:IF_Model];
        NSLog(@"_applyList:%@",_applyList);
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
        [_topRefreshView refreshViewDidFinishedLoading:self.tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0,self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:self.tableView];
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
    _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
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
    if (scrollView == self.tableView) {
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
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}
- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [_status intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _applyList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdentificationViewCell *cell = [IdentificationViewCell cellWithTableView:tableView];
    IdentificationModel *model = [_applyList objectAtIndex:indexPath.row];
    cell.terminalLabel.text = model.TM_serialNumber;
    cell.posLabel.text = [NSString stringWithFormat:@"%@%@",model.TM_brandsName,model.TM_model_number];
    cell.payRoad.text = model.TM_channelName;
    self.status = model.TM_status;
    cell.dredgeStatus.text = [self getStatusString];
    
    //用来标识数据的id
    cell.applicationBtn.tag = indexPath.row;
    //cell.vedioConfirmBtn.tag = [model.TM_ID intValue];
    if(  [model.TM_status  isEqualToString:@"2"])
    {
        [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];
        
        cell.applicationBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else
    {
        [cell.applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return cell;
}

-(void)vedioConfirmClick:(UIButton *)button
{
    NSLog(@"%d",button.tag);
}

-(void)applicationClick:(UIButton *)button
{
    
    TerminalManagerModel *model = [_applyList objectAtIndex:button.tag];
    
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
    detailC.hidesBottomBarWhenPushed = YES;
    if(  [model.TM_status  isEqualToString:@"2"])
    {
        detailC.openStatus = OpenStatusReopen;
        
        
    }else
    {
        detailC.openStatus = OpenStatusNew;
        
    }
    detailC.terminalID = model.TM_ID;
    
    [self.navigationController pushViewController:detailC animated:YES];
    
}

//-(void)applicationClicks:(UIButton *)button
//{
//    NSLog(@"%ld",(long)button.tag);
//
//    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
//    detailC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
//    detailC.openStatus = OpenStatusReopen;
//    detailC.hidesBottomBarWhenPushed = YES;
//
//    [self.navigationController pushViewController:detailC animated:YES];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DynamicStatus *status = [_listArray objectAtIndex:indexPath.row];
    //    DynamicChildViewController *dynamicVC = [[DynamicChildViewController alloc]init];
    //    dynamicVC.page =  status.ids;
    //    [self.navigationController pushViewController:dynamicVC animated:YES];
    //    SLog(@"点击了第%ld行",indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


@end
