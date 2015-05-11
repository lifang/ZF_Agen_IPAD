//
//  UserManagerController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerController.h"
#import "NetworkInterface.h"
#import "UserManagerModel.h"
#import "UserManagerCell.h"
#import "UserManagerChildController.h"

@interface UserManagerController ()<userManagerCellDelegate>

@property(nonatomic,strong)UIView *headerView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property(nonatomic,strong)UserManagerModel *selectedModel;

@end

@implementation UserManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataItem = [[NSMutableArray alloc]init];
    [self setupNavBar];
    [self initAndLayoutUI];
    [self firstLoadData];
}

-(void)setupNavBar
{
    //设置导航栏文字
    self.title = @"用户管理";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
//    UIBarButtonItem *rightZeroBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    rightZeroBar.width = 40.f;
//    
//    UIButton *rightBtn = [[UIButton alloc]init];
//    [rightBtn addTarget:self action:@selector(searchUser) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.frame = CGRectMake(0, 0, 35, 35);
//    [rightBtn setImage:[UIImage imageNamed:@"search_White"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    NSArray *rightArr = [NSArray arrayWithObjects:rightZeroBar,rightBar,nil];
//    self.navigationItem.rightBarButtonItems = rightArr;
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
    [self setupHeaderView];
}

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
    first.text = @"用户名";
    first.frame = CGRectMake(140, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"手机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 140, 0, 120, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"邮箱";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 70, 0, 90, 25);
    [bottomView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"创建日期";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 90, 0, 90, 25);
    [bottomView addSubview:fourth];

    bottomView.frame = CGRectMake(0, 26, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 26, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.headerView = headerView;
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

#pragma mark - Action
////搜索按钮
//-(void)searchUser
//{
//    
//}

#pragma mark - userManagerDelegate
-(void)userManagerCellDeleteUserModel:(UserManagerModel *)model
{
    NSLog(@"点击了删除！");
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthUM]] boolValue]) {
        self.selectedModel = model;
        [self deleteSingleUser];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有用户管理权限";
    }
   
}

#pragma mark - UITableView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
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
    UserManagerModel *model = [_dataItem objectAtIndex:indexPath.row];
    UserManagerCell *cell = [UserManagerCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell setContentWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserManagerModel *model = [_dataItem objectAtIndex:indexPath.row];
    UserManagerChildController *userChildVC = [[UserManagerChildController alloc]init];
    userChildVC.userManagerModel = model;
    userChildVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userChildVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return hUserModelCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
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
    [NetworkInterface getUserListWithAgentID:delegate.agentUserID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    [self parseUserDataWithDictionary:object];
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

- (void)parseUserDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *userList = [dict objectForKey:@"result"];
    for (int i = 0; i < [userList count]; i++) {
        id userDict = [userList objectAtIndex:i];
        if ([userDict isKindOfClass:[NSDictionary class]]) {
            UserManagerModel *model = [[UserManagerModel alloc] initWithParseDictionary:userDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

//删除单个用户
- (void)deleteSingleUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteUserWithAgentID:delegate.agentID token:delegate.token userIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:[_selectedModel.customersId intValue]]] finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [_dataItem removeObject:_selectedModel];
                    [self.tableView reloadData];
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

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
