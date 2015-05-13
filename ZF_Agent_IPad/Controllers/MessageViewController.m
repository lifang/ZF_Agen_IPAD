//
//  MessageViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"
#import "MessageChildViewController.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "MessageModel.h"
#import "NetworkInterface.h"
#import "AccountTool.h"

@interface MessageViewController ()<RefreshDelegate,MessageCellClickedDelegate,UIAlertViewDelegate>

@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,strong)UIButton *konggeBtn;

@property(nonatomic,assign)BOOL isAll;

@property (nonatomic, assign) BOOL isMultiDelete;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/
@property (nonatomic, strong) NSMutableArray *messageItems;
@property (nonatomic, strong) NSMutableArray *selectedItem; //多选的行

@property (nonatomic, strong) UIView *bottomView;

@property(nonatomic,strong)MessageModel *messageModel;
@end

@implementation MessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRefreshView];
    [self firstLoadData];
    [self setupNavBar];
    self.tableView.backgroundColor = kColor(241, 240, 240, 1.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageItems = [[NSMutableArray alloc] init];
    _selectedItem = [[NSMutableArray alloc] init];
    self.isAll = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessageList:)
                                                 name:RefreshMessageListNotification
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"DarkGray")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"green")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

-(void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"DarkGray"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIView *navbarView = [[UIView alloc]init];
    navbarView.userInteractionEnabled = YES;
    
    UIView *konggeV = [[UIView alloc]init];
    konggeV.backgroundColor = [UIColor clearColor];
    konggeV.userInteractionEnabled = YES;
    konggeV.frame = CGRectMake(0, 0, 40, 40);
    
    UIButton *konggeBtn = [[UIButton alloc]init];
    [konggeBtn setBackgroundImage:[UIImage imageNamed:@"noSelected1"] forState:UIControlStateNormal];
    [konggeBtn addTarget:self action:@selector(konggeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.konggeBtn = konggeBtn;
    self.isSelected = YES;
    konggeBtn.frame = CGRectMake(5, 5, 25, 25);
    [konggeV addSubview:konggeBtn];
    
    UIView *readV = [[UIView alloc]init];
    readV.backgroundColor = [UIColor clearColor];
    readV.userInteractionEnabled = YES;
    readV.frame = CGRectMake(0, 0, 120, 50);
    
    UIButton *readBtn = [[UIButton alloc]init];
    [readBtn addTarget:self action:@selector(haveReadClicked) forControlEvents:UIControlEventTouchUpInside];
    CALayer *readBtnLayer = [readBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    readBtn.backgroundColor = [UIColor clearColor];
    [readBtn setTitle:@"标记为已读" forState:UIControlStateNormal];
    readBtn.frame = CGRectMake(- 5, 3, 120, 37);
    [readV addSubview:readBtn];
    
    UIView *deleteV = [[UIView alloc]init];
    deleteV.backgroundColor = [UIColor clearColor];
    deleteV.userInteractionEnabled = YES;
    deleteV.frame = CGRectMake(0, 0, 120, 50);
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn addTarget:self action:@selector(deleteClieked) forControlEvents:UIControlEventTouchUpInside];
    CALayer *deleteBtnLayer = [deleteBtn layer];
    [deleteBtnLayer setMasksToBounds:YES];
    [deleteBtnLayer setCornerRadius:2.0];
    [deleteBtnLayer setBorderWidth:1.0];
    [deleteBtnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(- 5, 3, 120, 37);
    [deleteV addSubview:deleteBtn];
    
    UIBarButtonItem *withBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar.width = 10;
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:konggeV];
    UIBarButtonItem *withBar1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar1.width = 20;
    UIBarButtonItem *zhongjianBar = [[UIBarButtonItem alloc]initWithCustomView:readV];
    UIBarButtonItem *withBar2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar2.width = 15;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:deleteV];
    NSArray *arr = [NSArray arrayWithObjects:withBar,leftBar,withBar1,zhongjianBar,withBar2,rightBar, nil];
    
    self.navigationItem.leftBarButtonItems = arr;
}

-(void)setRefreshView
{
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [self.tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [self.tableView addSubview:_bottomRefreshView];
}

-(void)haveReadClicked
{
    [self setReadStatusForSelectedMessages];
}

//标记已读
- (void)setReadStatusForSelectedMessages {
    NSArray *messagesID = [NSArray arrayWithArray:_selectedItem];
    if ([messagesID count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要标注的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface readMultiMessageWithAgentID:delegate.agentUserID token:delegate.token messageIDs:messagesID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"标注成功";
                    [_selectedItem removeAllObjects];
                    [self konggeClicked:_selectedItem];
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

-(void)deleteClieked
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定要删除这些消息吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertV.delegate = self;
    alertV.tag = 11133;
    [alertV show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11133) {
        if (buttonIndex == 0) {
            if (_selectedItem.count == 1) {
                [self deleteSingleMessage];
            }
            else {
                [self deleteSelectedMessages];
            }
        }
    }
}

//多删
- (void)deleteSelectedMessages {
    if ([_selectedItem count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择需要删除的消息";
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteMultiMessageWithAgentID:delegate.agentUserID token:delegate.token messageIDs:_selectedItem finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [_selectedItem removeAllObjects];
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

//单删
- (void)deleteSingleMessage{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteSingleMessageWithAgentID:delegate.agentUserID token:delegate.token messageID:[_selectedItem objectAtIndex:0] finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [_selectedItem removeAllObjects];
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



-(void)konggeClicked:(id)sender
{
    if (self.isSelected == YES) {
        [_konggeBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        _isAll = YES;
        if ([sender isKindOfClass:[NSArray class]]) {
            _isAll = NO;
            [_konggeBtn setBackgroundImage:[UIImage imageNamed:@"noSelected1"] forState:UIControlStateNormal];
            _isSelected = NO;
        }
        [self.tableView reloadData];
    }
    else{
        [_konggeBtn setBackgroundImage:[UIImage imageNamed:@"noSelected1"] forState:UIControlStateNormal];
        _isAll = NO;
        [self.tableView reloadData];
    }
    self.isSelected = !_isSelected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)messageCellClickedWithMessageID:(NSString *)messageID WithBtnStatus:(BOOL)btnStatus
{
    if (btnStatus) {
        [_selectedItem addObject:messageID];
    }else{
        [_selectedItem removeObject:messageID];
    }
}

-(void)setFooterView
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = v;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell =[MessageViewCell cellWithTableView:tableView];
    cell.MessageCellClickedDelegate = self;
    MessageModel *model = [_messageItems objectAtIndex:indexPath.row];
    cell.selectedID = model.messageID;
    cell.textLabel.text = model.messageTitle;
    cell.timeLabel.text = model.messageTime;
    cell.btnStatus = _isAll;
    cell.isRead = model.messageRead;
    [cell btnClicked];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model = [_messageItems objectAtIndex:indexPath.row];
    MessageChildViewController *messageChildV = [[MessageChildViewController alloc]init];
    messageChildV.message = model;
    messageChildV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageChildV animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
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

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMyMessageListWithAgentID:delegate.agentUserID token:delegate.token page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                        [_messageItems removeAllObjects];
                    }
                    id content = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([content isKindOfClass:[NSArray class]] && [content count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseMessageListWithDictionary:object];
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

- (void)parseMessageListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id messageDict = [infoList objectAtIndex:i];
            if ([messageDict isKindOfClass:[NSDictionary class]]) {
                MessageModel *model = [[MessageModel alloc] initWithParseDictionary:messageDict];
                [_messageItems addObject:model];
            }
        }
    }
    [self setFooterView];
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
        _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
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
    if (!_isMultiDelete) {
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_isMultiDelete) {
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

#pragma mark - NSNotification

- (void)refreshMessageList:(NSNotification *)notification {
    id message = [notification.userInfo objectForKey:@"message"];
    if (message) {
        [_messageItems removeObject:message];
    }
    [self firstLoadData];
}

@end
