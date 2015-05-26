//
//  PayWayViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "UPPayPluginDelegate.h"

typedef enum {
    PayWayFromNone = 0,
    PayWayFromOrderWholesale,       //批购订单
    PayWayFromOrderProcurement,     //代购订单
    PayWayFromGoodWholesale,        //批购商品
    PayWayFromGoodProcurementBuy,   //代购买
    PayWayFromGoodProcurementRent,  //代租赁
}PayWayFromType;

//订单、购物车、商品详情、维修记录可跳转此类

@interface PayWayViewController : CommonViewController<UPPayPluginDelegate,UIAlertViewDelegate>
{    CGFloat payMoney ;


}
@property (nonatomic, assign) PayWayFromType fromType; //跳转来源

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, assign) BOOL isPayPartMoney;

@property (nonatomic, strong) NSString *goodName;
@end
