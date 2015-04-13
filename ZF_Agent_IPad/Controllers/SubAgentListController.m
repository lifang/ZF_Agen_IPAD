//
//  SubAgentListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentListController.h"
#import "AppDelegate.h"
#import "SubAgentCell.h"
#import "MineCommonController.h"
#import "MJRefresh.h"

@interface SubAgentListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, assign) int page;

@end

@implementation SubAgentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"管理下级代理商";
    _dataItem = [[NSMutableArray alloc] init];
    
    [self setLeftViewWith:ChooseViewAfterSell];

    UILabel*namelable=[[UILabel alloc]init];
    namelable.frame=CGRectMake(180, 40,  160, 30);
    namelable.font=[UIFont systemFontOfSize:20];
    
    namelable.text=@"默认分润比例:1%";
    UIButton *setbutton = [[UIButton alloc]init];
    [setbutton addTarget:self action:@selector(addAddressD) forControlEvents:UIControlEventTouchUpInside];
   setbutton.frame = CGRectMake(360, 35, 120, 40);
    [setbutton setTitle:@"重置" forState:UIControlStateNormal];
    [setbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setbutton setBackgroundColor:kMainColor];
    
    
    
    
    UIButton *setnextbutton = [[UIButton alloc]init];
    [setnextbutton addTarget:self action:@selector(addAddressD) forControlEvents:UIControlEventTouchUpInside];
    [setnextbutton setTitle:@"创建下级代理商" forState:UIControlStateNormal];
    [setnextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setnextbutton setBackgroundColor:kMainColor];
    [self.view addSubview:setnextbutton];
    
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
    UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(180, 90, wide-200, 20)];
    rootview.backgroundColor = kColor(235, 233, 233, 1);
    [self.view addSubview: rootview];
    
    
    UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 60, 20)];
    [rootview addSubview:goodslable];
    goodslable.textAlignment = NSTextAlignmentCenter;
    
    goodslable.text=@"商品";
    
    UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-20, 0, 100, 20)];
    [rootview addSubview:phonelable];
    phonelable.textAlignment = NSTextAlignmentCenter;
    
    phonelable.text=@"押金";
    UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-120, 0, 80, 20)];
    [rootview addSubview:numberlable];
    numberlable.textAlignment = NSTextAlignmentCenter;
    
    numberlable.text=@"租赁数量";

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if(iOS7)
    {
        _tableView.frame=CGRectMake(160, 90,  SCREEN_HEIGHT-220, SCREEN_WIDTH-90);
        setnextbutton.frame = CGRectMake(SCREEN_HEIGHT-220-60, 35, 160, 40);

    }
    else
    {
        _tableView.frame=CGRectMake(160, 90,  SCREEN_WIDTH-220, SCREEN_HEIGHT-90);

        setnextbutton.frame = CGRectMake(SCREEN_WIDTH-220-60, 35, 160, 40);

    
    }
    [self.view addSubview:namelable];
    [self.view addSubview:setbutton];


    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    //上拉
    [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @">.< 正在努力加载中!";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @">.< 正在努力加载中!";
   
    
    [self initAndLayoutUI];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}

- (void)initAndLayoutUI {
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
    [NetworkInterface getSubAgentListWithAgentID:delegate.agentID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
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
                    [self parseSubAgentListWithDictionary:object];
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

- (void)parseSubAgentListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id agentDict = [infoList objectAtIndex:i];
            if ([agentDict isKindOfClass:[NSDictionary class]]) {
                SubAgentModel *model = [[SubAgentModel alloc] initWithParseDictionary:agentDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = [_dataItem count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSString *titleName = nil;
        switch (indexPath.section) {
            case 0:
                titleName = @"设置默认分润比例";
                break;
            case 1:
                titleName = @"创建下级代理商";
                break;
            default:
                break;
        }
        cell.textLabel.text = titleName;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        return cell;
    }
    else {
        //下级代理商
        static NSString *subAgentIdentifier = @"subAgentIdentifier";
        SubAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:subAgentIdentifier];
        if (cell == nil) {
            cell = [[SubAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subAgentIdentifier];
        }
        SubAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
        [cell setContentWithData:model];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            //默认分润
            
        }
            break;
        case 1: {
            //创建下级代理商
        }
            break;
        case 2: {
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return kSubAgentCellHeight;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.f;
    switch (section) {
        case 0:
            height = 0.001f;
            break;
        case 1:
            height = 5.f;
            break;
        case 2:
            height = 20.f;
            break;
        default:
            break;
    }
    return height;
}

//下拉刷新加载更多微博数据
-(void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
    
    [self firstLoadData];
    
    
    //上拉加载
    
    
    
    
    //    });
}

//上拉刷新加载更多微博数据
-(void)loadMoreStatuses
{
    [self downloadDataWithPage:self.page isMore:YES];
    
    
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_Seatchtable footerEndRefreshing];
    //
    //    });
}



@end
