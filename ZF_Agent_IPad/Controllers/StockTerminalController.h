//
//  StockTerminalController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "RefreshViewController.h"
#import "StockAgentModel.h"
#import "StockListModel.h"

@interface StockTerminalController : RefreshViewController

@property (nonatomic, strong) StockAgentModel *stockAgentModel;

@property (nonatomic, strong) StockListModel *stockModel;

@end
