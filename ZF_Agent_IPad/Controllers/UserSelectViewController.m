//
//  UserSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserSelectViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface UserSelectViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSString *searchUserName; //搜索的代理商名

@end

@implementation UserSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择用户";
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn setImage:[UIImage imageNamed:@"search_White"] forState:UIControlStateNormal];
    UIBarButtonItem *kongBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    kongBar.width = 30.f;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    NSArray *rightArr = [NSArray arrayWithObjects:kongBar,rightBar, nil];
    self.navigationItem.rightBarButtonItems = rightArr;
    
    _dataItem = [[NSMutableArray alloc] init];
    [self setupSearchBar];
    [self initAndLayoutUI];
    [self firstLoadData];
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
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
    [NetworkInterface getAllUserWithAgentID:delegate.agentID keyword:self.searchUserName page:page rows:kPageSize * 2 finished:^(BOOL success, NSData *response) {
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
                    id list = nil;
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        list = [[object objectForKey:@"result"] objectForKey:@"merchaneList"];
                    }
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
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
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id userList = [[dict objectForKey:@"result"] objectForKey:@"merchaneList"];
    if ([userList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [userList count]; i++) {
            id userDict = [userList objectAtIndex:i];
            if ([userDict isKindOfClass:[NSDictionary class]]) {
                UserModel *model = [[UserModel alloc] initWithParseTerminalDictionary:userDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userIdentifier = @"userIdentifier";
   // MultipleDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier];
    }
    UserModel *model = [_dataItem objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.text = model.userName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserModel *model = [_dataItem objectAtIndex:indexPath.row];
    [self searchBarCancelButtonClicked:_searchBar];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedUser:)]) {
        [_delegate selectedUser:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上下拉刷新重写


- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

#pragma mark - Notification

- (void)refreshData:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSearchBar
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"请输入用户名称";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.backgroundColor = [UIColor blackColor];
    _searchBar.hidden = YES;
    _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    if (iOS7) {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 70);
    }
    [self.navigationController.view addSubview:_searchBar];
}

-(void)rightClicked
{
    _searchBar.hidden = NO;
    [_searchBar becomeFirstResponder];
}

#pragma mark - Set

- (void)setSearchUserName:(NSString *)searchUserName {
    _searchUserName = searchUserName;
    [self firstLoadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
    if (self.searchUserName && ![self.searchUserName isEqualToString:@""]) {
        _searchBar.text = @"";
        self.searchUserName = _searchBar.text;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
    self.searchUserName = _searchBar.text;
}

@end
