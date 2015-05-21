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
#import "SearchTermianlViewController.h"
#import "VideoAuthViewController.h"
#import "TerminalDetailViewController.h"
#import "AgreenMentController.h"

@interface IdentificationViewController ()<RefreshDelegate,LoginSuccessDelegate,UITableViewDelegate,UITableViewDataSource,SearchDelegate>
{
    
    NSInteger touchStatus;
    
}

//@property(nonatomic,strong)UIView *headerView;
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

@property(nonatomic,strong)NSString *serialNum;

@property(nonatomic,strong)NSString *tm_id;

@end

@implementation IdentificationViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"开通认证";
    self.view.backgroundColor=[UIColor whiteColor];
    
    touchStatus=100;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoNewApply:) name:@"newApply" object:nil];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbar.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
    self.view.backgroundColor = [UIColor whiteColor];
    _applyList = [[NSMutableArray alloc]init];
    [self setupHeaderAndFooterView];
    [self initAndLayoutUI];
    [self firstLoadData];
}


-(void)setupHeaderAndFooterView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:headerView];
  
    headerView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 28);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 60, SCREEN_HEIGHT, 28);
    }

    UIFont *mainFont = [UIFont systemFontOfSize:14];
    
    UILabel *first = [[UILabel alloc]init];
    first.backgroundColor=[UIColor clearColor];
    first.font = mainFont;
    first.text = @"终端号";
    first.frame = CGRectMake(120,2, 70, 25);
    [headerView addSubview:first];
 
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"POS机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 140, 2, 70, 25);
    [headerView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"支付通道";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 110, 2, 90, 25);
    [headerView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"开通状态";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 90, 2, 90, 25);
    [headerView addSubview:fourth];
   
}

#pragma mark - UI


- (void)initAndLayoutUI {
    
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 28+60, SCREEN_HEIGHT-20*2, SCREEN_WIDTH-28)];
        
    }else
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 28+60, SCREEN_WIDTH-20*2, SCREEN_HEIGHT-28)];
        
    }
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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



-(void)searchBtnPressed:(id)sender
{
    SearchTermianlViewController *searchTerminalVC=[[SearchTermianlViewController alloc] init];
    searchTerminalVC.delegate=self;
    searchTerminalVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchTerminalVC animated:YES];
    
}

#pragma mark - searchTerminal
- (void)getSearchKeyword:(NSString *)keyword
{
    touchStatus=200;
    _serialNum=keyword;
    [self firstLoadData];
    
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
    if (touchStatus==100) {
        
    [self downloadDataWithPage:_page isMore:NO];
        
    }
    else
    {
        
    [self searchTermianlsWithPage:_page Termianls:_serialNum isMore:NO];
    
    }
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
                    if ([[[object objectForKey:@"result"] objectForKey:@"applyList"] count] > 0) {
                        //有数据
                        _page++;
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

- (void)searchTermianlsWithPage:(int)page Termianls:(NSString *)string isMore:(BOOL)isMore {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@-%@-%d-%d",delegate.token,delegate.agentID,page,kPageSize);
    
    [NetworkInterface  searchApplyListWithToken:delegate.token agentID:delegate.agentID page:page rows:kPageSize serialNum:string finished:^(BOOL success, NSData *response) {
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
                    if ([[[object objectForKey:@"result"] objectForKey:@"applyList"] count] > 0) {
                        //有数据
                         _page++;
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
    if (![dict objectForKey:@"result"]) {
        return;
   }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"applyList"];
    for (int i = 0; i < [TM_List count]; i++) {
        IdentificationModel *IF_Model = [[IdentificationModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_applyList addObject:IF_Model];
        NSLog(@"_applyList:%@",_applyList);

      }
    [_tableView reloadData];
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
    //[self downloadDataWithPage:self.page isMore:YES];
    if (touchStatus==100) {
        
        [self downloadDataWithPage:_page isMore:YES];
        
    }
    else
    {
        
        [self searchTermianlsWithPage:_page Termianls:_serialNum isMore:YES];
        
    }
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

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   // return 60;
      return 40;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdentificationModel *model = [_applyList objectAtIndex:indexPath.row];
    NSString *ID = [NSString stringWithFormat:@"isHaveVedio%d",model.isHaveVideo];
    IdentificationViewCell *cell = [[IdentificationViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.terminalLabel.text = model.TM_serialNumber;
    cell.posLabel.text = [NSString stringWithFormat:@"%@%@",model.TM_brandsName,model.TM_model_number];
    cell.payRoad.text = model.TM_channelName;
    self.status = model.TM_status;
    cell.dredgeStatus.text = [self getStatusString];
    
    //用来标识数据的id
    cell.applicationBtn.tag = indexPath.row;
    cell.videoConfirmBtn.tag = [model.TM_ID intValue];
    if(  [model.TM_status  isEqualToString:@"2"])
    {
        [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];
        cell.applicationBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if ([model.appID isEqualToString:@""]) {
            [cell.applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        }else{
            [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];
        }
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.videoConfirmBtn addTarget:self action:@selector(vedioConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

-(void)vedioConfirmClick:(UIButton *)button
{
    
    if (button.tag == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请先申请开通！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self beginVideoAuthWithTerminalID:[NSString stringWithFormat:@"%d",button.tag]];
    
    VideoAuthViewController *videoAuthC = [[VideoAuthViewController alloc] init];
    videoAuthC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
    videoAuthC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:videoAuthC animated:YES];
}

- (void)beginVideoAuthWithTerminalID:(NSString *)terminalID {
    [NetworkInterface beginVideoAuthWithTerminalID:terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];

}

-(void)applicationClick:(UIButton *)button
{
    
    TerminalManagerModel *model = [_applyList objectAtIndex:button.tag];
    if ([model.openstatus isEqualToString:@"6"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"正在第三方审核,请耐心等待..."
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    ApplyDetailController *detailVC = [[ApplyDetailController alloc] init];
   //detailVC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    if( [model.appID  isEqualToString:@""])
    {
        _tm_id = model.TM_ID;
        //申请开通
        AgreenMentController *agreenVC = [[AgreenMentController alloc]init];
        agreenVC.pushStyle = PushDredge;
        agreenVC.tm_id = model.TM_ID;
        agreenVC.protocolStr = model.protocol;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:agreenVC];
        
        nav.navigationBarHidden = YES;
        
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:nav animated:YES completion:nil];
    }else
    {
        //重新申请开通
        detailVC.openStatus = OpenStatusReopen;
        detailVC.terminalID = model.TM_ID;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IdentificationModel *model = [_applyList objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }else{
        TerminalDetailViewController *terminalVC = [[TerminalDetailViewController alloc]init];
        terminalVC.hidesBottomBarWhenPushed = YES;
        terminalVC.dealStatus = model.TM_status;
        terminalVC.isHaveVideo = model.isHaveVideo;
        terminalVC.tm_ID = model.TM_ID;
        terminalVC.appID = model.appID;
        terminalVC.type = model.type;
        terminalVC.openStatus = model.openstatus;
        [self.navigationController pushViewController:terminalVC animated:YES];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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

- (void)pushtoNewApply:(NSNotification *)notification {
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.hidesBottomBarWhenPushed = YES;
    detailC.openStatus = OpenStatusNew;
    detailC.terminalID = _tm_id;
    [self.navigationController pushViewController:detailC animated:YES];
}
@end
