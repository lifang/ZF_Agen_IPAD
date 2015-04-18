//
//  DealRoadController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DealRoadController.h"
#import "TransferCell.h"
#import "TopDealRoadCell.h"
#import "ConsumptionCell.h"
#import "RepaymentCell.h"
#import "LiferechargeCell.h"
#import "TelephonechargeCell.h"
//#import "DealRoadChildController.h"
#import "TerminalChoseCell.h"
#import "AppDelegate.h"
#import "TerminalModel.h"
#import "RefreshView.h"
#import "TradeModel.h"
//#import "DealRoadDetailController.h"
#import "LoginViewController.h"
#import "AccountTool.h"
#import "NetworkInterface.h"
#import "TradeAgentModel.h"
#import "DealRoadDetailController.h"
#import "MJRefresh.h"
#import "DealRoadChildController.h"

#import "UIImage+Extention.h"
typedef enum {
    TimeStart = 0,
    TimeEnd,
}TimeType;

static NSString *s_defaultTerminalNum = @"请选择终端号";

@interface DealRoadController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RefreshDelegate,LoginSuccessDelegate>

/** 顶部五个Button */
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property(nonatomic,strong)UIButton *huankuanBtn;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *shenghuochongzhiBtn;
@property(nonatomic,strong)UIButton *huafeichongzhiBtn;
/** 中间的View */
@property(nonatomic,strong)UIView *contentView;
//按钮状态
@property(nonatomic,assign)BOOL isChecked;
/** 按钮的位置 */
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat huankuanX;
@property(nonatomic,assign)CGFloat shenghuochongzhiX;
@property(nonatomic,assign)CGFloat huafeichongzhiX;
@property(nonatomic,assign)CGFloat privateY;
//终端号输入框
@property(nonatomic,strong)UITextField *terminalField;
//开始日期输入框
@property(nonatomic,strong)UITextField *dateField1;
//结束日期输入框
@property(nonatomic,strong)UITextField *dateField2;
//顶部Button的选择Index值
@property(nonatomic,assign)int buttonIndex;
//弹出选择终端号的TableView
@property(nonatomic,strong)UITableView *terminalTableView;
//弹出选择代理商的TableView
@property(nonatomic,strong)UITableView *agentTableView;
//保存获取的终端号
@property (nonatomic, strong) NSMutableArray *terminalItems;
//交易流水
@property (nonatomic, strong) NSMutableArray *tradeRecords;
/** 选择日期空间 */
@property (nonatomic, strong) UIDatePicker *datePickerStart;
@property (nonatomic, strong) UIDatePicker *datePickerEnd;
/** 开始与结束日期 */
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
//确认按钮
@property(nonatomic,strong)UIButton *startSure;
@property(nonatomic,strong)UIButton *endSure;
/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/
@property (nonatomic, assign) TimeType timeType;
//交易状态
@property(nonatomic,strong)NSString *DealState;
//是否push过
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,strong)UIButton *selectedStart;
@property(nonatomic,strong)UIButton *selectedEnd;


@end

@implementation DealRoadController
-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    
    [self LoginSuccess];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
}

-(void)LoginSuccess
{
    if (!_isPush) {
        //创建头部View
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self ShowLoginVC];
}
//选择代理商tableView懒加载
-(UITableView *)agentTableView
{
    if (!_agentTableView) {
        _agentTableView = [[UITableView alloc]init];
        _agentTableView.tag = 1119;
        _agentTableView.backgroundColor = kColor(214, 214, 214, 1.0);
        _agentTableView.delegate = self;
        _agentTableView.dataSource = self;
    }
    return _agentTableView;
}
//选择终端tableView懒加载
-(UITableView *)terminalTableView
{
    if (!_terminalTableView) {
        _terminalTableView = [[UITableView alloc]init];
        _terminalTableView.tag = 1111;
        _terminalTableView.backgroundColor = kColor(214, 214, 214, 1.0);
        _terminalTableView.delegate = self;
        _terminalTableView.dataSource = self;
    }
    return _terminalTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    agentItem = [[NSMutableArray alloc] init];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化数据
    self.buttonIndex = 1;
    //创建导航栏
    [self setupNavBar];
    self.isPush = NO;
    _terminalItems = [NSMutableArray array];
    _tradeRecords = [NSMutableArray array];
    [self setupHeaderView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TradeType)tradeTypeFromIndex:(NSInteger)index
{
    TradeType type = TradeTypeNone;
    switch (index) {
        case 1:
            type = TradeTypeTransfer;
            break;
        case 2:
            type = TradeTypeConsume;
            break;
        case 3:
            type = TradeTypeRepayment;
            break;
        case 4:
            type = TradeTypeLife;
            break;
        case 5:
            type = TradeTypeTelephoneFare;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark 导航栏
-(void)setupNavBar
{
    self.title = @"交易流水";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"blue"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kColor(210, 210, 210, 1.0);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    if (iOS7) {
        footerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    }
    self.tableView.tableFooterView = footerView;
}

#pragma mark 创建顶部5个BTN View
-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    self.tableView=[[UITableView alloc]init];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [  self.tableView setTableFooterView:view];
    
    
    
    
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

    
    
    
    
    if (iOS7) {
        self.tableView.frame=CGRectMake(0, 260, SCREEN_HEIGHT, SCREEN_WIDTH-260);
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 260);
    }
    else
    {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);

        self.tableView.frame=CGRectMake(0, 260, SCREEN_WIDTH, SCREEN_HEIGHT-260);

    }
    [self.view addSubview:headerView];

    [self.view addSubview:self.tableView];

    //创建头部按钮
    UIButton *publicBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.publickBtn = publicBtn;
    publicBtn.tag = 10001;
    [publicBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.backgroundColor = [UIColor clearColor];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setTitle:@"转账" forState:UIControlStateNormal];
    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.22 , 40, 120, 40);
    self.publicX = publicBtn.frame.origin.x;
    self.privateY = publicBtn.frame.origin.y;
    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    privateBtn.tag = 10002;
    [privateBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"消费" forState:UIControlStateNormal];
    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 40, 100, 36);
    self.privateX = privateBtn.frame.origin.x;
    [headerView addSubview:privateBtn];
    
    UIButton *huankuan = [[UIButton alloc]init];
    self.huankuanBtn = huankuan;
    huankuan.tag = 10003;
    [huankuan addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    huankuan.backgroundColor = [UIColor clearColor];
    huankuan.titleLabel.font = [UIFont systemFontOfSize:20];
    [huankuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [huankuan setTitle:@"还款" forState:UIControlStateNormal];
    huankuan.frame = CGRectMake(CGRectGetMaxX(privateBtn.frame), 40, 100, 36);
    self.huankuanX = huankuan.frame.origin.x;
    [headerView addSubview:huankuan];
    
    UIButton *shenghuochongzhi = [[UIButton alloc]init];
    self.shenghuochongzhiBtn = shenghuochongzhi;
    shenghuochongzhi.tag = 10004;
    [shenghuochongzhi addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    shenghuochongzhi.backgroundColor = [UIColor clearColor];
    shenghuochongzhi.titleLabel.font = [UIFont systemFontOfSize:20];
    [shenghuochongzhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shenghuochongzhi setTitle:@"生活充值" forState:UIControlStateNormal];
    shenghuochongzhi.frame = CGRectMake(CGRectGetMaxX(huankuan.frame), 40, 120, 36);
    self.shenghuochongzhiX = shenghuochongzhi.frame.origin.x;
    [headerView addSubview:shenghuochongzhi];
    
    UIButton *huafeichongzhi = [[UIButton alloc]init];
    self.huafeichongzhiBtn = huafeichongzhi;
    huafeichongzhi.tag = 10005;
    [huafeichongzhi addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    huafeichongzhi.backgroundColor = [UIColor clearColor];
    huafeichongzhi.titleLabel.font = [UIFont systemFontOfSize:20];
    [huafeichongzhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [huafeichongzhi setTitle:@"话费充值" forState:UIControlStateNormal];
    huafeichongzhi.frame = CGRectMake(CGRectGetMaxX(shenghuochongzhi.frame), 40, 120, 36);
    self.huafeichongzhiX = huafeichongzhi.frame.origin.x;
    [headerView addSubview:huafeichongzhi];
    
    UIView *contentView = [[UIView alloc]init];
    self.contentView = contentView;
    [self setupContetView];
    contentView.backgroundColor = [UIColor whiteColor];
    if (iOS7) {
        contentView.frame = CGRectMake(0, CGRectGetMaxY(publicBtn.frame), SCREEN_HEIGHT, 260 - CGRectGetMaxY(publicBtn.frame));
    }else
    {
        contentView.frame = CGRectMake(0, CGRectGetMaxY(publicBtn.frame), SCREEN_WIDTH, 260 - CGRectGetMaxY(publicBtn.frame));

    
    }
    [headerView addSubview:contentView];
    
    
  
    
}

#pragma mark 创建中间的选择器View
-(void)setupContetView
{
    UILabel *terminalLabel = [[UILabel alloc]init];
    terminalLabel.font = [UIFont systemFontOfSize:20];
    terminalLabel.text = @"终端号";
    terminalLabel.frame = CGRectMake(40, 40, 70, 40);
    [_contentView addSubview:terminalLabel];
    
    _terminalField = [[UITextField alloc]init];
    _terminalField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _terminalField.leftView = v;
    _terminalField.userInteractionEnabled = NO;
    _terminalField.borderStyle = UITextBorderStyleLine;
    _terminalField.delegate = self;
    _terminalField.placeholder = @"请选择终端号";
    [_terminalField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _terminalField.frame = CGRectMake(CGRectGetMaxX(terminalLabel.frame), terminalLabel.frame.origin.y, 260, 40);
    UIButton *rightTerminalBtn = [[UIButton alloc]init];
    rightTerminalBtn.tag = 1050;
    [rightTerminalBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn.frame = CGRectMake(CGRectGetMaxX(_terminalField.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    [_contentView addSubview:_terminalField];
    [_contentView addSubview:rightTerminalBtn];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = @"交易日期";
    dateLabel.font = [UIFont systemFontOfSize:20];
    dateLabel.frame = CGRectMake(CGRectGetMaxX(rightTerminalBtn.frame) + 20, terminalLabel.frame.origin.y, 100, 40);
    [_contentView addSubview:dateLabel];
    
    _dateField1 = [[UITextField alloc]init];
    _dateField1.userInteractionEnabled = NO;
    _dateField1.borderStyle = UITextBorderStyleLine;
    _dateField1.delegate = self;
    UIView *t = [[UIView alloc]init];
    t.frame = CGRectMake(0, 0, 10, 40);
    _dateField1.leftViewMode = UITextFieldViewModeAlways;
    _dateField1.leftView = t;
    _dateField1.placeholder = @"开始日期";
    [_dateField1 setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _dateField1.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame), terminalLabel.frame.origin.y, 180, 40);
    UIButton *rightTerminalBtn1 = [[UIButton alloc]init];
    rightTerminalBtn1.tag = 1051;
    [rightTerminalBtn1 addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn1 setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn1.frame = CGRectMake(CGRectGetMaxX(_dateField1.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    self.selectedStart = rightTerminalBtn1;
    [_contentView addSubview:_dateField1];
    [_contentView addSubview:rightTerminalBtn1];
    
    UIView *gang = [[UIView alloc]init];
    gang.backgroundColor = [UIColor blackColor];
    gang.frame = CGRectMake(CGRectGetMaxX(_dateField1.frame) + 10, terminalLabel.frame.origin.y + 20, 7, 2);
    [_contentView addSubview:gang];
    
    _dateField2 = [[UITextField alloc]init];
    _dateField2.borderStyle = UITextBorderStyleLine;
    _dateField2.userInteractionEnabled = NO;
    _dateField2.delegate = self;
    UIView *f = [[UIView alloc]init];
    f.frame = CGRectMake(0, 0, 10, 40);
    _dateField2.leftViewMode = UITextFieldViewModeAlways;
    _dateField2.leftView = f;
    _dateField2.placeholder = @"结束日期";
    [_dateField2 setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _dateField2.frame = CGRectMake(CGRectGetMaxX(gang.frame) + 10, terminalLabel.frame.origin.y, 180, 40);
    UIButton *rightTerminalBtn2 = [[UIButton alloc]init];
    rightTerminalBtn2.tag = 1052;
    [rightTerminalBtn2 addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn2 setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn2.frame = CGRectMake(CGRectGetMaxX(_dateField2.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    self.selectedEnd = rightTerminalBtn2;
    [_contentView addSubview:_dateField2];
    [_contentView addSubview:rightTerminalBtn2];
    
    
    
    
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_terminalField.frame) + 30,70, 40)];
    [_contentView addSubview:newaddress];
    newaddress.font=[UIFont systemFontOfSize:18];
    
    newaddress.text=@"代理商";
    
    
    blankbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    blankbutton.frame = CGRectMake(_terminalField.frame.origin.x,CGRectGetMaxY(_terminalField.frame) + 30 ,260, 40);
//    [blankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
    
    [blankbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    blankbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [blankbutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[blankbutton  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    blankbutton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    blankbutton.imageEdgeInsets = UIEdgeInsetsMake(0,200,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    blankbutton.tag=509;
    
    [blankbutton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:blankbutton];

    
 
    
    
    UIButton *startFindBtn = [[UIButton alloc]init];
    [startFindBtn addTarget:self action:@selector(startFind) forControlEvents:UIControlEventTouchUpInside];
    [startFindBtn setTitle:@"开始查询" forState:UIControlStateNormal];
    
    [startFindBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    
    [startFindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startFindBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    startFindBtn.frame = CGRectMake(440, CGRectGetMaxY(_terminalField.frame) + 30, 100, 40);
    [_contentView addSubview:startFindBtn];
    
    UIButton *startStatisticsBtn = [[UIButton alloc]init];
    [startStatisticsBtn addTarget:self action:@selector(startStatistics) forControlEvents:UIControlEventTouchUpInside];
    [startStatisticsBtn setTitle:@"开始统计" forState:UIControlStateNormal];
    [startStatisticsBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [startStatisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startStatisticsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    startStatisticsBtn.frame = CGRectMake(CGRectGetMaxX(startFindBtn.frame) + 60, CGRectGetMaxY(_terminalField.frame) + 30, 100, 40);
    [_contentView addSubview:startStatisticsBtn];
    
    
    
    UIView*lineView = [[UIView alloc]init];
    if(iOS7)
    {
        lineView.frame=CGRectMake(0, 179, SCREEN_HEIGHT, 1);

    
    }else
    {
    
    
        lineView.frame=CGRectMake(0, 179, SCREEN_WIDTH, 1);

    
    }
    
    
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [_contentView addSubview:lineView];

    [self setRefreshView];
    
}

#pragma mark 添加上下拉View

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

#pragma mark 开始查询 开始统计
-(void)startFind
{
    if ([_terminalField.text isEqualToString:s_defaultTerminalNum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择终端号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_startTime || [_startTime isEqualToString:@"开始时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@"结束时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [self dateFromString:_startTime];
    NSDate *end = [self dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    changeA=502;
    
    [self firstLoadData];
}

-(void)startStatistics
{
    
    
    
    if (!_startTime || [_startTime isEqualToString:@"开始时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择开始时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_endTime || [_endTime isEqualToString:@"结束时间"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDate *start = [self dateFromString:_startTime];
    NSDate *end = [self dateFromString:_endTime];
    if (!([start earlierDate:end] == start)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"开始时间不能晚于结束时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    //    NSLog(@"点击了开始统计！为上排第%d个按钮",_buttonIndex);
        DealRoadDetailController *detailVC = [[DealRoadDetailController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.nextid = agentid;

    
        detailVC.startTime = _startTime;
        detailVC.endTime = _endTime;
        detailVC.terminalNumber = _terminalField.text;
        detailVC.tradeType = [self tradeTypeFromIndex:_buttonIndex];
        [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)rightBtnClicked:(UIButton *)button
{
    if (button.tag == 1050) {
        changeD=!changeD;
        
        
        NSLog(@"点击了终端号！");
        [self setupTerminalTableView];
    }
    if (button.tag == 1051) {
        NSLog(@"点击了交易日期1");
        _selectedStart.userInteractionEnabled = NO;
        [self setupStartDate];
    }
    if (button.tag == 1052) {
        NSLog(@"点击了交易日期2");
        _selectedEnd.userInteractionEnabled = NO;
        [self setupEndDate];
    }
    if (button.tag == 509)
    {
        changeagent=!changeagent;

        [self  downloadAgentList];

    }





}

//创建开始日期选择器
-(void)setupStartDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(_dateField1.frame.origin.x - 30, CGRectGetMaxY(_dateField1.frame) + 80, _dateField1.frame.size.width + 60, 160);
    [_datePickerStart addTarget:self action:@selector(startPick) forControlEvents:UIControlEventValueChanged];
    datepickview=[[UIView alloc]initWithFrame:CGRectMake(datePicker.frame.origin.x  , CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width, 30)];
    [self.view addSubview:datepickview];
    datepickview.backgroundColor=kColor(212, 212, 212, 1.0);
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.tag = 1112;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    self.startSure = makeSureBtn;
    self.datePickerStart = datePicker;
    [self.view addSubview:_startSure];
    
    
    
    cancelBtn = [[UIButton alloc]init];
    cancelBtn.tag = 1212;
    [cancelBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelBtn.frame = CGRectMake(datePicker.frame.origin.x, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    
    [self.view addSubview:cancelBtn];
    
    
    [self.view addSubview:_datePickerStart];
}

-(void)startPick
{
    self.startTime = [self stringFromDate:_datePickerStart.date];
}

//创建结束日期选择器
-(void)setupEndDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(_dateField2.frame.origin.x - 30, CGRectGetMaxY(_dateField2.frame) + 80, _dateField2.frame.size.width + 60, 160);
    [_datePickerEnd addTarget:self action:@selector(endPick) forControlEvents:UIControlEventValueChanged];
    
    datepickviewend=[[UIView alloc]initWithFrame:CGRectMake(datePicker.frame.origin.x  , CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width, 30)];
    [self.view addSubview:datepickviewend];
    datepickviewend.backgroundColor=kColor(212, 212, 212, 1.0);
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.tag = 1113;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    self.endSure = makeSureBtn;
    self.datePickerEnd = datePicker;
    [self.view addSubview:_endSure];
    [self.view addSubview:_datePickerEnd];
    
    
    
    
    cancelBtnend = [[UIButton alloc]init];
    cancelBtnend.tag = 1312;
    [cancelBtnend addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtnend setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [cancelBtnend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtnend setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtnend.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelBtnend.frame = CGRectMake(datePicker.frame.origin.x, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    
    [self.view addSubview:cancelBtnend];

}

-(void)endPick
{
    self.endTime = [self stringFromDate:_datePickerEnd.date];
}


-(void)makeSureClick:(UIButton *)button
{
    if (button.tag == 1112) {
        _selectedStart.userInteractionEnabled = YES;
        [_datePickerStart removeFromSuperview];
        [_startSure removeFromSuperview];
        [cancelBtn removeFromSuperview];
        [datepickview removeFromSuperview];

        [self startPick];
        _dateField1.text = self.startTime;
    }
    if (button.tag == 1212) {
        _selectedStart.userInteractionEnabled = YES;
        [_datePickerStart removeFromSuperview];
        [_startSure removeFromSuperview];
        [cancelBtn removeFromSuperview];
        [datepickview removeFromSuperview];
        
    }
    if (button.tag == 1312) {
        _selectedEnd.userInteractionEnabled = YES;
        [_datePickerEnd removeFromSuperview];
        [_endSure removeFromSuperview];

        [cancelBtnend removeFromSuperview];
        [datepickviewend removeFromSuperview];
        
    }
    if (button.tag == 1113) {
        _selectedEnd.userInteractionEnabled = YES;
        [_datePickerEnd removeFromSuperview];
        [_endSure removeFromSuperview];
        [cancelBtnend removeFromSuperview];
        [datepickviewend removeFromSuperview];

        [self endPick];
        _dateField2.text = self.endTime;
    }
}

//创建选择终端tableView
-(void)setupTerminalTableView
{
    //获取所有的终端号数据
    [self getAllTerminalList];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 顶部BTN的点击切换
-(void)btnClicked:(UIButton *)button
{
    //转账
    if (button.tag == 10001) {
        if (_isChecked == YES) {
            //什么都不做
            [self tradeTypeFromIndex:1];
        }
        else{
            _buttonIndex = 1;
            [self tradeTypeFromIndex:1];
            [_tradeRecords removeAllObjects];
            [self.tableView reloadData];
            [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
            _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
            _publickBtn.frame = CGRectMake(_publicX, _privateY, 120, 40);
            
            [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
            
            [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
            
            [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
            
            [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
            
            _isChecked = YES;
        }
    }
    //消费
    if (button.tag == 10002) {
        _buttonIndex = 2;
        [self tradeTypeFromIndex:2];
        _isChecked = NO;
        [_tradeRecords removeAllObjects];
        [self.tableView reloadData];
        [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _privateBtn.frame = CGRectMake(_privateX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //还款
    if (button.tag == 10003) {
        [self tradeTypeFromIndex:3];
        _buttonIndex = 3;
        _isChecked = NO;
        [_tradeRecords removeAllObjects];
        [self.tableView reloadData];
        [_huankuanBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _huankuanBtn.frame = CGRectMake(_huankuanX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 20, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //生活充值
    if (button.tag == 10004) {
        _buttonIndex = 4;
        [self tradeTypeFromIndex:4];
        _isChecked = NO;
        [_tradeRecords removeAllObjects];
        [self.tableView reloadData];
        [_shenghuochongzhiBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //话费充值
    if (button.tag == 10005) {
        [self tradeTypeFromIndex:5];
        _buttonIndex = 5;
        _isChecked = NO;
        [_tradeRecords removeAllObjects];
        [self.tableView reloadData];
        [_huafeichongzhiBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ( tableView== _agentTableView)
    {
        return 1;
    }
else if (tableView== _terminalTableView)

      {
        return 1;
    }
    else
    {
    
        return 2;

    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    
    if ( tableView== _agentTableView)
    {
        
        
        if(agentItem.count>8)
        {
            return 8;

        
        }else
            
        {
            return agentItem.count;

        
        }
    }
    else if (tableView== _terminalTableView)
        
    {
        
        
        if(agentItem.count>8)
        {
            return 8;
            
            
        }else
            
        {
            return _terminalItems.count;
            
            
        }

    }
    else
    {
        
        if (section == 0) {
            return 1;
        }
        else{
            return _tradeRecords.count;
        }
        
        
    }

    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //终端选择Cell
    if (tableView ==_terminalTableView)
    
    
    {
        TerminalChoseCell *cell = [TerminalChoseCell cellWithTableView:tableView];
        TerminalModel *model = [_terminalItems objectAtIndex:indexPath.row];
        cell.textLabel.text = model.terminalNum;
        return cell;
    }
    else if(tableView==_agentTableView)

    {
        TerminalChoseCell *cell = [TerminalChoseCell cellWithTableView:tableView];

        if(agentItem.count>0)
        {

            TradeAgentModel *model = [agentItem objectAtIndex:indexPath.row];
            cell.textLabel.text = model.agentName;
        
        }
        
        return cell;

    
    }
    
    else
        //顶部标题Cell
    {
        if (indexPath.section == 0) {
            NSString *ID = [NSString stringWithFormat:@"cell%d",_buttonIndex];
            TopDealRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell = [[TopDealRoadCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            return cell;
        }
        else
            //内容Cell
        {
            if (_buttonIndex == 1) {
                TransferCell *cell = [TransferCell cellWithTableView:tableView];
                TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
                cell.timeLabel.text = model.tradeTime;
                cell.payLabel.text = model.payFromAccount;
                cell.getLabel.text = model.payIntoAccount;
                cell.terminalLabel.text = model.terminalNumber;
                cell.dealMoney.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
                [self StringWithdealStates:model.tradeStatus];
                cell.dealStates.text = _DealState;
                return cell;
            }
            
            if (_buttonIndex == 3) {
                RepaymentCell *cell = [RepaymentCell cellWithTableView:tableView];
                TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
                cell.timeLabel.text = model.tradeTime;
                cell.payLabel.text = model.payFromAccount;
                cell.payToLabel.text = model.payIntoAccount;
                cell.terminalLabel.text = model.terminalNumber;
                cell.dealMoney.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
                [self StringWithdealStates:model.tradeStatus];
                cell.dealStates.text = _DealState;
                return cell;
            }
            if (_buttonIndex == 4) {
                LiferechargeCell *cell = [LiferechargeCell cellWithTableView:tableView];
                TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
                cell.timeLabel.text = model.tradeTime;
                cell.usernameLabel.text = model.accountName;
                cell.useraccountLabel.text = model.accountNumber;
                cell.terminalLabel.text = model.terminalNumber;
                cell.dealMoney.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
                [self StringWithdealStates:model.tradeStatus];
                cell.dealStates.text = _DealState;
                return cell;
            }
            if (_buttonIndex == 5) {
                TelephonechargeCell *cell = [TelephonechargeCell cellWithTableView:tableView];
                TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
                cell.timeLabel.text = model.tradeTime;
                cell.phoneNumLabel.text = model.phoneNumber;
                cell.terminalLabel.text = model.terminalNumber;
                cell.dealMoney.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
                [self StringWithdealStates:model.tradeStatus];
                cell.dealStates.text = _DealState;
                return cell;
            }
            
            else {
                ConsumptionCell *cell = [ConsumptionCell cellWithTableView:tableView];
                TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
                cell.timeLabel.text = model.tradeTime;
                cell.settleLabel.text = model.payedTime;
                cell.poundageLabel.text = [NSString stringWithFormat:@"￥%.2f",model.poundage];
                cell.terminalLabel.text = model.terminalNumber;
                cell.dealMoney.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
                [self StringWithdealStates:model.tradeStatus];
                cell.dealStates.text = _DealState;
                return cell;
            }
            
        }
    }
   
}

- (void)StringWithdealStates:(NSString *)dealStates
{
    if ([dealStates isEqualToString:@"1"]) {
        self.DealState = @"待付款";
    }
    if ([dealStates isEqualToString:@"2"]) {
        self.DealState = @"成功";
    }
    if ([dealStates isEqualToString:@"3"]) {
        self.DealState = @"失败";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1111) {
        return 40;
    }
    
    if(tableView==_agentTableView)
    {
    
        return 40;

    
    
    }
    else{
        if (indexPath.section == 0) {
            return 80;
        }else{
            return 70;
        }
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isPush = YES;
    //终端选择跳转
    if (tableView.tag == 1111) {
        TerminalModel *model = [_terminalItems objectAtIndex:indexPath.row];
        _terminalField.text = model.terminalNum;
        changeD=!changeD;
        if(changeD)
        {
            _terminalTableView.hidden=NO;
            
        }else
        {
            _terminalTableView.hidden=YES;
            
            
        }
        
        
    }
  else  if (tableView == _agentTableView)
    
    {
        TradeAgentModel *model = [agentItem objectAtIndex:indexPath.row];
        
        [blankbutton setTitle: model.agentName forState:UIControlStateNormal];
        agentid=model.agentID;
        changeagent=!changeagent;
if(changeagent)
{
    _agentTableView.hidden=NO;
    
}else
{
    _agentTableView.hidden=YES;


}
        
    }
    else{
          if (indexPath.section == 0) {
        
          }else
          {
          
              //内容点击跳转
              DealRoadChildController *dealVC = [[DealRoadChildController alloc]init];
              TradeModel *model = [_tradeRecords objectAtIndex:indexPath.row];
              TradeType tradeType = [self tradeTypeFromIndex:_buttonIndex];
              dealVC.tradeID = model.tradeID;
              dealVC.tradeType = tradeType;
              dealVC.hidesBottomBarWhenPushed = YES;
              [self.navigationController pushViewController:dealVC animated:YES];
          
          }
        
    }
}


#pragma mark - Request
- (void)downloadAgentList {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getTradeAgentListWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [self parseAgentListDataWithDictionary:object];
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

- (void)parseAgentListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [agentItem removeAllObjects];
    NSArray *agentList = [dict objectForKey:@"result"];
    for (int i = 0; i < [agentList count]; i++) {
        id agentDict = [agentList objectAtIndex:i];
        if ([agentDict isKindOfClass:[NSDictionary class]]) {
            TradeAgentModel *model = [[TradeAgentModel alloc] initWithParseDictionary:agentDict];
            [agentItem addObject:model];
        }
    }
    self.agentTableView.frame = CGRectMake(blankbutton.frame.origin.x, CGRectGetMaxY(blankbutton.frame) + 80, blankbutton.frame.size.width, 160);
    [self.view addSubview:_agentTableView];
   if(changeagent)
   {
       _agentTableView.hidden=NO;
       
   }else
   {
   
       _agentTableView.hidden=YES;

   
   }
        [_agentTableView reloadData];
 
}


//获取终端号
- (void)getAllTerminalList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@",delegate.agentID);
    
   [NetworkInterface getTradeTerminalListWithAgentID:delegate.agentID token:nil finished:^(BOOL success, NSData *response) {
    
    
            NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"~~~~~~~%@",str);
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
                        [self parseTerminalDataWithDictionary:object];
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

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    if(changeA==502)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"加载中...";
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        TradeType tradeType = [self tradeTypeFromIndex:_buttonIndex];
        
        
        [NetworkInterface getTradeRecordWithAgentID:delegate.agentID token:delegate.token tradeType:tradeType terminalNumber:_terminalField.text subAgentID:agentid startTime:_startTime endTime:_endTime page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
            
            
            
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
                            [_tradeRecords removeAllObjects];
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
                        [self parseTradeDataWithDictionary:object];
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
            //            if (!isMore) {
            //                [self refreshViewFinishedLoadingWithDirection:PullFromTop];
            //            }
            //            else {
            //                [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
            //            }
        }];

       
    }else
    {
    
        
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    
    
    }
   
   }



#pragma mark - Data

//解析终端信息
- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    [_terminalItems removeAllObjects];
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *terminalList = [dict objectForKey:@"result"];
    
    for (int i = 0; i < [terminalList count]; i++) {
        TerminalModel *terminal = [[TerminalModel alloc] initWithParseDictionary:[terminalList objectAtIndex:i]];
        [_terminalItems addObject:terminal];
    }
    
    self.terminalTableView.frame = CGRectMake(_terminalField.frame.origin.x, CGRectGetMaxY(_terminalField.frame) + 80, _terminalField.frame.size.width, 160);
    [self.view addSubview:_terminalTableView];
    if(changeD)
    {
        _terminalTableView.hidden=NO;
        
    }else
    {
        _terminalTableView.hidden=YES;

    }
    if (_terminalItems.count != 0) {
        [_terminalTableView reloadData];
    }
}

- (void)parseTradeDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        
        return;
    }
    NSArray *tradeList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [tradeList count]; i++) {
        TradeModel *trade = [[TradeModel alloc] initWithParseDictionary:[tradeList objectAtIndex:i]];
        [_tradeRecords addObject:trade];
    }
    
    [self.tableView reloadData];
}

//将日期转化成字符串yyyy-MM-dd格式
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    if ([dateString length] >= 10) {
        return [dateString substringToIndex:10];
    }
    return dateString;
}

//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}

#pragma mark - Refresh

//- (void)refreshViewReloadData {
//    _reloading = YES;
//}
//
//- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
//    _reloading = NO;
//    if (direction == PullFromTop) {
//        [_topRefreshView refreshViewDidFinishedLoading:self.tableView];
//    }
//    else if (direction == PullFromBottom) {
//        _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
//        [_bottomRefreshView refreshViewDidFinishedLoading:self.tableView];
//    }
//    [self updateFooterViewFrame];
//}
//
//- (BOOL)refreshViewIsLoading:(RefreshView *)view {
//    return _reloading;
//}
//
//- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
//    [self refreshViewReloadData];
//    //loading...
//    
//    
//        if (view == _topRefreshView) {
//            [self pullDownToLoadData];
//        }
//        else if (view == _bottomRefreshView) {
//            [self pullUpToLoadData];
//        }
//
//    
//    
//    }
//
//
//- (void)updateFooterViewFrame {
//    _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
//    _bottomRefreshView.hidden = NO;
//    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
//        _bottomRefreshView.hidden = YES;
//    }
//}
//
//#pragma mark - UIScrollView
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _primaryOffsetY = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView) {
//        CGPoint newPoint = scrollView.contentOffset;
//        if (_primaryOffsetY < newPoint.y) {
//            //上拉
//            if (_bottomRefreshView.hidden) {
//                return;
//            }
//            [_bottomRefreshView refreshViewDidScroll:scrollView];
//        }
//        else {
//            //下拉
//            [_topRefreshView refreshViewDidScroll:scrollView];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView == self.tableView) {
//        CGPoint newPoint = scrollView.contentOffset;
//        if (_primaryOffsetY < newPoint.y) {
//            //上拉
//            if (_bottomRefreshView.hidden) {
//                return;
//            }
//            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
//        }
//        else {
//            //下拉
//            [_topRefreshView refreshViewDidEndDragging:scrollView];
//        }
//    }
//}
//
//#pragma mark - 上下拉刷新
////下拉刷新
//- (void)pullDownToLoadData {
//    [self firstLoadData];
//}
//
////上拉加载
//- (void)pullUpToLoadData
//{
//    [self downloadDataWithPage:self.page isMore:YES];
//}
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
