//
//  OrderConfirmController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "OrderDetailCell.h"
#import "AddressModel.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
//#import "PayWayViewController.h"

typedef enum {
    BillTypeCompany,
    BillTypePerson,
}BillType;

typedef enum {
    PushFromShoppingCart, //从购物车跳转
    PushFromGoodDetailBuy,   //从商品详情购买
    PushFormGoodDetailRent,    //从商品详情租赁
}PushWay;

static NSString *RefreshShoppingCartNotification = @"RefreshShoppingCartNotification";

@interface OrderConfirmController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray*addressarry;
}


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *addressView;   //地址view

@property (nonatomic, strong) UILabel *nameLabel;  //收件人

@property (nonatomic, strong) UILabel *phoneLabel;  //手机

@property (nonatomic, strong) UILabel *addressLabel;  //地址

@property (nonatomic, strong) UIButton *billBtn;   //是否需要发票按钮

@property (nonatomic, strong) UITextField *billField;  //发票抬头

@property (nonatomic, assign) BillType billType;

@property (nonatomic, assign) PushWay pushWay;

@property (nonatomic, strong) AddressModel *defaultAddress;

@property (nonatomic, strong) UITextField *reviewField;  //留言

@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *deliveryLabel;

@end
