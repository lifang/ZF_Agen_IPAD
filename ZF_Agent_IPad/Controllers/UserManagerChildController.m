//
//  UserManagerChildController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerChildController.h"

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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"terminalC"];
    cell.textLabel.text = @"asdasdasdas";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 25.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
@end
