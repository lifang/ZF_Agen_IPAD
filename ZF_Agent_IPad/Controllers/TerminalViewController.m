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
#import "SearchTermianlViewController.h"
#import "TerminalSelectViewController.h"
#import "AddressSelectViewController.h"
#import "AddressModel.h"
#import "UserSelectViewController.h"
#import "TerminalSelectModel.h"
#import "RegularFormat.h"
#import "CityHandle.h"
#import "VideoAuthController.h"
#import "VideoAuthViewController.h"

@interface TerminalViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate,terminalCellSendBtnClicked,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,SelectedAddressDelegate,SelectedUserDelegate,SelectedTerminalDelegate,SearchDelegate>
{

     NSInteger touchStatus;
    
}

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

@property (nonatomic, assign) int stringStatus;

@property (nonatomic, strong) UITextView *posTV;
@property (nonatomic, strong) UITextView *AddressTV;
@property (nonatomic, strong) UITextView *reseasonTV;

@property(nonatomic,strong)UITableView *terminalTableView;

@property(nonatomic,strong) UIView *whiteView;

@property(nonatomic,strong) UIView *secondView;

@property (nonatomic, strong) UITextView *UserTV;

@property (nonatomic, strong) UITextView *TerminalTV;
//售后终端号
@property (nonatomic, strong) NSMutableArray *TerminalsArray;
@property (nonatomic, strong) NSString *addressId; //当前选择的地址id

@property (nonatomic, strong) UITextView *nameTV;
@property (nonatomic, strong) UITextView *phoneTV;
@property (nonatomic, strong) UITextView *codeTV;
@property (nonatomic, strong) UITextView *locationTV;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *confpwdTF;

@property (nonatomic, strong) UIPickerView *pickerView;
//@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列
@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) NSString *reciver;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *serialNum;

@property (nonatomic, strong) UITextView *blackTV;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UILabel *passwordLabel;//POS机密码

@end

@implementation TerminalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"终端管理";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    //searchBtn.titleLabel.font = IconFontWithSize(22);
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[searchBtn setTitle:@"\U0000E62f" forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbar.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = leftBarBtn;
    
    
    _terminalItems = [[NSMutableArray alloc]init];
    _TerminalsArray = [[NSMutableArray alloc]init];
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
    [applyBtn addTarget:self action:@selector(applyAfterSale) forControlEvents:UIControlEventTouchUpInside];
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
    

   
    
   
    /*
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 500)];
    blackView.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT - 100) / 2);
    blackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blackView];
    
    _blackTV=[UITextView alloc];
    _blackTV.frame = CGRectMake(156, 270, 240, 40);
    [blackView addSubview:_blackTV];
    */
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120+28, SCREEN_HEIGHT-20*2, SCREEN_WIDTH-148)];
        
    }else
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120+28, SCREEN_WIDTH-20*2, SCREEN_HEIGHT-148)];
        
    }
    

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

-(void)searchBtnPressed:(id)sender
{
    SearchTermianlViewController *searchVC=[[SearchTermianlViewController alloc] init];
    searchVC.delegate=self;
    searchVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC animated:YES];


}


//申请售后
-(void)applyAfterSale
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
    _posTV.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30, CGRectGetMaxY(line.frame) + 30, 240, 40);
    [_whiteView addSubview:_posTV];
    
    UIButton *POSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    POSBtn.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30+150+40, CGRectGetMaxY(line.frame) + 30, 50, 40);
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
    _AddressTV.frame = CGRectMake(_posTV.frame.origin.x, AddressLB.frame.origin.y, 240, 40);
    [_whiteView addSubview:_AddressTV];
    
    UIButton *AddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AddressBtn.frame = CGRectMake(POSLB.frame.origin.x+POSLB.frame.size.width+30+150+40,  _AddressTV.frame.origin.y, 50, 40);
    [AddressBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [AddressBtn  addTarget:self action:@selector(AddressBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:AddressBtn];
    
    UILabel *reseasonLB = [[UILabel alloc]init];
    reseasonLB.text = @"售后原因";
    reseasonLB.textColor = kColor(56, 56, 56, 1.0);
    reseasonLB.font = [UIFont systemFontOfSize:20];
    reseasonLB.frame = CGRectMake(26, AddressLB.frame.origin.y+ 70, 100, 40);
    [_whiteView addSubview:reseasonLB];
    
    _reseasonTV=[[UITextView alloc] init];
    _reseasonTV.layer.masksToBounds=YES;
    _reseasonTV.layer.borderWidth=1.0;
    _reseasonTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _reseasonTV.backgroundColor = [UIColor clearColor];
    _reseasonTV.font = FONT20;
    _reseasonTV.frame = CGRectMake(_posTV.frame.origin.x, reseasonLB.frame.origin.y, 240, 120);
    [_whiteView addSubview:_reseasonTV];
    
    UIButton *submitBtn=[[UIButton alloc] init];
    submitBtn.frame=CGRectMake(_whiteView.frame.size.width/2.0-60, _reseasonTV.frame.origin.y+120+30, 120, 40);
    submitBtn.layer.masksToBounds=YES;
    submitBtn.layer.borderWidth=1.0;
    submitBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    submitBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:submitBtn];
    
}



-(void)POSBtnclick:(id)sender
{
  
    TerminalSelectViewController *TerminalSC=[[TerminalSelectViewController alloc] init];
    TerminalSC.hidesBottomBarWhenPushed=YES;
    TerminalSC.delegate=self;
     [_findPosView setHidden:YES];
    [self.navigationController pushViewController:TerminalSC animated:YES];

}

-(void)AddressBtnclick:(id)sender
{
    AddressSelectViewController *AddressSC=[[AddressSelectViewController alloc] init];
    AddressSC.hidesBottomBarWhenPushed=YES;
    AddressSC.delegate=self;
    [_findPosView setHidden:YES];
    if (![_AddressTV.text isEqualToString:@""]) {
        AddressSC.addressID=_addressId;
    }
    [self.navigationController pushViewController:AddressSC animated:YES];
   

}

-(void)submitBtnClick:(id)sender
{

    if ((!_posTV.text||[_AddressTV.text isEqualToString:@""])&&([_TerminalsArray count] <= 0)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择终端";
        return;
    }
    if (!_AddressTV.text ||[_AddressTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择地址";
        return;
    }
    if (!_reseasonTV.text || [_reseasonTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入售后原因";
        return;
    }
    NSLog(@"count:%lu",(unsigned long)[_TerminalsArray count]);
    NSLog(@"array:%@",_TerminalsArray);
    NSLog(@"reciver:%@",_reciver);
    NSLog(@"phone:%@",_phone);
    NSLog(@"address:%@",_AddressTV.text);
    NSLog(@"reseason:%@",_reseasonTV.text);

     [self submitAfterSale];
     //[self removePOSView];
    
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
    
    _UserTV=[[UITextView alloc] init];
    _UserTV.layer.masksToBounds=YES;
    _UserTV.layer.borderWidth=1.0;
    _UserTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _UserTV.backgroundColor = [UIColor clearColor];
    _UserTV.font = [UIFont systemFontOfSize:20];
    _UserTV.frame = CGRectMake(UserLB.frame.origin.x+UserLB.frame.size.width+30, CGRectGetMaxY(line.frame) + 30, 240, 40);
    [_whiteView addSubview:_UserTV];
    
    UIButton *UserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UserBtn.frame = CGRectMake(_UserTV.frame.origin.x+150+40, _UserTV.frame.origin.y,50, 40);
    [UserBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [UserBtn  addTarget:self action:@selector(UserBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:UserBtn];
    
    UIButton *newBtn=[[UIButton alloc] init];
    newBtn.frame=CGRectMake(_UserTV.frame.origin.x, _UserTV.frame.origin.y+40+10, 100, 20);
    [newBtn setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
    [newBtn setTitle:@"创建新用户" forState:UIControlStateNormal];
    newBtn.titleLabel.font = FONT15;
    [newBtn addTarget:self action:@selector(newBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:newBtn];

    
    UILabel *TerminalLB = [[UILabel alloc]init];
    TerminalLB.text = @"终端号";
    TerminalLB.textColor = kColor(56, 56, 56, 1.0);
    TerminalLB.font = [UIFont systemFontOfSize:20];
    TerminalLB.frame = CGRectMake(26, UserLB.frame.origin.y + 80, 100, 40);
    [_whiteView addSubview:TerminalLB];
    
    _TerminalTV=[[UITextView alloc] init];
    _TerminalTV.layer.masksToBounds=YES;
    _TerminalTV.layer.borderWidth=1.0;
    _TerminalTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _TerminalTV.backgroundColor = [UIColor clearColor];
    _TerminalTV.font = [UIFont systemFontOfSize:20];
    _TerminalTV.frame = CGRectMake(_UserTV.frame.origin.x, TerminalLB.frame.origin.y, 240, 40);
    [_whiteView addSubview:_TerminalTV];
    
    UIButton *bindingBtn=[[UIButton alloc] init];
    bindingBtn.frame=CGRectMake(_whiteView.frame.size.width/2.0-60, _TerminalTV.frame.origin.y+40+30, 120, 40);
    bindingBtn.layer.masksToBounds=YES;
    bindingBtn.layer.borderWidth=1.0;
    bindingBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    bindingBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [bindingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:bindingBtn];
    
}

-(void)UserBtnclick:(id)sender
{

    UserSelectViewController *UserSC=[[UserSelectViewController alloc] init];
    UserSC.hidesBottomBarWhenPushed=YES;
    UserSC.delegate=self;
    [_findPosView setHidden:YES];
    [self.navigationController pushViewController:UserSC animated:YES];

}

-(void)bindingBtnClick:(id)sender
{
    if (!_UserTV.text ||[_UserTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择用户";
        return;
    }
    if (!_TerminalTV.text ||[_TerminalTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写终端号";
        return;
    }

    [self bindingTerminals];
    //[self removePOSView];
    
}

-(void)terminalBtnPressed:(id)sender
{
    touchStatus=200;
    [self pickerDisplay:_textView];
}

-(void)newBtnClick:(id)sender
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
    /*
    _findPosView = [[UIImageView alloc]init];
    _findPosView.frame = CGRectMake(0, 0, width, height);
    [self.view.window addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    */
    
    _secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 550)];
    _secondView.center = CGPointMake(width / 2, (height - 100) / 2);
    _secondView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:_secondView];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(leftBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(15, 15, 25, 25);
    [_secondView addSubview:leftBtn];
    
    UILabel *newLB = [[UILabel alloc]init];
    newLB.text = @"创建用户";
    newLB.textColor = kColor(38, 38, 38, 1.0);
    newLB.font = [UIFont systemFontOfSize:22];
    newLB.frame = CGRectMake(150, 10, 200, 40);
    [_secondView addSubview:newLB];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(newLB.frame) + 10, _secondView.frame.size.width, 1);
    [_secondView addSubview:line];
    
    UILabel *nameLB = [[UILabel alloc]init];
    nameLB.text = @"用户姓名";
    nameLB.textColor = kColor(56, 56, 56, 1.0);
    nameLB.font = [UIFont systemFontOfSize:20];
    nameLB.frame = CGRectMake(26, CGRectGetMaxY(line.frame) + 30, 100, 40);
    [_secondView addSubview:nameLB];
    
    _nameTV=[[UITextView alloc] init];
    _nameTV.layer.masksToBounds=YES;
    _nameTV.layer.borderWidth=1.0;
    _nameTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _nameTV.backgroundColor = [UIColor clearColor];
    _nameTV.font = FONT20;
    _nameTV.frame = CGRectMake(nameLB.frame.origin.x+nameLB.frame.size.width+30, CGRectGetMaxY(line.frame) + 30, 240, 40);
    [_secondView addSubview:_nameTV];
    
  
    UILabel *phoneLB = [[UILabel alloc]init];
    phoneLB.text = @"手机号码";
    phoneLB.textColor = kColor(56, 56, 56, 1.0);
    phoneLB.font = [UIFont systemFontOfSize:20];
    phoneLB.frame = CGRectMake(26, nameLB.frame.origin.y + 60, 100, 40);
    [_secondView addSubview:phoneLB];
    
    _phoneTV=[[UITextView alloc] init];
    _phoneTV.layer.masksToBounds=YES;
    _phoneTV.layer.borderWidth=1.0;
    _phoneTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _phoneTV.backgroundColor = [UIColor clearColor];
    _phoneTV.font = FONT20;
    _phoneTV.frame = CGRectMake(_nameTV.frame.origin.x, phoneLB.frame.origin.y, 240, 40);
    [_secondView addSubview:_phoneTV];
    
    UIButton *getcodeBtn=[[UIButton alloc] init];
    getcodeBtn.frame=CGRectMake(_phoneTV.frame.origin.x+160, _phoneTV.frame.origin.y, 80, 40);
    [getcodeBtn setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
    [getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getcodeBtn.titleLabel.font = FONT15;
    [getcodeBtn addTarget:self action:@selector(getcodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondView addSubview:getcodeBtn];
    
    UILabel *codeLB = [[UILabel alloc]init];
    codeLB.text = @"验证码";
    codeLB.textColor = kColor(56, 56, 56, 1.0);
    codeLB.font = [UIFont systemFontOfSize:20];
    codeLB.frame = CGRectMake(26, phoneLB.frame.origin.y + 60, 100, 40);
    [_secondView addSubview:codeLB];
    
    _codeTV=[[UITextView alloc] init];
    _codeTV.layer.masksToBounds=YES;
    _codeTV.layer.borderWidth=1.0;
    _codeTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _codeTV.backgroundColor = [UIColor clearColor];
    _codeTV.font = FONT20;
    _codeTV.frame = CGRectMake(_phoneTV.frame.origin.x, codeLB.frame.origin.y, 240, 40);
    [_secondView addSubview:_codeTV];
    
    
    UILabel *locationLB = [[UILabel alloc]init];
    locationLB.text = @"所在地";
    locationLB.textColor = kColor(56, 56, 56, 1.0);
    locationLB.font = [UIFont systemFontOfSize:20];
    locationLB.frame = CGRectMake(26, codeLB.frame.origin.y + 60, 100, 40);
    [_secondView addSubview:locationLB];
    
    _locationTV=[[UITextView alloc] init];
    _locationTV.layer.masksToBounds=YES;
    _locationTV.layer.borderWidth=1.0;
    _locationTV.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _locationTV.backgroundColor = [UIColor clearColor];
    _locationTV.font = FONT20;
    _locationTV.frame = CGRectMake(_codeTV.frame.origin.x, locationLB.frame.origin.y, 240, 40);
    [_secondView addSubview:_locationTV];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(_locationTV.frame.origin.x+150+40, _locationTV.frame.origin.y, 50, 40);
    [locationBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [locationBtn  addTarget:self action:@selector(locationBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondView addSubview:locationBtn];

    
    UILabel *pwdLB = [[UILabel alloc]init];
    pwdLB.text = @"密码";
    pwdLB.textColor = kColor(56, 56, 56, 1.0);
    pwdLB.font = [UIFont systemFontOfSize:20];
    pwdLB.frame = CGRectMake(26, locationLB.frame.origin.y + 60, 100, 40);
    [_secondView addSubview:pwdLB];
    
    _pwdTF=[[UITextField alloc] init];
    _pwdTF.layer.masksToBounds=YES;
    _pwdTF.layer.borderWidth=1.0;
    _pwdTF.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _pwdTF.backgroundColor = [UIColor clearColor];
    _pwdTF.font = FONT20;
    _pwdTF.delegate=self;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.secureTextEntry = YES;
    _pwdTF.frame = CGRectMake(_codeTV.frame.origin.x, pwdLB.frame.origin.y, 240, 40);
    [_secondView addSubview:_pwdTF];

    UILabel *confpwdLB = [[UILabel alloc]init];
    confpwdLB.text = @"确认密码";
    confpwdLB.textColor = kColor(56, 56, 56, 1.0);
    confpwdLB.font = [UIFont systemFontOfSize:20];
    confpwdLB.frame = CGRectMake(26, pwdLB.frame.origin.y + 60, 100, 40);
    [_secondView addSubview:confpwdLB];
    
    _confpwdTF=[[UITextField alloc] init];
    _confpwdTF.layer.masksToBounds=YES;
    _confpwdTF.layer.borderWidth=1.0;
    _confpwdTF.layer.borderColor=[UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _confpwdTF.backgroundColor = [UIColor clearColor];
    _confpwdTF.font = FONT20;
    _confpwdTF.delegate=self;
    _confpwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confpwdTF.secureTextEntry = YES;
    _confpwdTF.frame = CGRectMake(_codeTV.frame.origin.x, confpwdLB.frame.origin.y, 240, 40);
    [_secondView addSubview:_confpwdTF];

    
    UIButton *bulidBtn=[[UIButton alloc] init];
    bulidBtn.frame=CGRectMake(_secondView.frame.size.width/2.0-60, _confpwdTF.frame.origin.y+40+30, 120, 40);
    bulidBtn.layer.masksToBounds=YES;
    bulidBtn.layer.borderWidth=1.0;
    bulidBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    bulidBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [bulidBtn setTitle:@"创建" forState:UIControlStateNormal];
    [bulidBtn addTarget:self action:@selector(bulidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondView addSubview:bulidBtn];
    


}

-(void)getcodeBtnClick:(id)sender
{
    if (!_phoneTV.text ||[_phoneTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入手机号";
        return;
    }
    if (![RegularFormat isMobileNumber:_phoneTV.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
    }

    [self sendPhoneCode];
}

-(void)locationBtnclick:(id)sender
{
    touchStatus=100;
    //[self pickerDisplay:_locationTV];
    [self pickerDisplay:_textView];
   // [self pickerDisplay:_findPosView];
    // [self pickerDisplay:_tableView];
}

-(void)leftBackClicked
{
   [_secondView removeFromSuperview];
}

-(void)bulidBtnClick:(id)sender
{
    NSLog(@"chuangjian");
    if (!_nameTV.text ||[_nameTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"填写用户姓名";
        return;
    }
    if (!_phoneTV.text ||[_phoneTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写手机号码";
        return;
    }
    if (!_codeTV.text ||[_codeTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填入验证码";
        return;
    }
    if (!_locationTV.text ||[_locationTV.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }
    if (!_pwdTF.text ||[_pwdTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入密码";
        return;
    }
    if (!_confpwdTF.text ||[_confpwdTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请确认密码";
        return;
    }

    [self addNewUser];
    //[_secondView removeFromSuperview];
}

#pragma mark - SelectedAddressDelegate

- (void)getSelectedAddress:(AddressModel *)addressModel {
    
     [_findPosView setHidden:NO];
    _AddressTV.text=addressModel.address;
    _phone=addressModel.addressPhone;
    _reciver=addressModel.addressReceiver;
    _addressId=addressModel.addressID;
    NSLog(@"PHONE:%@",addressModel.addressPhone);
    NSLog(@"RECIVER:%@",addressModel.addressReceiver);
   
}

-(void)selectedUser:(UserModel *)model {
    [_findPosView setHidden:NO];
    _UserTV.text=model.userName;
    _userId=model.userID;
   
    
}



-(void)getSelectedTerminal:(NSMutableArray *)array
{
   
    [_findPosView setHidden:NO];
    [_TerminalsArray removeAllObjects];
    TerminalSelectModel *model=[[TerminalSelectModel alloc] init];
    for (int i=0; i<array.count; i++) {
        model=[ array objectAtIndex:i];
        //[_TerminalsArray addObject:model];
        [_TerminalsArray addObject:model.serial_num];
        if (i==0) {
            _posTV.text=[NSString stringWithFormat:@"%@等",model.serial_num];
        }
    }
    
 }



#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    if (_stringStatus==0) {
        [self downloadDataWithPage:_page isMore:NO];
    }
    else if(_stringStatus==6)
    {
        [self searchTermianlsWithPage:_page serialNum:_serialNum isMore:NO];
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


//搜索终端
- (void)searchTermianlsWithPage:(int)page serialNum:(NSString *)string isMore:(BOOL)isMore {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface searchTerminalsListWithToken:delegate.token agentID:delegate.agentID page:page rows:kPageSize serialNum:string finished:^(BOOL success, NSData *response){
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
                    [self parseSearchTerminalDataWithDictionary:object];
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




- (NSString *)terminalStringWithArray:(NSArray *)terminalList {
    NSString *names = @"";
    for (int i = 0; i < [terminalList count]; i++) {
        NSString *str=[terminalList objectAtIndex:i];
        if (i != [terminalList count] - 1) {
            names = [str stringByAppendingString:@","];
        }
    }
    return names;
}


//提交售后
- (void)submitAfterSale {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
     NSString *terminalString = [self terminalStringWithArray:_TerminalsArray];
    
    [NetworkInterface submitAfterSaleApplyWithUserID:delegate.agentID token:delegate.token terminalCount:[_TerminalsArray count] address:_AddressTV.text receiver:_reciver phoneNumber:_phone reason:_textView.text terminalList:terminalString finished:^(BOOL success, NSData *response) {
/*
    [NetworkInterface  submintAgentWithtoken:delegate.token customerId:delegate.agentID terminalsQuantity:[_TerminalsArray count] address:_AddressTV.text reason:_reseasonTV.text terminalsList:terminalString reciver:_reciver phone:_phone  finished:^(BOOL success, NSData *response) {
 */
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self removePOSView];
                     hud.labelText = @"提交申请成功";
            
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


//绑定终端
- (void)bindingTerminals {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_whiteView animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface bindingTerminalWithtoken:delegate.token AgentId:delegate.agentID  terminalsNum:_TerminalTV.text userId:_userId  finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"绑定终端成功";
                    [self removePOSView];
                    
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

//创建新用户
- (void)addNewUser {
    
    NSLog(@"username:%@",_nameTV.text);
    NSLog(@"pwd:%@",_pwdTF.text);
    NSLog(@"codeNumber:%@",_phoneTV.text);
    NSLog(@"cityId:%@",_cityId);
    NSLog(@"code:%@",_codeTV.text);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface  addUserWithtoken:delegate.token AgentId:delegate.agentID username:_nameTV.text password:_pwdTF.text codeNumber:_phoneTV.text cityId:_cityId code:_codeTV.text finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"添加成功";
                   [_secondView removeFromSuperview];
                    
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


//获取手机验证码
- (void)sendPhoneCode {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_secondView animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface  sendBindingValidateWithMobileNumber:_phoneTV.text finished:^(BOOL success, NSData *response) {
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
                     hud.labelText = @"验证码已发送到您的手机";
                   // if ([[object objectForKey:@"result"] isKindOfClass:[NSString class]]) {
                    //    _codeTV.text = [object objectForKey:@"result"];
                   // }
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


//同步
- (void)getTerminalSynchronous:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalSynchronousWithToken:delegate.token terminalsId:string finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"同步成功";
                    
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

//找回POS机密码
- (void)findPOSpwd:(NSString *)string {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface findPOSpwdWithtoken:delegate.token terminalid:string finished:^(BOOL success, NSData *response){
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
                    
                    //id list = [[object objectForKey:@"result"] objectForKey:@"applyList"];
                   // [self parseSearchTerminalDataWithDictionary:object];
                    _passwordLabel.text = [object objectForKey:@"result"];
                    
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
    [_terminalItems removeAllObjects];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    NSLog(@"terminalItems:%@",_terminalItems);
    [_tableView reloadData];
}

- (void)parseSearchTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"applyList"];
    [_terminalItems removeAllObjects];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    NSLog(@"terminalItems:%@",_terminalItems);
    _textView.text=@"全部";
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
        NSLog(@"点击了视频认证(已开通) 信息ID为%@&&&& %d",selectedID,indexNum);
        //[self VideoVCWithSelectedID:selectedID];
        [self VideoVCWithSelectedID:indexNum];
    }
    if (btnTag == 2000) {
        NSLog(@"点击了视频认证(未开通) 信息ID为%@&&&& %d",selectedID,indexNum);
        [self VideoVCWithSelectedID:indexNum];
    }
    if (btnTag == 2001) {
        NSLog(@"点击了申请开通");
        [self pushApplyVCWithSelectedID:selectedID];
    }
    if (btnTag == 2002) {
        NSLog(@"点击了同步(未开通)");
        [self synchronization:indexNum];

    }
    if (btnTag == 3000) {
        NSLog(@"点击了找回POS密码（部分开通）");
        [self initFindPosViewWithSelectedID:selectedID WithIndexNum:indexNum];

    }
    if (btnTag == 3001) {
        NSLog(@"点击了视频认证(部分开通) 信息ID为%@&&&& %d",selectedID,indexNum);
         [self VideoVCWithSelectedID:indexNum];
    }
    if (btnTag == 3002) {
        NSLog(@"点击了重新申请开通");
        [self pushApplyNewVCWithSelectedID:selectedID];
    }
    if (btnTag == 3003) {
        NSLog(@"点击了同步（部分开通）");
        [self synchronization:indexNum];

    }
    //if (btnTag == 4000) {
   //     NSLog(@"点击了更新资料");
        
    //}
    if (btnTag == 4000) {
        NSLog(@"点击了同步（已停用）");
        [self synchronization:indexNum];
    }
   // if (btnTag == 5000) {
   //     NSLog(@"点击了租赁退换（已注销）");
        
  //  }

    
}


//找回POS密码
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
    
    _passwordLabel = [[UILabel alloc]init];
    _passwordLabel.textColor = kColor(132, 132, 132, 1.0);
    _passwordLabel.font = [UIFont systemFontOfSize:20];
    //passwordLabel.text = @"asdasdas";
    _passwordLabel.frame = CGRectMake(CGRectGetMaxX(POSLable.frame), POSLable.frame.origin.y, 300, 30);
    [whiteView addSubview:_passwordLabel];
    [self findPOSpwd:selectedID];
    
}


-(void)leftClicked
{
    [self removePOSView];
}

-(void)removePOSView
{
    [_findPosView removeFromSuperview];
}


//视频认证
-(void)VideoVCWithSelectedID:(int)indexNum
{
   
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexNum];
    VideoAuthViewController *videoAuthVC = [[VideoAuthViewController alloc] init];
    videoAuthVC.terminalID = model.TM_ID;//终端记录id
    videoAuthVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:videoAuthVC animated:YES];

    
}


//同步
- (void)synchronization:(int)indexNum
{
    
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexNum];
    //终端号 model.TM_serialNumber
    [self getTerminalSynchronous:model.TM_serialNumber];
    
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


#pragma mark - searchTerminal
- (void)getSearchKeyword:(NSString *)keyword
{
    
    NSLog(@"ffffffffhhhhHHHHH");
    _stringStatus=6;
    _serialNum=keyword;
    [self firstLoadData];
   //  _page=1;
   //  [self searchTermianlsWithPage:_page serialNum:keyword isMore:NO];
    
    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
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





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 80;
    
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





-(void)modifyStatus:(id)sender
{
    [self pickerHide];
    if (touchStatus==100) {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        _cityId = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
        _locationTV.text=cityName;
       
    }
   else
   {
    
    NSInteger index = [_pickerView selectedRowInComponent:0];
    _textView.text=[NSString stringWithFormat:@"%@",[_statusArray objectAtIndex:index]];

    if ([_textView.text isEqualToString:@"全部"]) {
        _stringStatus=0;
    }else if ([_textView.text isEqualToString:@"已开通"])
    {
        _stringStatus=1;
    }
    else if([_textView.text isEqualToString:@"部分开通"])
    {
        _stringStatus=2;
    }
    else if([_textView.text isEqualToString:@"未开通"])
    {
        _stringStatus=3;
    }
    else if([_textView.text isEqualToString:@"已注销"])
    {
        _stringStatus=4;
    }
    else if([_textView.text isEqualToString:@"已停用"])
    {
        _stringStatus=5;
    }
    [self firstLoadData];
    }
    
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
    if (touchStatus==100) {
        return 2;
    }
    else
    {
    return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (touchStatus==100) {
        
        if (component == 0) {
            return [[CityHandle shareProvinceList] count];
        }
        else {
            NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
            _cityArray = [provinceDict objectForKey:@"cities"];
            return [_cityArray count];
        }
        
    }
    
    else
    {
         return _statusArray.count;
        
      }
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (touchStatus==100) {
        if (component == 0) {
            //省
            NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
            return [provinceDict objectForKey:@"name"];
        }
        else {
            //市
            return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
        }
    }
    else
    {
         return [_statusArray objectAtIndex:row];;
        
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (touchStatus==100) {
        if (component == 0) {
        //
        [_pickerView reloadComponent:1];
        }
    }

}





-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self firstLoadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
