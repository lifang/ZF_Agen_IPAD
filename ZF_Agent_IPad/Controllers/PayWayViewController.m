//
//  PayWayViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PayWayViewController.h"
#import "NetworkInterface.h"
#import "AlipayHelper.h"
#import "OrderDetailController.h"


@interface PayWayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *payNumber;  //支付单号

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getOrderInfo];

    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"选择支付方式";
    NSLog(@"!!!!!!!!!!%@~~~~~~~~~~~~~%f",_orderID,_totalPrice);
    
}
- (void)getOrderInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";

    
    [NetworkInterface orderConfirmWithOrderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self parseOrderDataWithDictionary:object];
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

- (void)parseOrderDataWithDictionary:(NSDictionary *)dict {
    NSLog(@"%f",_totalPrice);

    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoDict = [dict objectForKey:@"result"];
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        if (_fromType == PayWayFromGoodWholesale || _fromType == PayWayFromOrderWholesale) {
            _totalPrice = [[infoDict objectForKey:@"price_dingjin"] floatValue] / 100;
        }
        else {
            _totalPrice = [[infoDict objectForKey:@"order_totalPrice"] floatValue] / 100;
        }
        _payNumber = [infoDict objectForKey:@"order_number"];
    }
    
    [self setHeaderAndFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    CGFloat hearderHeight = 160.f;
    CGFloat blackViewHeight = 130.f;
    UIView *headerView = [[UIView alloc] init];
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
    


      headerView.frame=CGRectMake(0, 0, wide, hearderHeight+20);
        
    

//    headerView.backgroundColor = kColor(244, 243, 243, 1);
    [self.view addSubview:headerView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, blackViewHeight+20)];
    blackView.backgroundColor = kColor(33, 32, 42, 1);
    [headerView addSubview:blackView];
    
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, topSpace, wide - leftSpace - rightSpace, 20.f)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = @"付款金额";
    [blackView addSubview:infoLabel];
    //金额
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 60, wide - leftSpace - rightSpace, 60.f)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont boldSystemFontOfSize:48.f];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
    [blackView addSubview:priceLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, hearderHeight +40, wide - leftSpace - rightSpace, 20.f)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = kColor(150, 150, 150, 1);
    typeLabel.font = [UIFont systemFontOfSize:14.f];
    typeLabel.text = @"选择支付方式";
    [self.view addSubview:typeLabel];
    
    
    
    UIButton *zhifubao = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [zhifubao addTarget:self action:@selector(zhifubaoclick) forControlEvents:UIControlEventTouchUpInside];
    [zhifubao setBackgroundImage:[UIImage imageNamed:@"zhifubao"] forState:UIControlStateNormal];
    zhifubao.frame = CGRectMake(0,0,200,62);
    zhifubao.center=CGPointMake(wide/4, hearderHeight +40+100);
    zhifubao.userInteractionEnabled=YES;
    
    [self.view addSubview:zhifubao];
    
    
    
    UIButton *yinlianbutton = [[UIButton alloc]init];
    
    [yinlianbutton addTarget:self action:@selector(yinlianclick) forControlEvents:UIControlEventTouchUpInside];
    yinlianbutton.backgroundColor = [UIColor clearColor];
    [yinlianbutton setBackgroundImage:[UIImage imageNamed:@"yinlian"] forState:UIControlStateNormal];
    yinlianbutton.frame = CGRectMake(0,0,200,62);
    yinlianbutton.center=CGPointMake(wide/4*3, hearderHeight +40+80);
    
    [headerView addSubview:yinlianbutton];
    headerView.userInteractionEnabled=YES;
    

}
-(void)zhifubaoclick
{
    //支付宝
    if (_payNumber) {
        [AlipayHelper alipayWithOrderNumber:_payNumber goodName:_goodName totalPrice:_totalPrice payResult:^(NSDictionary *resultDict) {
            int resultCode = [[resultDict objectForKey:@"resultStatus"] intValue];
            NSString *tipString = @"";
            if (resultCode == 9000) {
                //                [self performSelector:@selector(updatOrderAfterPay) withObject:nil afterDelay:0.1f];
                tipString = @"订单支付成功";
                [self performSelector:@selector(showDetail) withObject:nil afterDelay:0.5];
            }
            else {
                if (resultCode == 8000) {
                    tipString = @"正在处理中";
                }
                else if (resultCode == 4000) {
                    tipString = @"订单支付失败";
                }
                else if (resultCode == 6001) {
                    tipString = @"用户中途取消";
                }
                else if (resultCode == 6002) {
                    tipString = @"网络连接出错";
                }
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = tipString;
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"获取订单号失败";
    }


}
- (void)showDetail {
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.fromType = _fromType;
    detailC.orderID = _orderID;
    detailC.goodID = _goodID;
    detailC.goodName = _goodName;
    if (_fromType == PayWayFromOrderWholesale ||
        _fromType == PayWayFromGoodWholesale)
    {
        detailC.supplyType = SupplyGoodsWholesale;
    }
    else if (_fromType == PayWayFromOrderProcurement ||
             _fromType == PayWayFromGoodProcurementBuy ||
             _fromType == PayWayFromGoodProcurementRent) {
        detailC.supplyType = SupplyGoodsProcurement;
    }
    [self.navigationController pushViewController:detailC animated:YES];
}

-(void)yinlianclick
{
    
    
}
//- (void)initAndLauoutUI {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.backgroundColor = kColor(244, 243, 243, 1);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self setHeaderAndFooterView];
//    [self.view addSubview:_tableView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//}
//
//#pragma mark - UITableView
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    NSString *title = nil;
//    switch (indexPath.section) {
//        case 0:
//            title = @"支付宝";
//            break;
//        case 1:
//            title = @"银联";
//            break;
//        default:
//            break;
//    }
//    cell.textLabel.text = title;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5.f;
//}

@end
