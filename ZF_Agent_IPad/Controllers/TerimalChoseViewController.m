//
//  TerimalChoseViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/20.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerimalChoseViewController.h"
#import "TerminalSelectCell.h"
#import "TerminalSelectModel.h"
#import "NetworkInterface.h"
#import "ChannelListModel.h"
#import "RegularFormat.h"
#import "SearchTermianlViewController.h"
#import "MJRefresh.h"
#import "POSModel.h"

@interface TerimalChoseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPopoverControllerDelegate,SearchDelegate>
{
    BOOL isSelected;
    //CGFloat summaryPrice;
    NSInteger sumall;
    NSInteger pickerstatus;
    
}

@property (nonatomic, strong) UITextView *POSTV;
@property (nonatomic, strong) UIButton *POSBtn;
@property (nonatomic, strong) UITextView *channelTV;
@property (nonatomic, strong) UIButton *channelBtn;

@property (nonatomic, strong) UITextView *terminalTV;
@property (nonatomic, strong) UITextView *minPriceTV;
@property (nonatomic, strong) UITextView *maxPriceTV;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *terminalList;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray *terminalItems;

@property (nonatomic, assign) int goodid;
@property (nonatomic, strong) NSString *totalint;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *placeholderLB;
@property (nonatomic, strong) NSString *keword;

@property (nonatomic, strong) NSString *POStitle;
@property (nonatomic, assign) int channelsId;
@property (nonatomic, assign) int minPrice;
@property (nonatomic, assign) int maxPrice;
@property (nonatomic, strong) NSString *masterChannel;
@property (nonatomic, strong) NSString *branchChannel;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIPopoverController *popViewController;

@property (nonatomic, strong) UIPickerView  *pickerView;

@property (nonatomic, strong) NSMutableArray *POSArray;

@property (nonatomic, strong) NSMutableArray *channelItems;

@property (nonatomic, strong) NSArray *pickerArray;  //pickerView 第二列

@property (nonatomic, strong) UILabel *numberLB;
@property (nonatomic, strong) NSMutableArray *terminalFilter;

@end

@implementation TerimalChoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择终端";
    self.view.backgroundColor=[UIColor whiteColor];
    _terminalFilter=[[NSMutableArray alloc] init];
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    _terminalList=[[NSMutableArray alloc] init];
    _POSArray=[[NSMutableArray alloc] init];
    _channelItems=[[NSMutableArray alloc] init];
    
    UILabel *POSLB=[[UILabel alloc ] init];
    POSLB.font = FONT20;
    POSLB.text=@"选择POS机";
    POSLB.textColor = [UIColor colorWithHexString:@"292929"];
    POSLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:POSLB];
    [POSLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(self.view.top).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _POSTV = [[UITextView alloc] init];
    _POSTV.delegate = self;
    _POSTV.userInteractionEnabled = NO;
    _POSTV.clipsToBounds = YES;
    _POSTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _POSTV.layer.borderWidth = 1.0f;
//    _POSTV.layer.cornerRadius = 3.0f;
    _POSTV.font = FONT20;
    _POSTV.textAlignment=NSTextAlignmentLeft;
    _POSTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _POSTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_POSTV];
    [_POSTV  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(POSLB.mas_right).offset(24);
        make.top.equalTo(POSLB.top);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    _POSBtn = [[UIButton alloc] init];
    [_POSBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [_POSBtn addTarget:self action:@selector(POSBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_POSBtn];
    [_POSBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(POSLB.top);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.width.equalTo(@(280/6.0));
        
    }];
    
    
    UILabel *channelLB=[[UILabel alloc ] init];
    channelLB.font = FONT20;
    channelLB.text=@"选择支付通道";
    channelLB.textColor = [UIColor colorWithHexString:@"292929"];
    channelLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:channelLB];
    [channelLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(44);
        make.top.equalTo(self.view.top).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _channelTV = [[UITextView alloc] init];
    _channelTV.delegate = self;
    _channelTV.userInteractionEnabled = NO;
    _channelTV.clipsToBounds = YES;
    _channelTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _channelTV.layer.borderWidth = 1.0f;
//    _channelTV.layer.cornerRadius = 3.0f;
    _channelTV.font = FONT20;
    _channelTV.textAlignment=NSTextAlignmentLeft;
    _channelTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _channelTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_channelTV];
    [_channelTV  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(channelLB.mas_right).offset(24);
        make.top.equalTo(channelLB.top);
        make.right.equalTo(self.view.right).offset(-64);
        make.height.equalTo(@42);
    }];
    
    _channelBtn = [[UIButton alloc] init];
    [_channelBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [_channelBtn addTarget:self action:@selector(channelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_channelBtn];
    [_channelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(POSLB.top);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.right).offset(-64);
        make.width.equalTo(@(280/6.0));
        
    }];
    
    UILabel *TerminalLB=[[UILabel alloc ] init];
    TerminalLB.font = FONT20;
    TerminalLB.text=@"输入终端号";
    TerminalLB.textColor = [UIColor colorWithHexString:@"292929"];
    TerminalLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:TerminalLB];
    [TerminalLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(64);
        make.top.equalTo(POSLB.bottom).offset(60);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _terminalTV = [[UITextView alloc] init];

    _terminalTV.delegate = self;
    _terminalTV.clipsToBounds = YES;
    _terminalTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _terminalTV.layer.borderWidth = 1.0f;
//    _terminalTV.layer.cornerRadius = 3.0f;
    _terminalTV.font = FONT20;
    _terminalTV.textAlignment=NSTextAlignmentLeft;
    _terminalTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _terminalTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_terminalTV];
    [_terminalTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(TerminalLB.mas_right).offset(24);
        make.centerY.equalTo(TerminalLB.centerY);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@80);
    }];
    
    _placeholderLB = [[UILabel alloc] init];
    _placeholderLB.backgroundColor = [UIColor clearColor];
    _placeholderLB.textColor = kColor(146, 146, 146, 1);
    _placeholderLB.font = [UIFont systemFontOfSize:15.f];
    _placeholderLB.text = @"请输入终端号，终端号之间回车间隔";
    [self.view addSubview:_placeholderLB];
    [_placeholderLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_terminalTV.left).offset(5);
        make.top.equalTo(_terminalTV.top).offset(5);
        make.right.equalTo(_terminalTV.right);
        
    }];

    UILabel *priceLB=[[UILabel alloc ] init];
    priceLB.font = FONT20;
//    priceLB.text=@"价格";
    priceLB.textColor = [UIColor colorWithHexString:@"292929"];
    priceLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:priceLB];
    [priceLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(44);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@42);
    }];
    
    
    _minPriceTV = [[UITextView alloc] init];
    _minPriceTV.delegate = self;
    _minPriceTV.clipsToBounds = YES;
//    _minPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _minPriceTV.userInteractionEnabled=NO;
    
//    _minPriceTV.layer.borderWidth = 1.0f;
//    _minPriceTV.layer.cornerRadius = 3.0f;
    _minPriceTV.font = FONT20;
    _minPriceTV.textAlignment=NSTextAlignmentLeft;
    _minPriceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _minPriceTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_minPriceTV];
    [_minPriceTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.right).offset(24);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@42);
    }];
    
    UILabel *LB=[[UILabel alloc ] init];
    LB.font = FONT20;
//    LB.text=@"-";
    LB.textColor = [UIColor colorWithHexString:@"292929"];
    LB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:LB];
    [LB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minPriceTV.right).offset(5);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@42);
    }];
    
    
    _maxPriceTV = [[UITextView alloc] init];
    _maxPriceTV.delegate = self;
    _maxPriceTV.clipsToBounds = YES;
    _minPriceTV.userInteractionEnabled=NO;

//    _maxPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
//    _maxPriceTV.layer.borderWidth = 1.0f;
//    _maxPriceTV.layer.cornerRadius = 3.0f;
    _maxPriceTV.font = FONT20;
    _maxPriceTV.textAlignment=NSTextAlignmentLeft;
    _maxPriceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _maxPriceTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_maxPriceTV];
    [_maxPriceTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LB.right).offset(5);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@42);
    }];
    
    _confirmBtn = [[UIButton alloc] init];
    [ _confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [_confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    [_confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_maxPriceTV.right).offset(10);
        make.centerY.equalTo(TerminalLB.centerY);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.right).offset(-64);
        
        
    }];
    
    UILabel *line=[[UILabel alloc ] init];
    [line setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view  addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_terminalTV.bottom).offset(20);
        make.left.equalTo(self.view.left).offset(60);
        make.right.equalTo(self.view.right).offset(-60);
        make.height.equalTo(@1);
    }];
    
   _name=[[UILabel alloc ] init];
    
    [self.view  addSubview:_name];
    [_name makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(2);
        make.left.equalTo(self.view.left).offset(60);
        make.right.equalTo(self.view.right).offset(-60);
        make.height.equalTo(@30);
    }];
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    //headerView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(32);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@40);
    }];
    
    UILabel *termLB = [[UILabel alloc] init];
    [termLB setBackgroundColor:[UIColor clearColor]];
    [termLB setFont:[UIFont systemFontOfSize:20]];
    termLB.textColor= [UIColor colorWithHexString:@"292929"];
    termLB.text=@"终端号";
    termLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:termLB];
    [termLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        // make.left.equalTo(headerView.left).offset(26);
        make.left.equalTo(headerView.left).offset(100);
        make.right.equalTo(headerView.centerX);
        //make.width.equalTo(@120);
        
    }];
    
    UILabel *priLB = [[UILabel alloc] init];
    [priLB setBackgroundColor:[UIColor clearColor]];
    [priLB setFont:[UIFont systemFontOfSize:20]];
    priLB.textColor= [UIColor colorWithHexString:@"292929"];
    priLB.text=@"价格";
    priLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:priLB];
    [priLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.centerX);
        make.right.equalTo(headerView.right).offset(-200);
        //make.width.equalTo(@120);
        
    }];
    
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"searchbars"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        // make.left.equalTo(priceLB.right).offset(60);
        make.right.equalTo(headerView.right).offset(-100);
        make.width.equalTo(@40);
        
    }];

    
    
    _tableView= [[UITableView alloc] init];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];

    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-60);
    }];
    
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @">.< 正在努力加载中!";
    [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
    //上拉
    [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];


    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @">.< 正在努力加载中!";
    
    //创建头部View
    UIView *FooterView = [[UIView alloc]init];
    FooterView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:FooterView];
    [FooterView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@60);
    }];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [FooterView addSubview:_finishBtn];
    [_finishBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.right.equalTo(self.view.right).offset(-100);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
    
    //选中按钮
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_selectedBtn.frame=CGRectMake(35, 15, 30, 30);
    [_selectedBtn addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [FooterView addSubview:_selectedBtn];
    [_selectedBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.left.equalTo(self.view.left).offset(100);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
    
    //全选文字
    UILabel *selectedLB = [[UILabel alloc] init];
    selectedLB.backgroundColor = [UIColor clearColor];
    selectedLB.font = [UIFont systemFontOfSize:15.f];
    selectedLB.textColor = kColor(128, 126, 126, 1);
    selectedLB.text = @"全选";
    selectedLB.userInteractionEnabled = YES;
    [FooterView addSubview:selectedLB];
    [selectedLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.left.equalTo(_selectedBtn.right).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
    
    if (isSelected) {
        
        [_selectedBtn setImage:kImageName(@"select_height") forState:UIControlStateNormal];
        selectedLB.textColor = [UIColor blackColor];
    }
    else {
        
        [_selectedBtn setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        selectedLB.textColor = kColor(128, 126, 126, 1);
    }
    
    
    _numberLB = [[UILabel alloc] init];
    _numberLB.font = [UIFont boldSystemFontOfSize:16.f];
    //numberLB.text = [NSString stringWithFormat:@"已选中%d台",sumall];
    _numberLB.text = [NSString stringWithFormat:@"已选中0台"];
    [FooterView addSubview:_numberLB];
    [_numberLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.centerX.equalTo(FooterView.centerX);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
    
    
    
}
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        _placeholderLB.text = @"请输入终端号，终端号之间回车间隔";
    }
    else {
        _placeholderLB.text = @"";
    }
}

-(void)searchBtnPressed:(id)sender
{
    SearchTermianlViewController *searchTerminalVC=[[SearchTermianlViewController alloc] init];
    searchTerminalVC.delegate=self;
    searchTerminalVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchTerminalVC animated:YES];
    
}
-(void)POSBtnPressed:(id)sender
{
    pickerstatus=100;
    [self ChoosePOSData];
    // _POStitle=[NSString stringWithFormat:@"%@"
    //            , [_POSArray[0] objectForKey:@"title"]];
    //[self pickerDisplay:_POSTV];
    
}

-(void)channelBtnPressed:(id)sender
{
    pickerstatus=200;
    [self getChannelList];
    //[self pickerDisplay:_channelTV];
    
    
}

-(void)confirmBtnPressed:(id)sender
{
  
    if ([self isBlankString:_terminalTV.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入终端号";
        return;
    }
    [_terminalFilter removeAllObjects];
    if([self isBlankString:_terminalTV.text]==NO)
    {
//        NSString*headerDatadgdgfgf= [_terminalTV.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *terminalArray = [_terminalTV.text componentsSeparatedByString:@"\n"];
        for(int i=0;i<terminalArray.count;i++)
        {
        
            [_terminalFilter addObject:[terminalArray objectAtIndex:i]];

        }
        
    }

    [self firstLoadData];
    
    
    
    
}


- (void)refreshSelectedInfo {
    int selectedCount = 0;
    for (TerminalSelectModel *model in _terminalList) {
        if (model.isSelected) {
            selectedCount++;
        }
    }
    if (selectedCount == [_terminalList count]) {
        
        [_selectedBtn setImage:kImageName(@"select_height") forState:UIControlStateNormal];
    }
    else {
        [_selectedBtn setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        
    }
    
    _numberLB.text = [NSString stringWithFormat:@"已选中%d台",selectedCount];
    
}



-(void)selectedBtnPressed:(id)sender
{
    
    isSelected = !isSelected;

    for (TerminalSelectModel *model in _terminalList) {
        model.isSelected = isSelected;
    }
    [_tableView reloadData];
    
    
    if (isSelected) {
        
        [_selectedBtn setImage:kImageName(@"select_height") forState:UIControlStateNormal];
        //selectedLB.textColor = [UIColor blackColor];
    }
    else {
        
        [_selectedBtn setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        //selectedLB.textColor = kColor(128, 126, 126, 1);
    }
    
    
}
- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

//下拉刷新加载更多微博数据
-(void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
    
    if( [self isBlankString: _POSTV.text]==NO||[self isBlankString:_channelTV.text]==NO||[self isBlankString:_terminalTV.text]==NO)
    {
    
        [self firstLoadData];
//        [_tableView footerEndRefreshing];
//        [_tableView headerEndRefreshing];
    
    }
    else
    {
        
        [_tableView footerEndRefreshing];
       [_tableView headerEndRefreshing];

    
    }
    
    
    
    //上拉加载
    
    
    
    
    //    });
}

//上拉刷新加载更多微博数据
-(void)loadMoreStatuses
{
    if( [self isBlankString: _POSTV.text]==NO||[self isBlankString:_channelTV.text]==NO||[self isBlankString:_terminalTV.text]==NO)
    {
        NSLog(@"%@-%@-%@",_POSTV.text,_channelTV.text,_terminalTV.text);
              
        [self downloadDataWithPage:self.page isMore:YES];
//        [_tableView footerEndRefreshing];
//        [_tableView headerEndRefreshing];
    }

    
    else
    {
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    
    }
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_Seatchtable footerEndRefreshing];
    //
    //    });
}


#pragma mark -searchTerminalDelegate

- (void)getSearchKeyword:(NSString *)keyword
{
    
//    _POSTV.text=@"";
//    _channelTV.text=@"";

//    [_terminalFilter removeAllObjects];
    _keword=keyword;
    
//    if (keyword && ![keyword isEqualToString:@""]) {
//        NSString*headerDatadgdgfgf= [keyword stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//        [_terminalFilter addObject:headerDatadgdgfgf];
//    }
   [self firstLoadData];
    
    
}

-(void)select:(TerminalSelectModel *)model
{
    NSLog(@"2322222");
    [self refreshSelectedInfo];
    
}

-(void)finishBtnPressed:(id)sender
{
    
    NSMutableArray *selectedTerminal = [[NSMutableArray alloc] init];
    for (TerminalSelectModel *model in _terminalList) {
        if (model.isSelected) {
            [selectedTerminal addObject:model];
        }
    }
    if ([selectedTerminal count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请至少选择一个终端";
        return;
    }
       [self firstLoadData];

    /*
     NSMutableArray *terminalList = [[NSMutableArray alloc] init];
     for (TerminalSelectModel *model in _terminalList) {
     if (model.isSelected) {
     [terminalList addObject:model];
     }
     }
     */
    
    // if (_delegate && [_delegate respondsToSelector:@selector(getSelectedTerminal:)]) {
    [_delegate getSelectedTerminal:selectedTerminal];
    [self.navigationController popViewControllerAnimated:YES];
    // }
}


//选择POS
- (void)ChoosePOSData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    NSString*idstring;
    
    
    
    if([self isBlankString:self.posid])
    {
        
        idstring=delegate.agentID;
        
    }else
    {
        
        idstring=self.posid;
        
        
    }
    [NetworkInterface getPrepareGoodPOSWithAgentID:idstring token:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"POS：%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [hud hide:YES];
                    [self parsePOSDataWithDictionary:object];
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


//选择支付通道

- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    NSString*idstring;
    
    if([self isBlankString:self.posid])
    {
        
        idstring=delegate.agentID;
        
    }else
    {
        
       idstring=self.posid;
        
        
    }

    [NetworkInterface getPrepareGoodChannelWithAgentID:idstring token:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [hud hide:YES];
                    [self parseChannelListWithDictionary:object];
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


#pragma mark - Request
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"])
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//pos机,通道,价格,筛选终端
- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    self.page = 1;
    NSString*idstring;
    NSString*_channelTVid;
    NSString*_POSTVid;

    if([self isBlankString:self.posid])
    {
        
        idstring=delegate.agentID;
        
    }else
    {
        
        idstring=self.posid;
        
        
    }
if( [self isBlankString: _channelTV.text])
{
    _channelTVid=@"";


}else
{
    _channelTVid=[NSString stringWithFormat:@"%d",_channelsId];

    
}
    if( [self isBlankString: _POSTV.text])
{
    
    _POSTVid=@"";


}else
{
    _POSTVid=[NSString stringWithFormat:@"%d",_goodid];

    
}
    [NetworkInterface getPrepareGoodTerminalListWithAgentID:idstring token:delegate.token channelID:_channelTVid goodID:_POSTVid terminalNumbers:_terminalFilter page:page rows:kPageSize * 2 serialNum:_keword finished:^(BOOL success, NSData *response) {
   
    
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
        
//    [NetworkInterface screeningTerminalNumWithtoken:delegate.token agentId:delegate.agentID POStitle:_POSTV.text channelsId:_channelsId minPrice:[_minPriceTV.text intValue] maxPrice:[_maxPriceTV.text intValue] finished:^(BOOL success, NSData *response)
//     {
         NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
         hud.customView = [[UIImageView alloc] init];
         hud.mode = MBProgressHUDModeCustomView;
         [hud hide:YES afterDelay:0.5f];
         if (success)
         {
             _keword=nil;
             id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
             if ([object isKindOfClass:[NSDictionary class]])
             {
                 

                 NSString *errorCode = [object objectForKey:@"code"];
                 if ([errorCode intValue] == RequestFail)
                 {
                     //返回错误代码
                     hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                 }
                 else if ([errorCode intValue] == RequestSuccess)
                 {
                     [hud hide:YES];
                     [self parseSearchListWithData:object];
                 }
             }
             else
             {
                 //返回错误数据
                 hud.labelText = kServiceReturnWrong;
             }
         }
         else
         {             _keword=nil;

             hud.labelText = kNetworkFailed;
         }
     }];
}

#pragma mark - Data

- (void)parseSearchListWithData:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {

        return;
    }
    _totalint=[[dict objectForKey:@"result"] objectForKey:@"total"];
    _name.text=[NSString stringWithFormat:@"可配货的机器共%@台",_totalint];

    //NSMutableArray *searchList = [[NSMutableArray alloc] init];
    [ _terminalList removeAllObjects];
    id serialList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([serialList isKindOfClass:[NSArray class]]) {
    
        for (int i = 0; i < [serialList count]; i++)
        {
            id TerminalDict = [serialList objectAtIndex:i];
            
            if ([TerminalDict isKindOfClass:[NSDictionary class]]) {
                
                TerminalSelectModel *model = [[TerminalSelectModel alloc] initWithParseDictionary:TerminalDict];
                
                model.goodID=[NSString stringWithFormat:@"%d",_goodid];
                model.channelID=[NSString stringWithFormat:@"%d",_channelsId];
//                model.t_price=[[NSString stringWithFormat:@"%.2f",[[TerminalDict objectForKey:@"money"] floatValue]] floatValue];
                

                [_terminalList addObject:model];
            }
        }

    
    
    }
        [_tableView reloadData];
    
}






#pragma mark - Data

- (void)parseMerchantDataWithDictionary:(NSDictionary *)dict {
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _terminalList = [dict objectForKey:@"result"];
    for (int i = 0; i < [_terminalList count]; i++) {
        TerminalSelectModel *model = [[TerminalSelectModel alloc] initWithParseDictionary:[_terminalList objectAtIndex:i]];
        [_terminalItems addObject:model];
    }
    NSLog(@"Items:%@",_terminalItems);
    [_tableView reloadData];
}


#pragma mark - Data-POS

- (void)parsePOSDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }    //if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
    //    return;
    // }
    // NSDictionary *infoDict = [dict objectForKey:@"result"];
    [_POSArray removeAllObjects];
    
    NSArray *POSList = [dict objectForKey:@"result"];
    for (int i = 0; i < [POSList count]; i++) {
        id POSDict = [POSList objectAtIndex:i];
        if ([POSDict isKindOfClass:[NSDictionary class]])
        {
            POSModel *model = [[POSModel alloc] initWithParsePrepareGoodDictionary:POSDict];
            [_POSArray addObject:model];
            
        }
    }
    if ([_POSArray count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有数据";
    }
//        _POStitle=[NSString stringWithFormat:@"%@", [_POSArray[0] objectForKey:@"goodname"]];
    [self pickerDisplay:_POSTV];
 
    
}

#pragma mark - Data-channel

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *list = [dict objectForKey:@"result"];
    [self pickerDisplay:_channelTV];
    [_channelItems removeAllObjects];
    for (int i = 0; i < [list count]; i++) {
        
        
        NSDictionary *channelDict = [list objectAtIndex:i];
        ChannelListModel *model = [[ChannelListModel alloc]init];
        
        if ([channelDict objectForKey:@"id"]) {
             model.channelID = [NSString stringWithFormat:@"%@",[channelDict objectForKey:@"id"]];
        }
        if ([channelDict objectForKey:@"paychannel"]) {
             model.channelName = [NSString stringWithFormat:@"%@",[channelDict objectForKey:@"paychannel"]];
        }

        [_channelItems addObject:model];
        NSLog(@"_channelItem:%@",_channelItems);
        /*
         if (i==0) {
         _channelsId=[model.channelID intValue];
         _masterChannel=model.channelName;
         }
         */
    }
    
    [_pickerView reloadAllComponents];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalList.count;
}


- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //内容Cell
    static NSString *identifier = @"Terminal";
    TerminalSelectModel *model = [_terminalList objectAtIndex:indexPath.row];
    TerminalSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TerminalSelectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setTerminalSelectModel:model andTarget:self];
//    cell.priceLB.text=[NSString stringWithFormat:@"￥%@",model.retail_price];

    return cell;
}






-(void)modifyStatus:(id)sender
{
    [_terminalFilter removeAllObjects];

    if (pickerstatus==100) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        if(_POSArray.count>0)
        {
        
        
            POSModel *model =[_POSArray objectAtIndex:index]  ;
            
            
            _POSTV.text=model.title;
            _goodid=[model.ID integerValue];

        if(model.title)
        {
//            [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
//            //上拉
//            [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];
            [self firstLoadData];
            
        
        
        }
        }
        

    }
    else
    {
        
        NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
        NSInteger secondIndex = [_pickerView selectedRowInComponent:1];
        ChannelListModel *channel = nil;
        BillingModel *model = nil;
        if (firstIndex < [_channelItems count]) {
            channel = [_channelItems objectAtIndex:firstIndex];
            _channelsId=[channel.channelID intValue];
        }
        if (secondIndex < [_pickerArray count]) {
            model = [_pickerArray objectAtIndex:secondIndex];
        }
        if (model==nil)
        {
            if([self isBlankString:channel.channelName])
            {
                _channelTV.text=@"";

            }else
            {
                _channelTV.text=[NSString stringWithFormat:@"%@",channel.channelName];
//                [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
//                //上拉
//                [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];
                    [self firstLoadData];
                    
                    
                    

            
            }
            
        }
        else
        {
            if([self isBlankString:channel.channelName])
        
            {
            
            _channelTV.text=@"";

       
            }
            else
            {
                _channelTV.text= [NSString stringWithFormat:@"%@ %@",channel.channelName,model.billName];

                _channelTV.text=[NSString stringWithFormat:@"%@",channel.channelName];
//                [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
//                //上拉
//                [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];
                [self firstLoadData];

            }
        }
        
    }
    [self pickerHide];
    
}

#pragma mark - UIPickerView


- (void)pickerDisplay:(id)sender{
    
    NSLog(@"pickerDiplay");
    
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyStatus:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(0, 0, 0, 42) inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
    
}


- (void)pickerHide
{
    
    [_popViewController dismissPopoverAnimated:NO];
    
}




#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerstatus==100) {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (pickerstatus==100) {
        
        return _POSArray.count;
        
    }
    
    else
    {
        if (component == 0) {
            return [_channelItems count];;
        }
        else {
            NSInteger channelIndex = [pickerView selectedRowInComponent:0];
            if ([_channelItems count] > 0) {
                ChannelListModel *channel = [_channelItems objectAtIndex:channelIndex];
                _pickerArray = channel.children;
                return [_pickerArray count];
            }
            return 0;
            
        }
        
    }
    
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerstatus==100) {
        POSModel *model =[_POSArray objectAtIndex:row]  ;

        return model.title;
        
    }
    else
    {
        if (component == 0) {
            //通道
            ChannelListModel *model = [_channelItems objectAtIndex:row];
            return model.channelName;
        }
        else {
            //结算时间
            if ([_pickerArray count] > 0) {
                BillingModel *model = [_pickerArray objectAtIndex:row];
                return model.billName;
            }
            return @"";
            
        }
        
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerstatus==200) {
        if (component == 0) {
            //
            [_pickerView reloadComponent:1];
        }
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
