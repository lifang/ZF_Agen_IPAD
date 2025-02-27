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
#import "OrderManagerController.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPayPlugin.h"


#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"



@interface PayWayViewController ()<UIActionSheetDelegate>
{
 UIAlertView* _alertView;
}
@property (nonatomic, strong) NSString *payNumber;  //支付单号
@property (nonatomic, assign) CGFloat remainPrice;  //剩余金额 批购付款用到

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy)NSString *tnMode;//环境

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_fromType == PayWayFromGoodWholesale || _fromType == PayWayFromOrderWholesale) {
        [self getOrderInfo];
    }
    else {
        [self getProcurementOrderInfo];
    }
 
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"选择支付方式";
    NSLog(@"!!!!!!!!!!%@~~~~~~~~~~~~~%f",_orderID,_totalPrice);
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;
    UIImage *image=[UIImage imageNamed:@"back_btn_white"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 25, 40);
    
    [btn setImage :image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,backItem,spaceItem,nil];
    
    // Do any additional setup after loading the view.
}
//代购
- (void)getProcurementOrderInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface payProcurementWithOrderID:_orderID finished:^(BOOL success, NSData *response) {
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
                    [self parseProcurementDataWithDictionary:object];
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
//代购
- (void)parseProcurementDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoDict = [dict objectForKey:@"result"];
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        _totalPrice = [[infoDict objectForKey:@"total_price"] floatValue] / 100;
        _payNumber = [infoDict objectForKey:@"order_number"];
    }
    
    [self setHeaderAndFooterView];

}

-(void)popself

{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"放弃付款？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self showDetail];
    }
}

#pragma mark - 跳转详情
- (void)showDetail {
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.fromType = _fromType;
    detailC.orderID = _orderID;
    detailC.goodID = _goodID;
    detailC.goodName = _goodName;
    if (_fromType == PayWayFromOrderWholesale ||
        _fromType == PayWayFromGoodWholesale) {
        detailC.supplyType = SupplyGoodsWholesale;
    }
    else if (_fromType == PayWayFromOrderProcurement ||
             _fromType == PayWayFromGoodProcurementBuy ||
             _fromType == PayWayFromGoodProcurementRent) {
        detailC.supplyType = SupplyGoodsProcurement;
    }
    detailC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:detailC animated:YES];
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
    payMoney = _totalPrice;

    if ([infoDict isKindOfClass:[NSDictionary class]])
    {
        if (_fromType == PayWayFromGoodWholesale || _fromType == PayWayFromOrderWholesale) {
            payMoney = [[infoDict objectForKey:@"price_dingjin"] floatValue] / 100;
            _remainPrice = [[infoDict objectForKey:@"shengyu_price"] floatValue] / 100;        }
        else {
            payMoney = [[infoDict objectForKey:@"order_totalPrice"] floatValue] / 100;
        }
        _payNumber = [infoDict objectForKey:@"order_number"];
    }
    if (_isPayPartMoney)
    {
        payMoney = _totalPrice;
    }
    _totalPrice = payMoney;

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
    zhifubao.frame = CGRectMake(0,0,400,122);
    zhifubao.center=CGPointMake(wide/4, hearderHeight +60+100);
    zhifubao.userInteractionEnabled=YES;
    
    [self.view addSubview:zhifubao];
    
    
    
    UIButton *yinlianbutton = [[UIButton alloc]init];
    
    [yinlianbutton addTarget:self action:@selector(yinlianclick) forControlEvents:UIControlEventTouchUpInside];
    yinlianbutton.backgroundColor = [UIColor clearColor];
    [yinlianbutton setBackgroundImage:[UIImage imageNamed:@"yinlians"] forState:UIControlStateNormal];
    yinlianbutton.frame = CGRectMake(0,0,400,122);
    yinlianbutton.center=CGPointMake(wide/4*3, hearderHeight +60+100);
    
    [self.view addSubview:yinlianbutton];
    headerView.userInteractionEnabled=YES;
    

}
-(void)zhifubaoclick
{
    //支付宝
    if (_payNumber) {
        
        BOOL isWholesale = NO;
        if (_fromType == PayWayFromGoodWholesale || _fromType == PayWayFromOrderWholesale) {
            isWholesale = YES;
        }
        [AlipayHelper alipayWithOrderNumber:_payNumber goodName:_goodName totalPrice:_totalPrice isWholesale:isWholesale payResult:^(NSDictionary *resultDict) {

            int resultCode = [[resultDict objectForKey:@"resultStatus"] intValue];
            NSString *tipString = @"";
            if (resultCode == 9000) {
                //                [self performSelector:@selector(updatOrderAfterPay) withObject:nil afterDelay:0.1f];
                tipString = @"订单支付成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];

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

-(void)yinlianclick
{
    NSLog(@"UnionPay");
    _tnMode = kMode_Production;
    [self startUnionPayRequest];
    
}


#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}


- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [_alertView show];
    
}

- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    
    if ([result isEqualToString:@"success"]) {
        [self UnionPaySucess];
    }
    if ([result isEqualToString:@"fail"]) {
        [self showAlertMessage:@"支付失败"];
    }
    if ([result isEqualToString:@"cancel"]) {
        [self showAlertMessage:@"取消支付"];
    }
}



-(void)startUnionPayRequest
{
    [self showAlertWait];
    
    
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:kUnionPayURL]];
    
    NSString *Price=[NSString stringWithFormat:@"%.0f", _totalPrice*100];
    NSString *str = [NSString stringWithFormat:@"frontOrBack=back&orderId=%@&txnAmt=%@&wap=wap&txnType=01&android=android", _payNumber,Price];
    NSLog(@"payNumner:%@",_payNumber);
    //设置参数
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //解析data
        if (data) {//请求成功
            [self hideAlert];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict:%@",dict);
            
            NSString *error=dict[@"error"];
            if (error) {
                [self showAlertMessage:kErrorNet];
            }else
            {
                NSString* tn = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (tn != nil && tn.length > 0)
                {
                    NSLog(@"tn=%@",tn);
                    [UPPayPlugin startPay:tn mode:_tnMode viewController:self delegate:self];
                }
                
            }
        }else   //请求失败
        {
            [self showAlertMessage:kErrorNet];
        }
        
    }];
    
    
}


-(void)UnionPaySucess
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.customView = [[UIImageView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1.f];
    hud.labelText = @"订单支付成功";
    
    [self performSelector:@selector(goDetail) withObject:nil afterDelay:5];
    
    
}




-(void)goDetail
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshOrderListNotification object:nil];
    [self showDetail];
    
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
