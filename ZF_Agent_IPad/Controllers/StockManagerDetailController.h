//
//  StockManagerDetailController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//
#import "StockManagerController.h"
#import "RefreshViewController.h"
#import "StockListModel.h"

@interface StockManagerDetailController : RefreshViewController

@property(nonatomic,strong)StockListModel *stockModel;

@end
