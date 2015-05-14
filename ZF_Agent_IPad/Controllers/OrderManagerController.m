//
//  OrderManagerController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderManagerController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "KxMenu.h"
#import "OrderDetailController.h"
#import "GoodDetailViewController.h"
#import "GoodDetailViewController.h"
#import "RegularFormat.h"





@interface OrderManagerController ()<OrderCellDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property (nonatomic, assign) SupplyGoodsType supplyType; //批购还是代购订单

@property (nonatomic, assign) int currentStatus;  //筛选的订单状态
@property (nonatomic, assign) OrderType currentType;      //筛选的订单类型
@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *typeButton;   //订单类型
@property (nonatomic, strong) UIButton *statusButton; //订单状态
@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *statusLabel;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *orderItem;
@property (nonatomic, strong) OrderModel *selectedOrder;

@end

@implementation OrderManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];
    
    
    UIButton *shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(0, 0, 30, 30);
    [shoppingButton setBackgroundImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
    
    //    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(shoppingview) forControlEvents:UIControlEventTouchUpInside];
    
        //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
       spaceItem.width = 52;
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,shoppingItem,spaceItem,spaceItem, spaceItem,nil];
    


    // Do any additional setup after loading the view.
    self.title = @"订单管理";
    _orderItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    self.supplyType = SupplyGoodsProcurement;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshOrderList:)
                                                 name:RefreshOrderListNotification
                                               object:nil];
}
-(void)shoppingview
{


    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    [delegate.rootViewController.homeController setSeletedIndex:1];
    
    if (_supplyType == SupplyGoodsProcurement) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listRefresh" object:self userInfo:nil];

        
    }else{
    
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listRefreshs" object:self userInfo:nil];

    
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NSNotification

- (void)refreshOrderList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - UI
-(void)setupHeaderView
{
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
//创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(0, 0, wide, 80);
//    if (iOS7) {
//        headerView.frame = CGRectMake(0, 0, wide, 80);
//    }
    //创建头部按钮
//    UIButton *publicBtn = [[UIButton alloc]init];
//    self.isChecked = YES;
//    self.publickBtn = publicBtn;
//    [publicBtn addTarget:self action:@selector(publicClicked) forControlEvents:UIControlEventTouchUpInside];
//    publicBtn.backgroundColor = [UIColor clearColor];
//    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
//    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
//    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [publicBtn setTitle:@"批购订单" forState:UIControlStateNormal];
//    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.4 , 40, 140, 40);
//    self.privateY = 40;
//    self.publicX = headerView.frame.size.width * 0.4;
//    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    [privateBtn addTarget:self action:@selector(privateClicked) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"代购订单" forState:UIControlStateNormal];
//    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 44, 120, 36);
//    self.privateX = CGRectGetMaxX(publicBtn.frame);
    [headerView addSubview:privateBtn];
    if(self.supplyType==SupplyGoodsWholesale)
    {
        [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _publickBtn.frame = CGRectMake(_publicX, _privateY, 140, 40);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 120, 36);
    }else
    {
        [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _privateBtn.frame = CGRectMake(_privateX, _privateY, 140, 40);
        _privateBtn.center=CGPointMake(wide/2, 40);
        
//        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
//        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
//        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 120, 36);
        
    }
    
    
    [self.view addSubview:headerView];
}
-(void)publicClicked
{
    self.supplyType=SupplyGoodsWholesale;
    
    
    
    
    [self firstLoadData];
}

-(void)privateClicked
{
    self.supplyType=SupplyGoodsProcurement;
    
    _isChecked = NO;
    [self firstLoadData];
    
}
- (void)initAndLayoutUI {
    [self initRefreshViewWithOffset:80];
//    NSArray *nameArray = [NSArray arrayWithObjects:
//                          @"批购订单",
//                          @"代购订单",
//                          nil];
//    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArray];
//    _segmentControl.selectedSegmentIndex = 0;
//    _segmentControl.tintColor = kMainColor;
//    [_segmentControl addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
//    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [UIFont boldSystemFontOfSize:14.f],NSFontAttributeName,
//                              nil];
//    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    
    //控件初始化
//    _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _typeButton.frame = CGRectMake(10, 0, 110, 30);
//    _typeButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
//    [_typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_typeButton setTitle:@"选择订单类型" forState:UIControlStateNormal];
//    [_typeButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
//    [_typeButton addTarget:self action:@selector(showOrderType:) forControlEvents:UIControlEventTouchUpInside];
//    _typeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
//    _typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 0, 110, 30);
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:@"选择状态" forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(showOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    _statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
//    _typeLabel = [[UILabel alloc] init];
//    _typeLabel.backgroundColor = [UIColor clearColor];
//    _typeLabel.font = [UIFont systemFontOfSize:13.f];
//    _typeLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderType:)];
//    [_typeLabel addGestureRecognizer:typeTap];
    
    
    
    _statusLabel = [UIButton buttonWithType:UIButtonTypeCustom];

    [_statusLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _statusLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_statusLabel setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[_statusLabel  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[kColor(193, 192, 192, 1) CGColor]];
    
    
    [_statusLabel addTarget:self action:@selector(showOrderStatus:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)setHeaderAndFooterView {
    CGFloat headerHeight = 70.f;
    if (_supplyType == SupplyGoodsProcurement) {
        headerHeight = 70.f;
    }
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

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, headerHeight)];
headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    CGFloat h_space = 20.f;
    CGFloat v_space = 10.f;
    
    if (_supplyType == SupplyGoodsWholesale) {
        UIView *statusBackView = [self getHeaderBackView];
        CGRect rect = statusBackView.frame;
        rect.origin.y = 15.f;
        statusBackView.frame = rect;
        [headerView addSubview:statusBackView];
        
        
        _numberField = [[UITextField alloc] initWithFrame:CGRectMake(wide-280-60, 0, 280, 40)];
        _numberField.layer.borderWidth = 1;
        _numberField.layer.borderColor = kColor(193, 192, 192, 1).CGColor;
        _numberField.borderStyle = UITextBorderStyleNone;
        _numberField.font = [UIFont systemFontOfSize:16.f];
        _numberField.textAlignment = NSTextAlignmentCenter;
        _numberField.leftViewMode = UITextFieldViewModeAlways;
        _numberField.rightViewMode = UITextFieldViewModeAlways;
        _numberField.placeholder=@"请输入订单号";
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, 50, 35);
    [_addButton setImage:kImageName(@"textsearch") forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(searchclick) forControlEvents:UIControlEventTouchUpInside];
        _numberField.rightView = _addButton;
        [statusBackView addSubview:_numberField];
        
        _statusLabel.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
        _statusLabel.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素

        
        _statusButton.frame = CGRectMake(60, 5, 110, 30);
        CGFloat originX = _statusButton.frame.origin.x + _statusButton.frame.size.width + 10;
        _statusLabel.frame = CGRectMake(originX, 0,280, 40);
        [statusBackView addSubview:_statusButton];
        [statusBackView addSubview:_statusLabel];
    }
    else if (_supplyType == SupplyGoodsProcurement) {
        UIView *typeBackView = [self getHeaderBackView];
        CGRect rect = typeBackView.frame;
        rect.origin.y = 10.f;
        typeBackView.frame = rect;
        [headerView addSubview:typeBackView];
        
//        _typeLabel.frame = CGRectMake(10, 0, 110, 30);
//        CGFloat originX = _typeLabel.frame.origin.x + _typeLabel.frame.size.width + 10;
//        _typeLabel.frame = CGRectMake(originX, 0, wide - originX, 30);
//        [typeBackView addSubview:_typeButton];
//        [typeBackView addSubview:_typeLabel];
//        
        
        
        buybutton=[UIButton buttonWithType:UIButtonTypeCustom];
        rentbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        buybutton.frame=CGRectMake(60,0,  60, 40);
        rentbutton.frame=CGRectMake(160,0,  60, 40);
        [buybutton setTitle:@"代购买" forState:UIControlStateNormal];
        [rentbutton setTitle:@"代租赁" forState:UIControlStateNormal];
        [rentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rentbutton.tag=507;
        buybutton.tag=506;

        
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(140, 10, 1, 20)];
        linview.backgroundColor = [UIColor grayColor];
        [typeBackView addSubview:linview];
        [buybutton addTarget:self action:@selector(selectStatuss:) forControlEvents:UIControlEventTouchUpInside];
        [rentbutton addTarget:self action:@selector(selectStatuss:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [typeBackView addSubview:buybutton];
        [typeBackView addSubview:rentbutton];

     
        UIView *statusBackView = [self getHeaderBackView];
        rect = statusBackView.frame;
        rect.origin.x =220;
        
        rect.origin.y = 15;
        statusBackView.frame = rect;
        [headerView addSubview:statusBackView];
        
     
        _numberField = [[UITextField alloc] initWithFrame:CGRectMake(wide-280-60, 15, 280, 40)];
        _numberField.layer.borderWidth = 1;
        _numberField.layer.borderColor = kColor(193, 192, 192, 1).CGColor;
        _numberField.borderStyle = UITextBorderStyleNone;
        _numberField.font = [UIFont systemFontOfSize:16.f];
        _numberField.textAlignment = NSTextAlignmentCenter;
        _numberField.leftViewMode = UITextFieldViewModeAlways;
        _numberField.rightViewMode = UITextFieldViewModeAlways;
        _numberField.placeholder=@"请输入订单号";

        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, 50, 35);
        [_addButton setImage:kImageName(@"textsearch") forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(searchclick) forControlEvents:UIControlEventTouchUpInside];
        _numberField.rightView = _addButton;
        [headerView addSubview:_numberField];

        _statusLabel.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
        _statusLabel.imageEdgeInsets = UIEdgeInsetsMake(0,170,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素

        _statusButton.frame = CGRectMake(90+220, 15, 110, 30);
        _statusLabel.frame = CGRectMake(220+220, 15,180, 40);
        [headerView addSubview:_statusButton];
        [headerView addSubview:_statusLabel];
    }
}
-(void)searchclick
{


    [self firstLoadData];
    






}
- (IBAction)selectStatuss:(id)sender {
    UIButton*but=(UIButton*)sender;
    if(but.tag==506)
    {
        
        
        [buybutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        [rentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        _currentType = OrderTypeProcurementBuy;
        
        
        
    }
    else
    {
        _currentType = OrderTypeProcurementRent;
        
        
        [rentbutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        [buybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //    self.currentType = but.tag;
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (UIView *)getHeaderBackView {
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

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 40)];
    backView.backgroundColor = [UIColor whiteColor];
//    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 1)];
//    firstLine.backgroundColor = kColor(200, 199, 204, 1);
//    [backView addSubview:firstLine];
//    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - 1, wide, 1)];
//    secondLine.backgroundColor = kColor(200, 199, 204, 1);
//    [backView addSubview:secondLine];
    return backView;
}

#pragma mark - Set

- (void)setSupplyType:(SupplyGoodsType)supplyType {
    _supplyType = supplyType;
    if (supplyType == SupplyGoodsProcurement) {
        self.currentStatus = ProcurementStatusAll;
        self.currentType = OrderTypeProcurement;
    }
    else {
        self.currentStatus = WholesaleStatusAll;
        self.currentType = OrderTypeWholesale;
    }
    [self setHeaderAndFooterView];
    [self firstLoadData];
}

- (void)setCurrentStatus:(int)currentStatus {
    _currentStatus = currentStatus;
    [_statusLabel setTitle:[self stringForOrderStatus:_currentStatus] forState:UIControlStateNormal];
}

- (void)setCurrentType:(OrderType)currentType {
    _currentType = currentType;
//    _typeLabel.text = [self stringForOrderType:_currentType];
}

#pragma mark - Request

- (void)firstLoadData {
    NSString *type = nil;
    if (_currentType == OrderTypeProcurement) {
        type = @"代购所有类型";
    }
    else if (_currentType == OrderTypeProcurementBuy) {
        type = @"代购买类型";
    }
    else if (_currentType == OrderTypeProcurementRent) {
        type = @"代租赁类型";
    }
    else {
        type = @"批购类型";
    }
    NSLog(@"%@加载状态%d订单",type,_currentStatus);
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@",_numberField.text);
    
    [NetworkInterface getOrderListWithAgentID:delegate.agentUserID token:delegate.token orderType:_currentType keyword:_numberField.text status:_currentStatus page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_orderItem removeAllObjects];
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
                    [self parseOrderListWithDictionary:object];
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

- (void)parseOrderListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id orderList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([orderList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [orderList count]; i++) {
            id orderDict = [orderList objectAtIndex:i];
            if ([orderDict isKindOfClass:[NSDictionary class]]) {
                OrderModel *model = [[OrderModel alloc] initWithParseDictionary:orderDict];
                [_orderItem addObject:model];
            }
        }
    }
    [self setupHeaderView];

    [self.tableView reloadData];
}

- (NSString *)stringForOrderStatus:(int)status {
    NSString *title = nil;
    if (_supplyType == SupplyGoodsProcurement) {
        //代购
        switch (status) {
            case ProcurementStatusAll:
                title = @"全部";
                break;
            case ProcurementStatusUnPaid:
                title = @"未付款";
                break;
            case ProcurementStatusPaid:
                title = @"已付款";
                break;
            case ProcurementStatusSend:
                title = @"已发货";
                break;
            case ProcurementStatusReview:
                title = @"已评价";
                break;
            case ProcurementStatusCancel:
                title = @"已取消";
                break;
            case ProcurementStatusClosed:
                title = @"交易关闭";
                break;
            default:
                break;
        }
    }
    else {
        //批购
        switch (status) {
            case WholesaleStatusAll:
                title = @"全部";
                break;
            case WholesaleStatusUnPaid:
                title = @"未付款";
                break;
            case WholesaleStatusPartPaid:
                title = @"已付定金";
                break;
            case WholesaleStatusFinish:
                title = @"已完成";
                break;
            case WholesaleStatusCancel:
                title = @"已取消";
                break;
            default:
                break;
        }
    }
    return title;
}

- (NSString *)stringForOrderType:(OrderType)type {
    NSString *title = nil;
    switch (type) {
        case OrderTypeProcurement:
            title = @"全部";
            break;
        case OrderTypeProcurementBuy:
            title = @"代购买";
            break;
        case OrderTypeProcurementRent:
            title = @"代租赁";
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    self.supplyType = (SupplyGoodsType)([_segmentControl selectedSegmentIndex] + 1);
}

- (IBAction)showOrderType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurement]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurement],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurementBuy]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurementBuy],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeProcurementRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectType:)
                                        selectedTitle:_typeLabel.text
                                                  tag:OrderTypeProcurementRent],
                                 nil];
    
    CGRect convertRect = [_typeButton convertRect:_typeButton.frame toView:self.view];
    CGRect rect = CGRectMake(_typeButton.frame.origin.x + _typeButton.frame.size.width / 2, convertRect.origin.y + convertRect.size.height + 5, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)showOrderStatus:(id)sender {
    NSMutableArray *listArray = nil;
    if (_supplyType == SupplyGoodsProcurement) {
        listArray = [NSMutableArray arrayWithObjects:
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusAll]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusAll],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusUnPaid]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusUnPaid],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusPaid]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusPaid],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusSend]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusSend],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusCancel]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusCancel],
                     [KxMenuItem menuItem:[self stringForOrderStatus:ProcurementStatusClosed]
                                    image:nil
                                   target:self
                                   action:@selector(selectStatus:)
                            selectedTitle:_statusLabel.titleLabel.text
                                      tag:ProcurementStatusClosed],
                     nil];
    }
    else {
        listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.titleLabel.text
                                                  tag:WholesaleStatusAll],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusUnPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.titleLabel.text
                                                  tag:WholesaleStatusUnPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusPartPaid]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.titleLabel.text
                                                  tag:WholesaleStatusPartPaid],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusFinish]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.titleLabel.text
                                                  tag:WholesaleStatusFinish],
                                 [KxMenuItem menuItem:[self stringForOrderStatus:WholesaleStatusCancel]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.titleLabel.text
                                                  tag:WholesaleStatusCancel],
                                 nil];

    }
    CGRect convertRect = [_statusLabel convertRect:_statusLabel.frame toView:self.view];
    CGRect rect = CGRectMake(_statusLabel.frame.origin.x + _statusLabel.frame.size.width / 2, convertRect.origin.y + convertRect.size.height , 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentStatus = (int)item.tag;
    [self firstLoadData];
}

- (IBAction)selectType:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    self.currentType = (OrderType)item.tag;
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_orderItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItem objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifierWithSupplyType:_supplyType];
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[ OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier supplyType:_supplyType];
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    cell.delegate = self;
    [cell setContentsWithData:model];
    cell.userInteractionEnabled=YES;

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

    UILabel* linlable  = [[UILabel alloc] initWithFrame:CGRectMake(60, 178, wide-120, 1)];
    
    
    linlable.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    
    [cell.contentView addSubview:linlable];
    
    UILabel* linlable0  = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, wide-120, 1)];
    
    
    linlable0.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    
    [cell.contentView addSubview:linlable0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = [_orderItem objectAtIndex:indexPath.section];
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.hidesBottomBarWhenPushed=YES;
    
    
    detailC.goodID = model.orderGood.goodID;
    detailC.goodName = model.orderGood.goodName;
    detailC.fromType = PayWayFromNone;
    
    
    
    detailC.supplyType = _supplyType;
    NSLog(@"%@", model.orderID);

    detailC.orderID = model.orderID;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
        return kOrderLongCellHeight + 10;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
//取消批购订单
- (void)cancelWholesaleOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelWholesaleOrderWithToken:delegate.token orderID:_selectedOrder.orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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

//取消代购订单
- (void)cancelProcurementOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelProcurementOrderWithToken:delegate.token orderID:_selectedOrder.orderID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
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

#pragma mark - CellDelegate

//批购
- (void)orderCellCancelWholesaleOrder:(OrderModel *)model {
    _selectedOrder = model;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag=1022;
    
    [alert show];
}

- (void)orderCellPayWholesaleOrder:(OrderModel *)model
{
    _selectedOrder = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"填写付款金额"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagPayMoney;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
 
}

- (void)orderCellPayDepositOrder:(OrderModel *)model
{
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = model.orderID;
    payC.totalPrice = model.totalDeposit;
    payC.fromType = PayWayFromOrderWholesale;
    payC.goodID = model.orderGood.goodID;
    payC.goodName = model.orderGood.goodName;
    payC.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:payC animated:YES];

}

- (void)orderCellWholesaleRepeat:(OrderModel *)model {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:1]] boolValue]) {
        GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
        detailC.supplyType = SupplyGoodsWholesale;
        detailC.goodID = model.orderGood.goodID;
        detailC.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有批购权限";
    }

}

//代购
- (void)orderCellCancelProcurementOrder:(OrderModel *)model

{
    _selectedOrder = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag=1026;
    
    [alert show];

}

- (void)orderCellPayProcurementOrder:(OrderModel *)model {
 
  
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    
    payC.orderID = model.orderID;
    payC.totalPrice = model.actualMoney;
    payC.fromType = PayWayFromOrderProcurement;
    payC.goodID =  model.orderGood.goodID;;
    payC.hidesBottomBarWhenPushed=YES;
    
    payC.goodName =  model.orderGood.goodName;
    [self.navigationController pushViewController:payC animated:YES];

    
    
    
    
    
  
    
    
  
    
    
    
    
    
}

- (void)orderCellProcurementRepeat:(OrderModel *)model {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:2]] boolValue]) {
        GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
        detailC.supplyType = SupplyGoodsProcurement;
        detailC.goodID = model.orderGood.goodID;
        detailC.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:detailC animated:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"没有代购权限";
    }

}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag==1022||alertView.tag==1026)
    {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (_supplyType == SupplyGoodsWholesale) {
                //批购
                [self cancelWholesaleOrder];
            }
            else {
                //代购
                [self cancelProcurementOrder];
            }

    
    
    
    }
       }
    else {
        //支付
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (![RegularFormat isFloat:textField.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入数字";
            return;
        }
        if ([textField.text floatValue] <= 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"输入金额必须大于0";
            return;
        }
        if ([textField.text floatValue] > _selectedOrder.totalMoney) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"金额必须小于剩余金额";
            return;
        }
        PayWayViewController *payC = [[PayWayViewController alloc] init];
        payC.orderID = _selectedOrder.orderID;
        payC.totalPrice = [textField.text floatValue];
        payC.fromType = PayWayFromOrderWholesale;
        payC.goodID = _selectedOrder.orderGood.goodID;
        payC.goodName = _selectedOrder.orderGood.goodName;
        payC.hidesBottomBarWhenPushed=YES;
        payC.isPayPartMoney = YES;  //部分付款

        [self.navigationController pushViewController:payC animated:YES];
    }


}

#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    [self firstLoadData];
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
