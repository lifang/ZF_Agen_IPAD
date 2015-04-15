//
//  TerminalViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalViewController.h"
#import "HexColor.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "TerminalViewCell.h"
#import "NetworkInterface.h"
#import "TerminalManagerModel.h"
#import "TerminalDetailViewController.h"
#import "ApplyDetailController.h"


@interface TerminalViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate,terminalCellSendBtnClicked,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/********************************/

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *terminalBtn;

//终端信息数据
@property (nonatomic, strong) NSMutableArray *terminalItems;

@property(nonatomic,strong)UIImageView *findPosView;

@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,strong) UIPopoverController *popViewController;

@property (nonatomic, strong) NSMutableArray *statusArray;

@property(strong,nonatomic) NSString *string;
@property (nonatomic, assign) int stringStatus;

@property (nonatomic, strong) UITextView *posTV;
@property (nonatomic, strong) UITextView *AddressTV;

@property(nonatomic,strong)UITableView *terminalTableView;

@property(nonatomic,strong) UIView *whiteView;

@end

@implementation TerminalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"终端管理";
    self.view.backgroundColor=[UIColor whiteColor];
    _terminalItems = [[NSMutableArray alloc]init];
    _statusArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"已开通", @"部分开通",@"未开通",@"已注销",@"已停用",nil];
    _stringStatus=0;
    [self setupHeaderView];
    [self initAndLayoutUI];
   
}


#pragma mark 创建HeaderView
-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 60);
    
    if (iOS7) {
        headerView.frame = CGRectMake(0, 60, SCREEN_HEIGHT, 60);
    }
    
    [self.view addSubview:headerView];
    
    UIButton *applyBtn = [[UIButton alloc] init];
    applyBtn.clipsToBounds = YES;
    applyBtn.layer.masksToBounds=YES;
    applyBtn.layer.borderWidth=1.0;
    applyBtn.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
    [applyBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    applyBtn.backgroundColor=[UIColor clearColor];
    [applyBtn setTitleColor:[UIColor colorWithHexString:@"006df5"] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyAfterSale:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:applyBtn];
    [applyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.width.equalTo(@120);
        make.left.equalTo(headerView.left).offset(80);
        make.height.equalTo(@40);
    }];
    
    
    
    UIButton *bindingBtn = [[UIButton alloc] init];
    bindingBtn.clipsToBounds = YES;
    bindingBtn.layer.masksToBounds=YES;
    bindingBtn.layer.borderWidth=1.0;
    bindingBtn.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
    [bindingBtn setTitle:@"为用户绑定终端" forState:UIControlStateNormal];
    bindingBtn.backgroundColor=[UIColor colorWithHexString:@"006df5"];
    [bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingTerminal:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bindingBtn];
    [bindingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.width.equalTo(@174);
        make.left.equalTo(applyBtn.right).offset(34);
        make.height.equalTo(@40);
    }];

    UILabel *titleLB = [[UILabel alloc] init];
    [titleLB setBackgroundColor:[UIColor clearColor]];
    [titleLB setFont:[UIFont systemFontOfSize:20]];
    titleLB.textColor= [UIColor colorWithHexString:@"292929"];
    titleLB.text=@"选择终端状态";
    [headerView addSubview:titleLB];
    [titleLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.centerX).offset(30);
        make.width.equalTo(@120);
        
    }];
    
    
    
    _textView=[[UITextView alloc] init];
    _textView.delegate = self;
    _textView.userInteractionEnabled = NO;
    _textView.clipsToBounds = YES;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.font = FONT20;
    _textView.text=@"全部";
    _textView.textAlignment=NSTextAlignmentLeft;
    _textView.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _textView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(titleLB.right).offset(30);
        make.right.equalTo(headerView.right).offset(-80);
        make.height.equalTo(@40);
        
    }];
    
    
    _terminalBtn = [[UIButton alloc] init];
    [_terminalBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [_terminalBtn addTarget:self action:@selector(terminalBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_terminalBtn];
    [_terminalBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.right.equalTo(headerView.right).offset(-80);
        make.height.equalTo(@40);
        make.width.equalTo(@50);
    }];
    

    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    titleView.frame = CGRectMake(26, 120, SCREEN_WIDTH-52, 28);
    
    if (iOS7) {
        titleView.frame = CGRectMake(26, 120, SCREEN_HEIGHT-52, 28);
    }
    
    [self.view addSubview:titleView];
    
    UILabel *numberLB = [[UILabel alloc] init];
    [numberLB setBackgroundColor:[UIColor clearColor]];
    [numberLB setFont:[UIFont systemFontOfSize:15]];
    numberLB.textColor= [UIColor colorWithHexString:@"292929"];
    numberLB.text=@"终端号";
    [titleView addSubview:numberLB];
    [numberLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.centerY);
        make.left.equalTo(titleView.left).offset(50);
        make.width.equalTo(@70);
        
    }];

    
    UILabel *POSLB = [[UILabel alloc] init];
    [POSLB setBackgroundColor:[UIColor clearColor]];
    [POSLB setFont:[UIFont systemFontOfSize:15]];
    POSLB.textColor= [UIColor colorWithHexString:@"292929"];
    POSLB.text=@"POS机";
    [titleView addSubview:POSLB];
    [POSLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.centerY);
        make.left.equalTo(numberLB.right).offset(50);
        make.width.equalTo(@70);
        
    }];
    
    UILabel *payLB = [[UILabel alloc] init];
    [payLB setBackgroundColor:[UIColor clearColor]];
    [payLB setFont:[UIFont systemFontOfSize:15]];
    payLB.textColor= [UIColor colorWithHexString:@"292929"];
    payLB.text=@"支付通道";
    payLB.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:payLB];
    [payLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.centerY);
        make.left.equalTo(POSLB.right).offset(50);
        make.width.equalTo(@70);
    }];
    
    UILabel *statusLB = [[UILabel alloc] init];
    [statusLB setBackgroundColor:[UIColor clearColor]];
    [statusLB setFont:[UIFont systemFontOfSize:15]];
    statusLB.textColor= [UIColor colorWithHexString:@"292929"];
    statusLB.text=@"开通状态";
    statusLB.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:statusLB];
    [statusLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.centerY);
        make.left.equalTo(payLB.right).offset(50);
        make.width.equalTo(@70);
    }];

    
    
    
}

#pragma mark - UI


- (void)initAndLayoutUI {
    
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120+28, SCREEN_HEIGHT-20*2, SCREEN_WIDTH-148)];
        
    }else
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120+28, SCREEN_WIDTH-20*2, SCREEN_HEIGHT-148)];
        
    }
    

    //_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -60,_tableView.frame.size.width, 60)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
}




//申请售后
-(void)applyAfterSale:(id)sender
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    
    _findPosView = [[UIImageView alloc]init];
    _findPosView.frame = CGRectMake(0, 0, width, height);
    [self.view.window addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 500)];
    _whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:_whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [_whiteView addSubview:leftXBtn];
    
    UILabel *ApplyLable = [[UILabel alloc]init];
    ApplyLable.text = @"申请售后";
    ApplyLable.textColor = kColor(38, 38, 38, 1.0);
    ApplyLable.font = [UIFont systemFontOfSize:22];
    ApplyLable.frame = CGRectMake(150, 10, 200, 40);
    [_whiteView addSubview:ApplyLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(ApplyLable.frame) + 10, _whiteView.frame.size.width, 1);
    [_whiteView addSubview:line];
    
    UILabel *POSLB = [[UILabel alloc]init];
    POSLB.text = @"选择终端";
    POSLB.textColor = kColor(56, 56, 56, 1.0);
    POSLB.font = [UIFont systemFontOfSize:20];
    POSLB.frame = CGRectMake(26, CGRectGetMaxY(line.frame) + 30, 100, 40);
    [_whiteView addSubview:POSLB];
    
    _posTV=[[UITextView alloc] init];
    _posTV.layer.masksToBounds=YES;
    _posTV.layer.borderWidth=1.0;
    _posTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _posTV.backgroundColor = [UIColor clearColor];
    _posTV.font = FONT20;
    _posTV.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30, CGRectGetMaxY(line.frame) + 30, 200, 40);
    [_whiteView addSubview:_posTV];
    
    UIButton *POSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    POSBtn.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30+150, CGRectGetMaxY(line.frame) + 30, 50, 40);
    [POSBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [POSBtn  addTarget:self action:@selector(POSBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:POSBtn];
    
    UILabel *AddressLB = [[UILabel alloc]init];
    AddressLB.text = @"选择地址";
    AddressLB.textColor = kColor(56, 56, 56, 1.0);
    AddressLB.font = [UIFont systemFontOfSize:20];
    AddressLB.frame = CGRectMake(26, POSLB.frame.origin.y + 70, 100, 40);
    [_whiteView addSubview:AddressLB];
    
    _AddressTV=[[UITextView alloc] init];
    _AddressTV.layer.masksToBounds=YES;
    _AddressTV.layer.borderWidth=1.0;
    _AddressTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _AddressTV.backgroundColor = [UIColor clearColor];
    _AddressTV.font = FONT20;
    _AddressTV.frame = CGRectMake(_posTV.frame.origin.x, AddressLB.frame.origin.y, 200, 40);
    [_whiteView addSubview:_AddressTV];
    
    UIButton *AddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AddressBtn.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30+150,  _AddressTV.frame.origin.y, 50, 40);
    [AddressBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [AddressBtn  addTarget:self action:@selector(AddressBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:AddressBtn];
    
    UILabel *reseasonLB = [[UILabel alloc]init];
    reseasonLB.text = @"售后原因";
    reseasonLB.textColor = kColor(56, 56, 56, 1.0);
    reseasonLB.font = [UIFont systemFontOfSize:20];
    reseasonLB.frame = CGRectMake(26, AddressLB.frame.origin.y+ 70, 100, 40);
    [_whiteView addSubview:reseasonLB];
    
    UITextView *reseasonTV=[[UITextView alloc] init];
    reseasonTV.layer.masksToBounds=YES;
    reseasonTV.layer.borderWidth=1.0;
    reseasonTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    reseasonTV.backgroundColor = [UIColor clearColor];
    reseasonTV.font = FONT20;
    reseasonTV.frame = CGRectMake(_posTV.frame.origin.x, reseasonLB.frame.origin.y, 200, 120);
    [_whiteView addSubview:reseasonTV];
    
    UIButton *submitBtn=[[UIButton alloc] init];
    submitBtn.frame=CGRectMake(_whiteView.frame.size.width/2.0-60, reseasonTV.frame.origin.y+120+30, 120, 40);
    submitBtn.layer.masksToBounds=YES;
    submitBtn.layer.borderWidth=1.0;
    submitBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    submitBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:submitBtn];
    
}

//选择终端tableView加载
-(UITableView *)terminalTableView
{
    if (!_terminalTableView) {
        _terminalTableView = [[UITableView alloc]init];
        _terminalTableView.tag = 1111;
        _terminalTableView.delegate = self;
        _terminalTableView.dataSource = self;
    }
    return _terminalTableView;
}
//创建选择终端tableView
-(void)setupTerminalTableView
{
   
        NSInteger numberrow;
        numberrow=_terminalItems.count;
        if(numberrow>5)
        {
            self.terminalTableView.frame = CGRectMake(_posTV.frame.origin.x, _posTV.frame.origin.y+_posTV.frame.size.height, 200, 5*45);
            
        }else
        {
            self.terminalTableView.frame = CGRectMake(_posTV.frame.origin.x, _posTV.frame.origin.y+_posTV.frame.size.height, 200, numberrow*45);

        }
   // }
    [_whiteView addSubview:_terminalTableView];
   // if (_applyData.merchantList.count != 0) {
        [_terminalTableView reloadData];
  //  }
}


-(void)POSBtnclick:(id)sender
{
    [self setupTerminalTableView];

}

-(void)AddressBtnclick:(id)sender
{


}

-(void)submitBtnClick:(id)sender
{
   /*
    NSMutableArray *paramList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:[delegate.agentID intValue]] forKey:@"customerId"];
    
   [params setObject:[NSString stringWithFormat:@"%@",_AddressTV.text]forKey:@"address"];
   [params setObject:[NSString stringWithFormat:@"%@",_AddressTV.text]forKey:@"reason"];
    
   [paramList addObject:params];
   //2[self submitApplyInfoWithArray:paramList];
*/
     [self removePOSView];
    
}

-(void)bindingTerminal:(id)sender
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    
    _findPosView = [[UIImageView alloc]init];
    _findPosView.frame = CGRectMake(0, 0, width, height);
    [self.view.window addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 320)];
    _whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:_whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [_whiteView addSubview:leftXBtn];
    
    UILabel *BindingLB = [[UILabel alloc]init];
    BindingLB.text = @"为用户绑定终端";
    BindingLB.textColor = kColor(38, 38, 38, 1.0);
    BindingLB.font = [UIFont systemFontOfSize:22];
    BindingLB.frame = CGRectMake(150, 10, 200, 40);
    [_whiteView addSubview:BindingLB];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(BindingLB.frame) + 10, _whiteView.frame.size.width, 1);
    [_whiteView addSubview:line];
    
    UILabel *UserLB = [[UILabel alloc]init];
    UserLB.text = @"选择用户";
    UserLB.textColor = kColor(56, 56, 56, 1.0);
    UserLB.font = [UIFont systemFontOfSize:20];
    UserLB.frame = CGRectMake(26, CGRectGetMaxY(line.frame) + 30, 100, 40);
    [_whiteView addSubview:UserLB];
    
    UITextView *UserTV=[[UITextView alloc] init];
    UserTV.layer.masksToBounds=YES;
    UserTV.layer.borderWidth=1.0;
    UserTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    UserTV.backgroundColor = [UIColor clearColor];
    UserTV.frame = CGRectMake(UserLB.frame.origin.x+UserLB.frame.size.width+30, CGRectGetMaxY(line.frame) + 30, 200, 40);
    [_whiteView addSubview:UserTV];
    
    UILabel *TerminalLB = [[UILabel alloc]init];
    TerminalLB.text = @"终端号";
    TerminalLB.textColor = kColor(56, 56, 56, 1.0);
    TerminalLB.font = [UIFont systemFontOfSize:20];
    TerminalLB.frame = CGRectMake(26, UserLB.frame.origin.y + 70, 100, 40);
    [_whiteView addSubview:TerminalLB];
    
    UITextView *TerminalTV=[[UITextView alloc] init];
    TerminalTV.layer.masksToBounds=YES;
    TerminalTV.layer.borderWidth=1.0;
    TerminalTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    TerminalTV.backgroundColor = [UIColor clearColor];
    TerminalTV.frame = CGRectMake(UserTV.frame.origin.x, TerminalLB.frame.origin.y, 200, 40);
    [_whiteView addSubview:TerminalTV];
    
    UIButton *bindingBtn=[[UIButton alloc] init];
    bindingBtn.frame=CGRectMake(_whiteView.frame.size.width/2.0-60, TerminalTV.frame.origin.y+40+30, 120, 40);
    bindingBtn.layer.masksToBounds=YES;
    bindingBtn.layer.borderWidth=1.0;
    bindingBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    bindingBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [bindingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:bindingBtn];
    
}

-(void)bindingBtnClick:(id)sender
{
    
    
}

-(void)terminalBtnPressed:(id)sender
{
    [self pickerDisplay:_textView];
}




#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    if (_stringStatus==0) {
        [self downloadDataWithPage:_page isMore:NO];
    }
    else
    {
        [self downloadDataWithPage:_page status:_stringStatus isMore:NO];
    }
}


- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalManagerListWithToken:delegate.token agentID:delegate.agentID page:page rows:kPageSize finished:^(BOOL success, NSData *response){
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
                        [_terminalItems removeAllObjects];
                    }
                    
                    id list = [[object objectForKey:@"result"] objectForKey:@"terminalList"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

- (void)downloadDataWithPage:(int)page status:(int)status isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalStatusListWithToken:delegate.token agentID:delegate.agentID page:page rows:kPageSize status:status finished:^(BOOL success, NSData *response){
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
                        [_terminalItems removeAllObjects];
                    }
                    
                    id list = [[object objectForKey:@"result"] objectForKey:@"applyList"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseStatusTerminalDataWithDictionary:object];
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


//加载详情
- (void)submitAfterSaleWithParm:(NSDictionary *)parm {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface  submintAgentWithtoken:delegate.agentID customerId:@"132" terminalsQuantity:@"12" address:@"shanghai" reason:@"aaaaaa" terminalsList:nil reciver:@"12" phone:@"1234567890"  finished:^(BOOL success, NSData *response) {
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
                   // [self parseSubmitWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}


#pragma mark - Data

- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"terminalList"];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    NSLog(@"terminalItems:%@",_terminalItems);
    [_tableView reloadData];
}

- (void)parseStatusTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"applyList"];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    NSLog(@"terminalItems:%@",_terminalItems);
    [_tableView reloadData];
}



#pragma mark terminalCell的代理
-(void)terminalCellBtnClicked:(int)btnTag WithSelectedID:(NSString *)selectedID Withindex:(int)indexNum
{
    if (btnTag == 1000) {
        NSLog(@"点击了找回POS密码 信息ID为%@",selectedID);
        [self initFindPosViewWithSelectedID:selectedID WithIndexNum:indexNum];
    }
    if (btnTag == 1001) {
        NSLog(@"点击了视频认证(已开通) 信息ID为%@",selectedID);
       
    }
    if (btnTag == 2000) {
        NSLog(@"点击了视频认证(未开通) 信息ID为%@",selectedID);
        
    }
    if (btnTag == 2001) {
        NSLog(@"点击了申请开通");
        [self pushApplyVCWithSelectedID:selectedID];
    }
    if (btnTag == 2002) {
        NSLog(@"点击了同步(未开通)");
    }
    if (btnTag == 3000) {
        NSLog(@"点击了找回POS密码（部分开通）");
        [self initFindPosViewWithSelectedID:selectedID WithIndexNum:indexNum];

    }
    if (btnTag == 3001) {
        NSLog(@"点击了视频认证(部分开通) 信息ID为%@",selectedID);
        
    }
    if (btnTag == 3002) {
        NSLog(@"点击了重新申请开通");
        [self pushApplyNewVCWithSelectedID:selectedID];
    }
    if (btnTag == 3003) {
        NSLog(@"点击了同步（部分开通）");
    }
    if (btnTag == 4000) {
        NSLog(@"点击了更新资料");
    }
    if (btnTag == 4001) {
        NSLog(@"点击了同步（已停用）");
    }
    if (btnTag == 5000) {
        NSLog(@"点击了租赁退换（已注销）");
    }

    
}


//找回PS密码
-(void)initFindPosViewWithSelectedID:(NSString *)selectedID WithIndexNum:(int)indexP
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    NSLog(@"第%d行",indexP);
    _findPosView = [[UIImageView alloc]init];
    
    _findPosView.frame = CGRectMake(0, 0, width, height);
    
    [self.view.window addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 220)];
    whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    whiteView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [whiteView addSubview:leftXBtn];
    
    UILabel *FindPOSLable = [[UILabel alloc]init];
    FindPOSLable.text = @"找回POS密码";
    FindPOSLable.textColor = kColor(38, 38, 38, 1.0);
    FindPOSLable.font = [UIFont systemFontOfSize:22];
    FindPOSLable.frame = CGRectMake(150, 10, 200, 40);
    [whiteView addSubview:FindPOSLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(FindPOSLable.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UILabel *POSLable = [[UILabel alloc]init];
    POSLable.text = @"POS机密码";
    POSLable.textColor = kColor(56, 56, 56, 1.0);
    POSLable.font = [UIFont systemFontOfSize:20];
    POSLable.frame = CGRectMake(FindPOSLable.frame.origin.x - 40, CGRectGetMaxY(line.frame) + 50, 120, 30);
    [whiteView addSubview:POSLable];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.textColor = kColor(132, 132, 132, 1.0);
    passwordLabel.font = [UIFont systemFontOfSize:20];
    passwordLabel.text = @"asdasdas";
    passwordLabel.frame = CGRectMake(CGRectGetMaxX(POSLable.frame), POSLable.frame.origin.y, 300, 30);
    [whiteView addSubview:passwordLabel];
    
}


-(void)leftClicked
{
    [self removePOSView];
}

-(void)removePOSView
{
    [_findPosView removeFromSuperview];
}


//重新申请开通
-(void)pushApplyNewVCWithSelectedID:(NSString *)selectedID
{
    
     ApplyDetailController *detailVC = [[ApplyDetailController alloc] init];
     detailVC.terminalID = selectedID;
     detailVC.openStatus = OpenStatusReopen;
     detailVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:detailVC animated:YES];
    
}


//新开通
-(void)pushApplyVCWithSelectedID:(NSString *)selectedID
{
    
     ApplyDetailController *detailVC = [[ApplyDetailController alloc] init];
     detailVC.terminalID = selectedID;
     detailVC.openStatus = OpenStatusNew;
     detailVC.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_terminalTableView) {
        NSString *ID = @"terminalcell";
        TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.backgroundColor = kColor(214, 214, 214, 1.0);
        TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
        cell.textLabel.text = model.TM_serialNumber;
        return cell;
        
    }
    else{
        if (_terminalItems.count == 0) {
            NSString *ID = @"cell";
            TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            return cell;
        }else{
            TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
            NSString *IDs = [NSString stringWithFormat:@"cell-%@",model.TM_status];
            TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDs];
            if (cell == nil) {
                cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDs];
                cell.TerminalViewCellDelegate = self;
            }
            cell.selectedID = model.TM_ID;
            cell.terminalLabel.text = model.TM_serialNumber;
            cell.posLabel.text = [NSString stringWithFormat:@"%@%@",model.TM_brandsName,model.TM_model_number];
            cell.payRoad.text = model.TM_channelName;
            cell.indexNum = indexPath.row;
            if ([model.TM_status isEqualToString:@"1"]) {
                cell.dredgeStatus.text = @"已开通";
                cell.cellStates = @"已开通";
            }
            if ([model.TM_status isEqualToString:@"3"]) {
                cell.dredgeStatus.text = @"未开通";
                cell.cellStates = @"未开通";
            }
            if ([model.TM_status isEqualToString:@"2"]) {
                cell.dredgeStatus.text = @"部分开通";
                cell.cellStates = @"部分开通";
            }
            if ([model.TM_status isEqualToString:@"5"]) {
                cell.dredgeStatus.text = @"已停用";
                cell.cellStates = @"已停用";
            }
            if ([model.TM_status isEqualToString:@"4"]) {
                cell.dredgeStatus.text = @"已注销";
                cell.cellStates = @"已注销";
            }
            return cell;
        }
    }
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_terminalTableView) {
        TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
         _posTV.text=model.TM_serialNumber;
        [_terminalTableView removeFromSuperview];
        
    }
    else
    {
    self.isPush = NO;
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
    if ([model.TM_status intValue] == TerminalStatusOpened && !model.appID) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }
    else{
        TerminalDetailViewController *terminalDetailVC = [[TerminalDetailViewController alloc]init];
        terminalDetailVC.hidesBottomBarWhenPushed = YES;
        terminalDetailVC.dealStatus = model.TM_status;
        terminalDetailVC.tm_ID = model.TM_ID;
        [self.navigationController pushViewController:terminalDetailVC animated:YES];
    }
   }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_terminalTableView) {
        return 30;
    }
    else
    {
    return 80;
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



#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:self.tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:self.tableView];
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
    _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
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
    if (scrollView == self.tableView) {
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
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

-(void)addTerminalSuccess
{
    [self firstLoadData];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self firstLoadData];
    
}

-(void)modifyStatus:(id)sender
{
    _textView.text=_string;
    if ([_string isEqualToString:@"全部"]) {
        _stringStatus=0;
    }else if ([_string isEqualToString:@"已开通"])
    {
        _stringStatus=1;
    }
    else if([_string isEqualToString:@"部分开通"])
    {
        _stringStatus=2;
    }
    else if([_string isEqualToString:@"未开通"])
    {
        _stringStatus=3;
    }
    else if([_string isEqualToString:@"已注销"])
    {
        _stringStatus=4;
    }
    else if([_string isEqualToString:@"已停用"])
    {
        _stringStatus=5;
    }
    [self pickerHide];
    [self firstLoadData];
    
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
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [theView addSubview:pickerView];
    
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _statusArray.count;
    
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [_statusArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    _string=[NSString stringWithFormat:@"%@"
             , [_statusArray objectAtIndex:row]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
