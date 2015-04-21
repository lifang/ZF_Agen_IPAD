//
//  PayWayViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//订单、购物车、商品详情、维修记录可跳转此类

@interface PayWayViewController : CommonViewController

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) NSString *orderID;

@end
