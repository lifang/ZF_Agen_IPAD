//
//  OrderDetailController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailController.h"
#import "AppDelegate.h"
#import "OrderDetailModel.h"
#import "RecordView.h"
#import "StringFormat.h"
#import "OrderDetailCell.h"
#import "OrderManagerController.h"
#import "PayWayViewController.h"
#import "RegularFormat.h"
#import "GoodDetailViewController.h"
#import "GoodListViewController.h"


typedef enum {
    OrderDetailBtnStyleFirst = 1,
    OrderDetailBtnStyleSecond,
}OrderDetailBtnStyle; //按钮样式

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%d",self.fromType);
    
    // Do any additional setup after loading the view.
//    if (self.fromType == PayWayFromGoodProcurementBuy) {
        self.title = @"订单详情";
//    }
//    else {
//        self.title = @"租赁订单详情";
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadDetail];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;
    UIImage *image=[UIImage imageNamed:@"back_btn_white"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 25, 40);
    
    [btn setImage :image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goPervious:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,backItem,spaceItem,nil];
    self.view.backgroundColor=[UIColor whiteColor];
    
}
- (IBAction)goPervious:(id)sender {
    if (_fromType == PayWayFromNone) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_fromType == PayWayFromOrderProcurement ||
             _fromType == PayWayFromOrderWholesale) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[OrderManagerController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (_fromType == PayWayFromGoodWholesale ||
             _fromType == PayWayFromGoodProcurementBuy ||
             _fromType == PayWayFromGoodProcurementRent) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[GoodListViewController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    
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

    //追踪记录
    if ([_orderDetail.recordList count] > 0) {
        CGFloat leftSpace = 50.f;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 20, wide - leftSpace * 2 , 14)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:_orderDetail.recordList
                                                               width:(wide - leftSpace * 2)];
        CGFloat recordHeight = [recordView getHeight];
        recordView.frame = CGRectMake(leftSpace, 34, wide - leftSpace * 2, recordHeight);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, recordHeight + 40)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        [footerView addSubview:recordView];
        _tableView.tableFooterView = footerView;
        [recordView initAndLayoutUI];
    }
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:line];
   }

- (void)initAndLayoutUI {
    CGFloat footerHeight = 0.f;
//    if ((_supplyType == SupplyGoodsWholesale && (_orderDetail.orderStatus == WholesaleStatusUnPaid ||
//                                                 _orderDetail.orderStatus == WholesaleStatusPartPaid ||
//                                                 _orderDetail.orderStatus == WholesaleStatusFinish)) ||
//        (_supplyType == SupplyGoodsProcurement && (_orderDetail.orderStatus == ProcurementStatusUnPaid ||
//                                                   _orderDetail.orderStatus == ProcurementStatusSend ||
//                                                   _orderDetail.orderStatus == ProcurementStatusCancel ||
//                                                   _orderDetail.orderStatus == ProcurementStatusClosed))) {
//        footerHeight = 60.f;
//        //底部按钮
//       
//        
//    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];

//    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    if (kDeviceVersion >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-0]];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(OrderDetailBtnStyle)style {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (style == OrderDetailBtnStyleFirst) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kMainColor.CGColor;
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setLabel:(UILabel *)label withString:(NSString *)string {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.text = string;
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getOrderDetailWithToken:delegate.token orderType:_supplyType orderID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parseOrderDetailWithDictionary:object];
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

//取消批购订单
- (void)cancelWholesaleOrder {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface cancelWholesaleOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self goPervious:nil];
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
    [NetworkInterface cancelProcurementOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self goPervious:nil];
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

- (void)parseOrderDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _orderDetail = [[OrderDetailModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    
    [self initAndLayoutUI];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = [_orderDetail.goodList count] + 2;
            break;
        default:
            break;
    }
    return row;
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

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UITableViewCell *cell = nil;
    CGFloat originX = 50.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 18, 18)];
                    statusView.image = kImageName(@"order.png");
                    [cell.contentView addSubview:statusView];
                    //状态
                    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX , 10, wide / 2, 20.f)];
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.font = [UIFont boldSystemFontOfSize:16.f];
                    statusLabel.text = [NSString stringWithFormat:@"订单状态:  %@",[_orderDetail getStatusStringWithSupplyType:_supplyType]];
                    [cell.contentView addSubview:statusLabel];
                    //批购
                    if (_supplyType == SupplyGoodsWholesale) {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        //定金总额
                        UILabel *totalDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide / 2 - originX, 20.f)];
                        [self setLabel:totalDepositLabel withString:[NSString stringWithFormat:@"定金总额：￥%.2f",_orderDetail.totalDeposit]];
                        [cell.contentView addSubview:totalDepositLabel];
                        //已发货数量
                        UILabel *shipmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 50, wide / 2 - originX, 20)];
                        [self setLabel:shipmentLabel withString:[NSString stringWithFormat:@"已发货数量：%d",_orderDetail.shipmentCount]];
                        [cell.contentView addSubview:shipmentLabel];
                        //已付定金
                        UILabel *paidDepositLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 70, wide / 2 - originX, 20)];
                        [self setLabel:paidDepositLabel withString:[NSString stringWithFormat:@"已付定金：￥%.2f",_orderDetail.paidDeposit]];
                        [cell.contentView addSubview:paidDepositLabel];
                        //剩余货品数量
                        UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 70, wide / 2 - originX, 20)];
                        [self setLabel:remainLabel withString:[NSString stringWithFormat:@"剩余货品总数：%d",_orderDetail.totalCount - _orderDetail.shipmentCount]];
                        [cell.contentView addSubview:remainLabel];
                    }
                    else {
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide * 0.6 - originX, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额 ：￥%.2f",_orderDetail.actualPrice]];
                        [cell.contentView addSubview:payLabel];
                        
                        UILabel *openmoney = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide * 0.6 - originX, 20.f)];
                        [self setLabel:openmoney withString:[NSString stringWithFormat:@"开  通  费：￥%.2f",_orderDetail.orderDeliveryFee]];
                        [cell.contentView addSubview:openmoney];
                        
                        UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(wide * 0.4, 15, 1, 30)];
                        vLine.image = kImageName(@"gray.png");
                        [cell.contentView addSubview:vLine];
                        
                        //归属用户
                        UILabel *belongLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide * 0.4 + 5, 10, wide * 0.4 - originX, 20)];
                        [self setLabel:belongLabel withString:@"归属用户："];
                        [cell.contentView addSubview:belongLabel];
                        
                        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide * 0.4 + 5, 30, wide * 0.4 - originX, 20)];
                        [self setLabel:userLabel withString:_orderDetail.belongUser];
                        NSLog(@"%@",_orderDetail.belongUser);
                        
                        [cell.contentView addSubview:userLabel];

                    }
                    
                    
                    
                    
                    
                    CGFloat middleSpace = 10.f;
                    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
                    CGFloat btnHeight = 36.f;
                    if (_supplyType == SupplyGoodsWholesale) {
                        //批购
                        if (_orderDetail.orderStatus == WholesaleStatusUnPaid) {
                            
                            if (_orderDetail.payStatus == 2)
                            {
                                //已付定金
                                UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                                cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                                UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payWholesaleOrder:) style:OrderDetailBtnStyleSecond];
                                payBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                                [cell.contentView addSubview:payBtn];
                                [cell.contentView addSubview:cancelBtn];
                                
                            }
                            else
                            {
                                UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesaleOrder:) style:OrderDetailBtnStyleFirst];
                                cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                                UIButton *depositBtn = [self buttonWithTitle:@"支付定金" action:@selector(payDeposit:) style:OrderDetailBtnStyleSecond];
                                depositBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                                [cell.contentView addSubview:depositBtn];
                                [cell.contentView addSubview:cancelBtn];
                            
                            }
                            
                            
                            
                            
                            //未付款
                          
                        }
//                        else if (_orderDetail.orderStatus == WholesaleStatusPartPaid) {
//                            
//                        }
                        else if (_orderDetail.orderStatus == WholesaleStatusFinish) {
                            //再次批购
                            UIButton *repeatBtn = [self buttonWithTitle:@"再次采购" action:@selector(repeatWholesale:) style:OrderDetailBtnStyleSecond];
                            repeatBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            [cell.contentView addSubview:repeatBtn];
                        }
                    }
                    else {
                        //代购
                        if (_orderDetail.orderStatus == ProcurementStatusUnPaid) {
                            //未付款
                            UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelProcurementOrder:) style:OrderDetailBtnStyleFirst];
                            cancelBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payProcurementOrder:) style:OrderDetailBtnStyleSecond];
                            payBtn.frame = CGRectMake(wide-150-120, 12, 100, 40);
                            [cell.contentView addSubview:payBtn];
                            [cell.contentView addSubview:cancelBtn];
                        }
                        else if (_orderDetail.orderStatus == ProcurementStatusSend ||
                                 _orderDetail.orderStatus == ProcurementStatusCancel ||
                                 _orderDetail.orderStatus == ProcurementStatusClosed) {
                            //再次批购
                            UIButton *repeatBtn = [self buttonWithTitle:@"再次采购" action:@selector(repeatProcurement:) style:OrderDetailBtnStyleSecond];
                            repeatBtn.frame = CGRectMake(wide-150, 12, 100, 40);
                            [cell.contentView addSubview:repeatBtn];
                        }
                    }

                    
                    
                    
                    
                    
                    
                    
                }
                    break;
                case 1: {
                    //60
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //收件人
                    UILabel *receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2, 20.f)];
                    [self setLabel:receiverLabel withString:[NSString stringWithFormat:@"收件人：%@  %@",_orderDetail.receiver,_orderDetail.phoneNumber]];
                    [cell.contentView addSubview:receiverLabel];
                    //地址
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                    
                    if([self isBlankString:_orderDetail.address])
                    {
                        [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址："]];
                        
                        
                    }else
                    {
                        
                        [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址：%@",_orderDetail.address]];
                        
                        
                    }

                    
                    [cell.contentView addSubview:addressLabel];
                }
                    break;
                case 2: {
                    
                    CGFloat btnWidth = 80.f;
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //订单
                    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2 - btnWidth, 20)];
                    orderLabel.backgroundColor = [UIColor clearColor];
                    orderLabel.font = [UIFont systemFontOfSize:15.f];
//                    orderLabel.textColor = kColor(116, 116, 116, 1);
                    orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderNumber];
                    [cell.contentView addSubview:orderLabel];
                    
                    //支付方式
                    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2 - btnWidth, 20.f)];
                    typeLabel.backgroundColor = [UIColor clearColor];
                    typeLabel.font = [UIFont systemFontOfSize:15.f];
//                    typeLabel.textColor = kColor(116, 116, 116, 1);
                    
                    if([_orderDetail.payType  isEqualToString:@"1"])
                    {
                        typeLabel.text = [NSString stringWithFormat:@"支付方式 :支付宝"];

                    
                    }
                    if([_orderDetail.payType  isEqualToString:@"2"])
                    {
                        typeLabel.text = [NSString stringWithFormat:@"支付方式：银联"];
                        
                        
                    }

                    if([_orderDetail.payType  isEqualToString:@"3"])
                    {
                        typeLabel.text = [NSString stringWithFormat:@"支付方式：现金"];
                        
                        
                    }

                    
                    [cell.contentView addSubview:typeLabel];
                    //订单日期
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide - originX * 2 - btnWidth, 20)];
                    dateLabel.backgroundColor = [UIColor clearColor];
                    dateLabel.font = [UIFont systemFontOfSize:15.f];
//                    dateLabel.textColor = kColor(116, 116, 116, 1);
                    dateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_orderDetail.createTime];
                    [cell.contentView addSubview:dateLabel];

                    //留言
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat height = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:15.f] width:wide - originX * 2];
                    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10, wide/2, height)];
                    commentLabel.numberOfLines = 0;
                    [self setLabel:commentLabel withString:comment];
                    [cell.contentView addSubview:commentLabel];
                    //发票
                    NSString *invoiceTitle = _orderDetail.invoceTitle;
                    NSString *invoiceType = _orderDetail.invoceType;
                    if (_orderDetail.needInvoice == 0) {
                        invoiceTitle = @"无";
                        invoiceType = @"无";
                    }

                    UILabel *invoceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10 + height, wide/2, 20.f)];
                    [self setLabel:invoceTypeLabel withString:[NSString stringWithFormat:@"发票类型：%@",invoiceType]];
                    [cell.contentView addSubview:invoceTypeLabel];
                    UILabel *invoceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 30 + height, wide/2, 20.f)];
                    [self setLabel:invoceTitleLabel withString:[NSString stringWithFormat:@"发票抬头：%@",invoiceTitle]];
                    
                    [cell.contentView addSubview:invoceTitleLabel];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                //100
                CGFloat btnWidth = 80.f;
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(50, 10, wide-100, 20)];
                rootview.backgroundColor = kColor(235, 233, 233, 1);
                [cell.contentView addSubview: rootview];
                
                
                UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 60, 20)];
                [rootview addSubview:goodslable];
                goodslable.textAlignment = NSTextAlignmentCenter;
                goodslable.text=@"商品";
                
                
                UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-35, 0, 60, 20)];
                [rootview addSubview:phonelable];
                //                phonelable.textAlignment = NSTextAlignmentCenter;
                UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-200, 0, 80, 20)];
                [rootview addSubview:numberlable];
                //                numberlable.textAlignment = NSTextAlignmentCenter;
                
               
                    numberlable.text=@"购买数量";
                    
                    phonelable.text=@"单价";
                    
               
                
                
        
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                int goodCount = _orderDetail.totalCount;
                if (_supplyType == SupplyGoodsProcurement) {
                    goodCount = _orderDetail.proTotalCount;
                }
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                UILabel* linlable0  = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, wide-100, 1)];
                
                
                linlable0.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
                
                
                [cell.contentView addSubview:linlable0];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 15, wide / 2 - originX, 30)];
                totalLabel.backgroundColor = [UIColor clearColor];
                totalLabel.font = [UIFont systemFontOfSize:15.f];
                totalLabel.textAlignment = NSTextAlignmentRight;
                totalLabel.text = [NSString stringWithFormat:@"共计%d件商品",goodCount];
                [cell.contentView addSubview:totalLabel];
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide / 2, 15, wide / 2 - originX, 30)];
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.font = [UIFont systemFontOfSize:15.f];
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.text = [NSString stringWithFormat:@"实付金额:￥%.2f",_orderDetail.actualPrice];
                [cell.contentView addSubview:priceLabel];
                
                
                
                int status = _orderDetail.orderStatus ;
                if (status == WholesaleStatusPartPaid || status == WholesaleStatusFinish || status == ProcurementStatusPaid || status == ProcurementStatusSend || status == ProcurementStatusReview) {
                    UIButton *terminalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    terminalBtn.frame = CGRectMake(50, 5, 100, 30);
                    terminalBtn.layer.masksToBounds = YES;
                    terminalBtn.layer.borderWidth = 1.f;
                    terminalBtn.layer.borderColor = kColor(3, 112, 214, 1).CGColor;
                    [terminalBtn setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
                    [terminalBtn setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateHighlighted];
                    terminalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
                    [terminalBtn setTitle:@"查看终端号" forState:UIControlStateNormal];
                    [terminalBtn addTarget:self action:@selector(scanTerminalNumber:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.contentView addSubview:terminalBtn];
                    UIButton *logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    logisticsBtn.frame = CGRectMake(170, 5, 100, 30);
                    logisticsBtn.layer.masksToBounds = YES;
                    logisticsBtn.layer.borderWidth = 1.f;
                    logisticsBtn.layer.borderColor = kColor(3, 112, 214, 1).CGColor;
                    [logisticsBtn setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
                    [logisticsBtn setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateHighlighted];
                    logisticsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
                    [logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [logisticsBtn addTarget:self action:@selector(scanTerminalNumberhhhl) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.contentView addSubview:logisticsBtn];
                    
                }

                
                
                
            }
            else {
                static NSString *orderIdentifier = @"orderIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
                if (cell == nil) {
                    cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier supplyType:_supplyType];
                }
                OrderGoodModel *model = [_orderDetail.goodList objectAtIndex:indexPath.row - 1];
                [(OrderDetailCell *)cell setContentsWithData:model];
                UILabel*_openlable = [[UILabel alloc] initWithFrame:CGRectMake(wide/2-40 ,45, 150, 30)];
                //    _priceLabel.textColor = kColor(255, 102, 36, 1);
                _openlable.font = [UIFont boldSystemFontOfSize:13.f];
                _openlable.textAlignment = NSTextAlignmentCenter;
                _openlable.text = [NSString stringWithFormat:@"(含开通费￥%.2f)",model.good_opening_cost];

                [cell addSubview:_openlable];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)scanTerminalNumberhhhl
{

    if([self isBlankString:_orderDetail.logisticCompany])
    {
        
        _orderDetail.logisticCompany=@"暂无物流公司";
        
        
        
    }
    
    if([self isBlankString:_orderDetail.logisticNumber])
    {
        
        _orderDetail.logisticNumber=@"暂无物流单号";
        
        
        
    }



    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"物流信息"
                                                    message:[NSString stringWithFormat:@"物流公司:%@,物流单号:%@",_orderDetail.logisticCompany,_orderDetail.logisticNumber]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

}
- (IBAction)scanTerminalNumber:(id)sender
{
    
    if([self isBlankString:_orderDetail.terminals])
    {
        
        _orderDetail.terminals=@"暂无终端号";
        
        
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"终端号"
                                                    message:_orderDetail.terminals
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    height = 100.f;
                    if (_supplyType == SupplyGoodsProcurement) {
                        height = 80.f;
                    }
                }
                    break;
                case 1:
                    height = 60.f;
                    break;
                case 2: {
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.comment];
                    CGFloat commentHeight = [StringFormat heightForComment:comment withFont:[UIFont systemFontOfSize:13.f] width:kScreenWidth - 40];
                    height = commentHeight + 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                height = 50.f;
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                height = 60.f;
            }
            else {
                height = kOrderDetailCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001f;
    }
    else {
        return 1.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Action
//批购
- (IBAction)cancelWholesaleOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag=1028;
    
    [alert show];

    
}

//支付定金
- (IBAction)payDeposit:(id)sender
{
    PayWayViewController *payC = [[PayWayViewController alloc] init];
    
    payC.orderID = _orderDetail.orderID;
    payC.totalPrice = _orderDetail.totalDeposit;
    payC.fromType = PayWayFromOrderWholesale;
    payC.goodID = _goodID;
    payC.hidesBottomBarWhenPushed=YES;

    payC.goodName = _goodName;
    [self.navigationController pushViewController:payC animated:YES];
}

//付款
- (IBAction)payWholesaleOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                            message:@"填写付款金额"
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"取消"
                                                                                  otherButtonTitles:@"确定", nil];
    alert.tag = AlertTagPayMoney;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

    
}

//再次批购
- (IBAction)repeatWholesale:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:1]] boolValue]) {
        GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
        detailC.supplyType = SupplyGoodsWholesale;
        detailC.hidesBottomBarWhenPushed=YES;

        detailC.goodID = _goodID;
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
- (IBAction)cancelProcurementOrder:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag=1026;
    
    [alert show];

}

//付款
- (IBAction)payProcurementOrder:(id)sender {
    NSLog(@"%@", _orderDetail.orderID);

    PayWayViewController *payC = [[PayWayViewController alloc] init];
    payC.orderID = _orderDetail.orderID;
    payC.totalPrice = _orderDetail.actualPrice;
    payC.fromType = PayWayFromOrderProcurement;
    payC.goodID = _goodID;
    payC.goodName = _goodName;
    payC.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:payC animated:YES];
}

//再次代购
- (IBAction)repeatProcurement:(id)sender {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:2]] boolValue]) {
        GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
        detailC.supplyType = SupplyGoodsProcurement;
        detailC.goodID = _goodID;
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1026)
    {
        
        if (buttonIndex != alertView.cancelButtonIndex) {
        
            [self cancelProcurementOrder];

        }
        

    
    }
   else if(alertView.tag==2)

    
    {
    
    
    
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (alertView.tag == AlertTagPayMoney) {
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
                if ([textField.text floatValue] > _orderDetail.actualPrice) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.customView = [[UIImageView alloc] init];
                    hud.mode = MBProgressHUDModeCustomView;
                    [hud hide:YES afterDelay:1.f];
                    hud.labelText = @"金额必须小于付款金额";
                    return;
                }
                PayWayViewController *payC = [[PayWayViewController alloc] init];
                payC.orderID = _orderDetail.orderID;
                payC.goodID = _goodID;
                payC.goodName = _goodName;
                payC.totalPrice = [textField.text floatValue];
                payC.fromType = PayWayFromOrderWholesale;
                payC.hidesBottomBarWhenPushed =  YES ;
                
                payC.isPayPartMoney = YES; //部分付款
                
                [self.navigationController pushViewController:payC animated:YES];
            }
        }

    
    
    
    
    }
    
   else if(alertView.tag==1028)
   {
       if (buttonIndex != alertView.cancelButtonIndex) {

       [self cancelWholesaleOrder];

   
       }
   }

   }


@end
