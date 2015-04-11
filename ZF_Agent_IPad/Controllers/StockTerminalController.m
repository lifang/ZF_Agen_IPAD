//
//  StockTerminalController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StockTerminalController.h"
#import "StockTerminalModel.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "StockTerminalCell.h"

@interface StockTerminalController ()

@property (nonatomic, strong) UILabel *prepareCountLabel;

@property (nonatomic, strong) UILabel *openCountLabel;

@property (nonatomic, strong) UILabel *prepareTimeLabel;

@property (nonatomic, strong) UILabel *openTimeLabel;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property(nonatomic,strong)UIView *middleView;

@end

@implementation StockTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下级代理商库存详情";
    _dataItem = [[NSMutableArray alloc]init];
    [self initAndLayoutUI];
    [self fillStaticData];
    [self firstLoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    [self initRefreshViewWithOffset:0];
    [self setHeaderAndFooterView];
    [self setMiddleView];
}

-(void)setMiddleView
{
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    if (iOS7) {
        middleView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    }
    middleView.backgroundColor = kColor(229, 228, 228, 1.0);
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.text = @"终端号";
    firstLabel.font = [UIFont systemFontOfSize:15.f];
    firstLabel.textColor = kColor(60, 60, 60, 1.0);
    firstLabel.frame = CGRectMake(170, 20, 100, 20);
    [middleView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = @"机型";
    secondLabel.font = [UIFont systemFontOfSize:15.f];
    secondLabel.textColor = kColor(60, 60, 60, 1.0);
    secondLabel.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 200, 20, 100, 20);
    [middleView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.text = @"开通状态";
    thirdLabel.font = [UIFont systemFontOfSize:15.f];
    thirdLabel.textColor = kColor(60, 60, 60, 1.0);
    thirdLabel.frame = CGRectMake(CGRectGetMaxX(secondLabel.frame) + 170, 20, 100, 20);
    [middleView addSubview:thirdLabel];

    
    self.middleView = middleView;
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200.f)];
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, kScreenHeight, 200.f);
    }
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    [self addAgentInfoViewForHeaderView:headerView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
}

- (void)addAgentInfoViewForHeaderView:(UIView *)headerView {
    
    CGFloat originX = 80.f;
    CGFloat originY = 30.f;
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 300.f;
    
    _prepareCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    _prepareCountLabel.textAlignment = NSTextAlignmentLeft;
    _prepareCountLabel.textColor = kColor(51, 51, 51, 1.0);
    _prepareCountLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:_prepareCountLabel];
    
    _openCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, CGRectGetMaxY(_prepareCountLabel.frame) + 5, labelWidth, labelHeight)];
    _openCountLabel.textAlignment = NSTextAlignmentLeft;
    _openCountLabel.textColor = kColor(51, 51, 51, 1.0);
    _openCountLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:_openCountLabel];
    
    _prepareTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, CGRectGetMaxY(_openCountLabel.frame) + 10, labelWidth, labelHeight)];
    _prepareTimeLabel.textAlignment = NSTextAlignmentLeft;
    _prepareTimeLabel.textColor = kColor(98, 97, 97, 1.0);
    _prepareTimeLabel.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:_prepareTimeLabel];
    
    _openTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, CGRectGetMaxY(_prepareTimeLabel.frame) + 5, labelWidth, labelHeight)];
    _openTimeLabel.textAlignment = NSTextAlignmentLeft;
    _openTimeLabel.textColor = kColor(98, 97, 97, 1.0);
    _openTimeLabel.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:_openTimeLabel];
    
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
    [NetworkInterface getStockTerminalWithAgentID:delegate.agentID token:delegate.token channelID:_stockModel.stockChannelID goodID:_stockModel.stockGoodID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _middleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *stockTerminalIdentifier = @"stockTerminalIdentifier";
    StockTerminalCell *cell = [tableView dequeueReusableCellWithIdentifier:stockTerminalIdentifier];
    if (cell == nil) {
        cell = [[StockTerminalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stockTerminalIdentifier];
    }
    StockTerminalModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kStockTermainalCellHeight;
}


#pragma mark - Data

- (void)fillStaticData {
    _prepareCountLabel.text = [NSString stringWithFormat:@"配货总量  %d",_stockAgentModel.totalCount];
    _openCountLabel.text = [NSString stringWithFormat:@"已开通量  %d",_stockAgentModel.openCount];
    _prepareTimeLabel.text = [NSString stringWithFormat:@"上次配货日期  %@",_stockAgentModel.prepareTime];
    _openTimeLabel.text = [NSString stringWithFormat:@"上次开通日期  %@",_stockAgentModel.openTime];
}
- (void)parseStockListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id terminalList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([terminalList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [terminalList count]; i++) {
            id terminalDict = [terminalList objectAtIndex:i];
            StockTerminalModel *model = [[StockTerminalModel alloc] initWithParseDictionary:terminalDict];
            [_dataItem addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}
@end
