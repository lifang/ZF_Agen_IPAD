//
//  TerminalSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalSelectViewController.h"
#import "TerminalSelectCell.h"
#import "TerminalSelectModel.h"
#import "RefreshView.h"
#import "NetworkInterface.h"

@interface TerminalSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RefreshDelegate>
{
    BOOL isSelected;
    //CGFloat summaryPrice;
    NSInteger sumall;

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

@property (nonatomic, strong) NSMutableArray *terminalItems;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/********************************/

@property (nonatomic, strong) NSString *POStitle;
@property (nonatomic, assign) int channelsId;
@property (nonatomic, assign) int minPrice;
@property (nonatomic, assign) int maxPrice;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation TerminalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择终端";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _terminalList=[[NSMutableArray alloc] init];
    
    UILabel *POSLB=[[UILabel alloc ] init];
    POSLB.font = FONT20;
    POSLB.text=@"选择POS机";
    POSLB.textColor = [UIColor colorWithHexString:@"292929"];
    POSLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:POSLB];
    [POSLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(self.view.top).offset(90);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _POSTV = [[UITextView alloc] init];
    _POSTV.delegate = self;
    _POSTV.userInteractionEnabled = NO;
    _POSTV.clipsToBounds = YES;
    _POSTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _POSTV.layer.borderWidth = 1.0f;
    _POSTV.layer.cornerRadius = 3.0f;
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
        make.top.equalTo(self.view.top).offset(90);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _channelTV = [[UITextView alloc] init];
    _channelTV.delegate = self;
    _channelTV.userInteractionEnabled = NO;
    _channelTV.clipsToBounds = YES;
    _channelTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _channelTV.layer.borderWidth = 1.0f;
    _channelTV.layer.cornerRadius = 3.0f;
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
    _terminalTV.layer.cornerRadius = 3.0f;
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

    UILabel *priceLB=[[UILabel alloc ] init];
    priceLB.font = FONT20;
    priceLB.text=@"价格";
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
    _minPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _minPriceTV.layer.borderWidth = 1.0f;
    _minPriceTV.layer.cornerRadius = 3.0f;
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
    LB.text=@"-";
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
    _maxPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _maxPriceTV.layer.borderWidth = 1.0f;
    _maxPriceTV.layer.cornerRadius = 3.0f;
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
    
    
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    //headerView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(20);
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
        make.left.equalTo(headerView.left).offset(26);
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
        make.right.equalTo(headerView.right).offset(26);
        //make.width.equalTo(@120);
        
    }];


    _tableView= [[UITableView alloc] init];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-60);
    }];

    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -60,_tableView.frame.size.width, 60)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];

    
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
    
   
    UILabel *numberLB = [[UILabel alloc] init];
    numberLB.font = [UIFont boldSystemFontOfSize:16.f];
    //numberLB.text = [NSString stringWithFormat:@"已选中%d台",sumall];
    numberLB.text = [NSString stringWithFormat:@"已选中6台"];
    [FooterView addSubview:numberLB];
    [numberLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.centerX.equalTo(FooterView.centerX);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];

    
    }


-(void)POSBtnPressed:(id)sender
{

    
}

-(void)channelBtnPressed:(id)sender
{


}

-(void)confirmBtnPressed:(id)sender
{


}


-(void)selectedBtnPressed:(id)sender
{


}

-(void)finishBtnPressed:(id)sender
{
    

}

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    _POStitle=@"泰山Pos旗舰版1";
    _channelsId=1;
    _minPrice=100;
    _maxPrice=10000;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface screeningTerminalNumWithtoken:delegate.token title:_POStitle channelsId:_channelsId minPrice:_minPrice maxPrice:_maxPrice  finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"数据是%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    
                    if (!isMore) {
                        [_terminalList removeAllObjects];
                        
                    }
                    
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        _page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseMerchantDataWithDictionary:object];
                    NSLog(@"object:%@",object);
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

- (void)parseMerchantDataWithDictionary:(NSDictionary *)dict {
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _terminalList = [dict objectForKey:@"result"];
    // NSArray *MerchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    //_MerchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [_terminalList count]; i++) {
        TerminalSelectModel *model = [[TerminalSelectModel alloc] initWithParseDictionary:[_terminalList objectAtIndex:i]];
        [_terminalItems addObject:model];
    }
    NSLog(@"Items:%@",_terminalItems);
    [_tableView reloadData];
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalList.count;
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
    return cell;
}


#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
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
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}




#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
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
    if (scrollView == _tableView) {
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
   // [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
   // [self downloadDataWithPage:self.page isMore:YES];
    
    NSLog(@"上拉加载");
}

#pragma mark - NSNotification

- (void)refreshMerchantList:(NSNotification *)notification {
   // [self firstLoadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
