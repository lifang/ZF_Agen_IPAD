//
//  AdjustGoodsViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AdjustGoodsViewController.h"
#import "AppDelegate.h"
#import "SubAgentCell.h"
#import "MineCommonController.h"
#import "MJRefresh.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "CreateViewController.h"
#import "GoodAgentModel.h"
#import "TerminalChoseCell.h"
#import "PrepareGoodCell.h"
#import "PrepareGoodModel.h"
@interface AdjustGoodsViewController ()<UITableViewDataSource,UITableViewDelegate>
//确认按钮
@property(nonatomic,strong)UIButton *startSure;
@property(nonatomic,strong)UIButton *endSure;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property (nonatomic, strong) NSMutableArray *agentList;
@property (nonatomic, strong) NSMutableArray *prepareList;

@property (nonatomic, strong) UITableView *tableView;
/** 选择日期空间 */
@property (nonatomic, strong) UIDatePicker *datePickerStart;
@property (nonatomic, strong) UIDatePicker *datePickerEnd;
//开始日期输入框
@property(nonatomic,strong)UITextField *dateField1;
//结束日期输入框
@property(nonatomic,strong)UITextField *dateField2;
@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, assign) int page;
//弹出选择代理商的TableView
@property(nonatomic,strong)UITableView *agentTableView;
@end
static NSString *s_defaultTerminalNum = @"请选择终端号";



@implementation AdjustGoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];
    
    // Do any additional setup after loading the view.
    self.title = @"管理下级代理商";
    _dataItem = [[NSMutableArray alloc] init];
    _agentList = [[NSMutableArray alloc] init];
    _prepareList = [[NSMutableArray alloc] init];
    
    [self setLeftViewWith:ChooseViewMyShop];
    
    
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
    
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 270,  SCREEN_HEIGHT-220, SCREEN_WIDTH-270) style:UITableViewStylePlain];
        
    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 270,  SCREEN_WIDTH-220, SCREEN_HEIGHT-270) style:UITableViewStylePlain];
        
        
        
        
    }
    
    
    _tableView.backgroundColor = [UIColor whiteColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)agentclick:(UIButton*)send
{
    changeB=send.tag;
    changeagent=!changeagent;
    
    [self  getSubAgent];
    
    
}
-(void)pickingclicks
{
    
    
    
    [self createui];
    
    
    
    
}
-(void)resetclick
{
    
    
    
    
    
}
#pragma mark - UI
-(void)createui
{
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        //  wide=SCREEN_HEIGHT;
        //  height=SCREEN_WIDTH;
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
    }
    else
    { // wide=SCREEN_WIDTH;
        //height=SCREEN_HEIGHT;
        wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    
    bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:bigsview];
    bigsview.image=[UIImage imageNamed:@"backimage"];
    bigsview.userInteractionEnabled=YES;
    
    
    witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, height/2, height/2+100)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2-80);
    witeview.alpha=1;
    
    [bigsview addSubview:witeview];
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(  10, 10, 30, 30);
    [okButton setImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:okButton];
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,height/2, 30)];
    [witeview addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentCenter;
    
    newaddress.text=@"调货";
    newaddress .font = [UIFont systemFontOfSize:20.f];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, height/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    
    [witeview addSubview:lineview];
    
    
    
    
    
    UILabel*defaultlable=[[UILabel alloc]initWithFrame:CGRectMake(60,60,180, 30)];
    [witeview addSubview:defaultlable];
    
    defaultlable.text=@" 选择从下级代理商";
    
    
    nextagentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextagentbutton.frame = CGRectMake(60,100 ,height/2-120, 40);
    //    [blankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
    nextagentbutton.tag=1054;
    
    [nextagentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextagentbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [nextagentbutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[nextagentbutton  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    nextagentbutton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    nextagentbutton.imageEdgeInsets = UIEdgeInsetsMake(0,height/2-180,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    [nextagentbutton addTarget:self action:@selector(agentclick:) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:nextagentbutton];
    
    
    
    
    
    
    UILabel*nextdefaultlable=[[UILabel alloc]initWithFrame:CGRectMake(60, 150,180, 30)];
    [witeview addSubview:nextdefaultlable];
    
    nextdefaultlable.text=@" 选择下级代理商";
    
    
    nextagentbuttons = [UIButton buttonWithType:UIButtonTypeCustom];
    nextagentbuttons.frame = CGRectMake(60,190 ,height/2-120, 40);
    //    [blankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
    nextagentbuttons.tag=1454;
    
    [nextagentbuttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextagentbuttons.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [nextagentbuttons setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *nextlayer=[nextagentbuttons  layer];
    //是否设置边框以及是否可见
    [nextlayer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [nextlayer setBorderWidth:1];
    //设置边框线的颜色
    [nextlayer setBorderColor:[[UIColor grayColor] CGColor]];
    nextagentbuttons.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    nextagentbuttons.imageEdgeInsets = UIEdgeInsetsMake(0,height/2-180,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    [nextagentbuttons addTarget:self action:@selector(agentclick:) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:nextagentbuttons];
    

    
    
    
    
    
    
    
    
    
    
    UILabel*BBlable=[[UILabel alloc]initWithFrame:CGRectMake(60, 240,100, 30)];
    [witeview addSubview:BBlable];
    
    BBlable.text=@"选择终端号";
    BBlable.font = [UIFont systemFontOfSize:20.f];
    
    UIButton*agentnumberbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    agentnumberbutton.frame = CGRectMake(60,280 ,height/2-120, 40);
    //    [blankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
    
    [agentnumberbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agentnumberbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [agentnumberbutton setImage:kImageName(@"terminal") forState:UIControlStateNormal];
    CALayer *agentlayer=[agentnumberbutton  layer];
    //是否设置边框以及是否可见
    [agentlayer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [agentlayer setBorderWidth:1];
    //设置边框线的颜色
    [agentlayer setBorderColor:[[UIColor grayColor] CGColor]];
    agentnumberbutton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    agentnumberbutton.imageEdgeInsets = UIEdgeInsetsMake(0,height/2-180,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    [agentnumberbutton addTarget:self action:@selector(agentclicksss) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:agentnumberbutton];
    
    
    UIButton*savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(  wide/4, height/2-80, 140, 40);
    savebutton.center=CGPointMake(height/4, height/2);
    //    savebutton.layer.cornerRadius=10;
    
    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    [savebutton setTitle:@"确认" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(okclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:savebutton];
}
-(void)cancelclick
{
    
    
    [bigsview removeFromSuperview];
    
    
    
    
}
- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}

- (void)initAndLayoutUI {
    
    
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
    
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(180, 30,100, 40)];
    [self.view addSubview:newaddress];
    newaddress.font=[UIFont systemFontOfSize:18];
    
    newaddress.text=@"选择代理商";
    
    
    blankbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    blankbutton.frame = CGRectMake(280,30 ,260, 40);
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
    blankbutton.tag=5044;
    
    [blankbutton addTarget:self action:@selector(agentclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blankbutton];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = @"配货 日期";
    dateLabel.font = [UIFont systemFontOfSize:20];
    dateLabel.frame = CGRectMake(180,90, 100, 40);
    [self.view addSubview:dateLabel];
    
    starbuttom = [UIButton buttonWithType:UIButtonTypeCustom];
    starbuttom.frame = CGRectMake(280,90 ,220, 40);
    [starbuttom setTitle:@"开始日期" forState:UIControlStateNormal];
    
    [starbuttom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    starbuttom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [starbuttom setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *starlayer=[starbuttom  layer];
    //是否设置边框以及是否可见
    [starlayer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [starlayer setBorderWidth:1];
    //设置边框线的颜色
    [starlayer setBorderColor:[[UIColor grayColor] CGColor]];
    starbuttom.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    starbuttom.imageEdgeInsets = UIEdgeInsetsMake(0,160,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    starbuttom.tag=509;
    
    [starbuttom addTarget:self action:@selector(stardateclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:starbuttom];
    
    
    UIView *gang = [[UIView alloc]init];
    gang.backgroundColor = [UIColor blackColor];
    gang.frame = CGRectMake(510,110, 7, 2);
    [self.view addSubview:gang];
    
    endbuttom = [UIButton buttonWithType:UIButtonTypeCustom];
    endbuttom.frame = CGRectMake(530,90 ,220, 40);
    //    [blankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
    [endbuttom setTitle:@"结束日期" forState:UIControlStateNormal];
    
    [endbuttom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    endbuttom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [endbuttom setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *endlayer=[endbuttom  layer];
    //是否设置边框以及是否可见
    [endlayer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [endlayer setBorderWidth:1];
    //设置边框线的颜色
    [endlayer setBorderColor:[[UIColor grayColor] CGColor]];
    endbuttom.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    endbuttom.imageEdgeInsets = UIEdgeInsetsMake(0,160,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    endbuttom.tag=509;
    
    [endbuttom addTarget:self action:@selector(enddateclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endbuttom];
    
    
    
    
    UIButton *startFindBtn = [[UIButton alloc]init];
    [startFindBtn addTarget:self action:@selector(startFind) forControlEvents:UIControlEventTouchUpInside];
    [startFindBtn setTitle:@"开始查询" forState:UIControlStateNormal];
    
    [startFindBtn setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    
    [startFindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startFindBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    startFindBtn.frame = CGRectMake(280, 150, 100, 40);
    [self.view  addSubview:startFindBtn];
    
    UIButton *pickbutton = [[UIButton alloc]init];
    [pickbutton addTarget:self action:@selector(pickingclicks) forControlEvents:UIControlEventTouchUpInside];
    [pickbutton setTitle:@"调货" forState:UIControlStateNormal];
    [pickbutton setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
    [pickbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pickbutton.titleLabel.font = [UIFont systemFontOfSize:18];
    pickbutton.frame = CGRectMake(wide-180-80-100, 150, 100, 40);
    [self.view addSubview:pickbutton];
    
    
    
    UIView*lineView = [[UIView alloc]init];
    if(iOS7)
    {
        lineView.frame=CGRectMake(180, 200, SCREEN_HEIGHT-180-80, 1);
        
        
    }else
    {
        
        
        lineView.frame=CGRectMake(180, 200, SCREEN_WIDTH-180-80, 1);
        
        
    }
    
    
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [self.view addSubview:lineView];
    
    
    UILabel *recordLabel = [[UILabel alloc]init];
    recordLabel.text = @"调货记录";
    recordLabel.font = [UIFont systemFontOfSize:20];
    recordLabel.frame = CGRectMake(180,210, 100, 30);
    [self.view addSubview:recordLabel];
    
    UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(180, 250, wide-260, 20)];
    rootview.backgroundColor = kColor(235, 233, 233, 1);
    [self.view addSubview: rootview];
    
    
    UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 20)];
    [rootview addSubview:goodslable];
    goodslable.textAlignment = NSTextAlignmentCenter;
    
    goodslable.text=@"调货对象";
    
    UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-60-120, 0, 100, 20)];
    [rootview addSubview:phonelable];
    phonelable.textAlignment = NSTextAlignmentCenter;
    
    phonelable.text=@"日期";
    UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-160-160-80, 0, 80, 20)];
    [rootview addSubview:numberlable];
    numberlable.textAlignment = NSTextAlignmentCenter;
    
    numberlable.text=@"数量";
    
    
    [self setHeaderAndFooterView];
}
-(void)startFind
{
    if ([blankbutton.titleLabel.text isEqualToString:s_defaultTerminalNum]) {
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
//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}
-(void)stardateclick
{
    starbuttom.userInteractionEnabled=NO;
    
    
    [self setupStartDate];
    
    
    
}
-(void)enddateclick
{
    endbuttom.userInteractionEnabled=NO;
    
    [self setupEndDate];
    
    
    
}
//创建开始日期选择器
-(void)setupStartDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(starbuttom.frame.origin.x - 30, CGRectGetMaxY(starbuttom.frame) , starbuttom.frame.size.width + 60, 160);
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
-(void)makeSureClick:(UIButton *)button
{
    if (button.tag == 1112) {
        [_datePickerStart removeFromSuperview];
        [_startSure removeFromSuperview];
        [cancelBtn removeFromSuperview];
        [datepickview removeFromSuperview];
        starbuttom.userInteractionEnabled=YES;
        
        [self startPick];
    }
    if (button.tag == 1212) {
        [_datePickerStart removeFromSuperview];
        [_startSure removeFromSuperview];
        [cancelBtn removeFromSuperview];
        [datepickview removeFromSuperview];
        starbuttom.userInteractionEnabled=YES;
        
    }
    if (button.tag == 1312) {
        [_datePickerEnd removeFromSuperview];
        [_endSure removeFromSuperview];
        endbuttom.userInteractionEnabled=YES;
        
        [cancelBtnend removeFromSuperview];
        [datepickviewend removeFromSuperview];
        
    }
    if (button.tag == 1113) {
        [_datePickerEnd removeFromSuperview];
        [_endSure removeFromSuperview];
        [cancelBtnend removeFromSuperview];
        [datepickviewend removeFromSuperview];
        endbuttom.userInteractionEnabled=YES;
        
        [self endPick];
        _dateField2.text = self.endTime;
    }
    
    
}


-(void)startPick
{
    self.startTime = [self stringFromDate:_datePickerStart.date];
    
    [starbuttom setTitle:self.startTime forState:UIControlStateNormal];
    
}
-(void)endPick
{
    self.endTime = [self stringFromDate:_datePickerEnd.date];
    [endbuttom setTitle:self.endTime forState:UIControlStateNormal];
    
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

//创建结束日期选择器
-(void)setupEndDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(endbuttom.frame.origin.x - 30, CGRectGetMaxY(endbuttom.frame), endbuttom.frame.size.width + 60, 160);
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



#pragma mark - Request

//下级代理商列表
- (void)getSubAgent {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getGoodSubAgentWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
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


- (void)firstLoadData {
    self.page = 1;
    [_prepareList removeAllObjects];
    
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    if(changeA==502)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"加载中...";
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        
        NSLog(@"%d",self.page);
        
        [NetworkInterface getPrepareGoodListWithAgentID:delegate.agentID token:delegate.token subAgentID:agentid startTime:_startTime endTime:_endTime page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        if ([list isKindOfClass:[NSArray class]]/* && [list count] > 0*/) {
                            //有数据
                            [hud hide:YES];
                        }
                        else {
                            //无数据
                            hud.labelText = @"没有更多数据了...";
                        }
                        [self parsePrepareGoodListDataWithDictionary:object];
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
    
    else
        
        
    {
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
        
        
    }
}

#pragma mark - Data
- (void)parsePrepareGoodListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [(NSArray *)list count]; i++)
        {
            id prepareDict = [list objectAtIndex:i];
            if ([prepareDict isKindOfClass:[NSDictionary class]])
            {
                PrepareGoodModel *model = [[PrepareGoodModel alloc] initWithParseDictionary:prepareDict];
                [_prepareList addObject:model];
            }
        }
        [_tableView reloadData];
        
    }
}

- (void)parseSubAgentListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_agentList removeAllObjects];
    NSArray *agentList = [dict objectForKey:@"result"];
    for (int i = 0; i < [agentList count] ; i++) {
        id agentDict = [agentList objectAtIndex:i];
        if ([agentDict isKindOfClass:[NSDictionary class]]) {
            GoodAgentModel *model = [[GoodAgentModel alloc] initWithParseDictionary:agentDict];
            [_agentList addObject:model];
        }
    }
    if(changeB==1054)
    {
        self.agentTableView.frame = CGRectMake(nextagentbutton.frame.origin.x, CGRectGetMaxY(nextagentbutton.frame), nextagentbutton.frame.size.width, 160);
        
        [witeview  addSubview:_agentTableView];
        if(changeagent)
        {
            _agentTableView.hidden=NO;
            
        }else
        {
            _agentTableView.hidden=YES;
            
            
        }
        
        
    }
    
  else  if(changeB==1454)
    {
        self.agentTableView.frame = CGRectMake(nextagentbuttons.frame.origin.x, CGRectGetMaxY(nextagentbuttons.frame), nextagentbuttons.frame.size.width, 160);
        
        [witeview  addSubview:_agentTableView];
        if(changeagent)
        {
            _agentTableView.hidden=NO;
            
        }else
        {
            _agentTableView.hidden=YES;
            
            
        }
        
        
    }
    
    else
    {
        
        self.agentTableView.frame = CGRectMake(blankbutton.frame.origin.x, CGRectGetMaxY(blankbutton.frame), blankbutton.frame.size.width, 160);
        [self.view addSubview:_agentTableView];
        if(changeagent)
        {
            _agentTableView.hidden=NO;
            
        }else
        {
            _agentTableView.hidden=YES;
            
            
        }
        
        
    }
    
    [_agentTableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView==_agentTableView)
    {
        return 1;
        
        
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    if ( tableView== _agentTableView)
    {
        
        
        if(_agentList.count>8)
        {
            return 8;
            
            
        }else
            
        {
            return _agentList.count;
            
            
        }
    }
    else
    {
        
        
        
        return  [_prepareList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
    
    if(tableView==_agentTableView)
        
    {
        TerminalChoseCell *cell = [TerminalChoseCell cellWithTableView:tableView];
        
        if(_agentList.count>0)
        {
            
            GoodAgentModel *model = [_agentList objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
            
        }
        
        return cell;
        
        
    }
    
    else
    {
        
        //下级代理商
        static NSString *cellIdentifier = @"PrepareGood";
        PrepareGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[PrepareGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        PrepareGoodModel *model = [_prepareList objectAtIndex:indexPath.row];
        [cell setContentWithData:model];
        
        
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
        UIView*lineView = [[UIView alloc]init];
        lineView.frame=CGRectMake(20, 59, wide-220-40, 1);
        
        
        lineView.backgroundColor = [UIColor grayColor];
        [cell addSubview:lineView];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _agentTableView)
        
    {
        GoodAgentModel *model = [_agentList objectAtIndex:indexPath.row];
        if(changeB==1054)
        {
            [nextagentbutton setTitle: model.name forState:UIControlStateNormal];
            
            nextagentid=model.ID;
            
        }
      else  if(changeB==1454)
        {
            [nextagentbuttons setTitle: model.name forState:UIControlStateNormal];
            
            nextagentids=model.ID;
            
        }
        
        
        else
        {
            [blankbutton setTitle: model.name forState:UIControlStateNormal];
            
            agentid=model.ID;
            
        }
        
        changeagent=!changeagent;
        if(changeagent)
        {
            _agentTableView.hidden=NO;
            
        }else
        {
            _agentTableView.hidden=YES;
            
            
        }
        
        
    }
    else
    {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==_agentTableView)
    {
        
        return 40;
        
        
        
    }
    else
    {
        
        
        return 60;
    }
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
            height = 0.001f;
            break;
        case 2:
            height = 0.001f;
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
    self.page++;
    
    [self downloadDataWithPage:self.page isMore:YES];
    
    
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_Seatchtable footerEndRefreshing];
    //
    //    });
}
@end