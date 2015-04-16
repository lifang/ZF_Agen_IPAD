//
//  DealRoadDetailController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/9.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"

@interface DealRoadDetailController : UIViewController

@property (nonatomic, assign) TradeType tradeType;

@property (nonatomic, strong) NSString *terminalNumber;

@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *nextid;

@end
