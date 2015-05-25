//
//  UserManagerChildController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerChildController.h"
#import "UserManagerTerminalCell.h"
#import "UserTeminal.h"
#import "NetworkInterface.h"

@interface UserManagerChildController ()

@property (nonatomic, strong) NSMutableArray *dataItem;

@property(nonatomic,strong)UIView *headerView;

@end

@implementation UserManagerChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _userManagerModel.name;
    _dataItem = [[NSMutableArray alloc]init];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self setHeaderView];

}

-(void)setHeaderView
{
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 75);
    if (iOS7) {
        _headerView.frame = CGRectMake(0, 0, kScreenHeight, 75);
    }
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"持有终端";
    firstLabel.font = [UIFont systemFontOfSize:15];
    firstLabel.frame = CGRectMake(100, 25, 80, 25);
    [_headerView addSubview:firstLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(201, 201, 201, 1.0);
    line.frame = CGRectMake(0, 60, kScreenWidth, 0.7);
    if (iOS7) {
        line.frame = CGRectMake(0, 60, kScreenHeight, 0.7);
    }
    [_headerView addSubview:line];
    
}

-(void)setHeaderAndFooterView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
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
    [NetworkInterface getUserTerminalListWithUserID:_userManagerModel.customersId token:delegate.token page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"加载完成";
                    if (!isMore) {
                        [_dataItem removeAllObjects];
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
                    [self parseUserTerminalWithDictionary:object];
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

- (void)parseUserTerminalWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *terminalList = [dict objectForKey:@"result"];
    for (int i = 0; i < [terminalList count]; i++) {
        id terminalDict = [terminalList objectAtIndex:i];
        if ([terminalDict isKindOfClass:[NSDictionary class]]) {
            UserTeminal *model = [[UserTeminal alloc] initWithParseDictionary:terminalDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
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
    UserTeminal *model = [_dataItem objectAtIndex:indexPath.row];
    UserManagerTerminalCell *cell = [UserManagerTerminalCell cellWithTableView:tableView];
    cell.terminalLabel.text = model.terminalNum;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}
@end
