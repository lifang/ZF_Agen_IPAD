//
//  StockManagerDetailCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockAgentModel.h"

@interface StockManagerDetailCell : UITableViewCell

/** 下级代理商名字 */
@property(nonatomic,strong)UILabel *stockDetailNameLabel;
/** 配货总量 */
@property(nonatomic,strong)UILabel *stockDetailShopCountLabel;
/** 已开通数量 */
@property(nonatomic,strong)UILabel *stockDetailOpenCountLabel;
/** 上次配货日期 */
@property(nonatomic,strong)UILabel *stockDetailShopDateLabel;
/** 上次开通日期 */
@property(nonatomic,strong)UILabel *stockDetailOpenDateLabel;

@property(nonatomic,strong)StockAgentModel *agentModel;

-(void)setContentWithData:(StockAgentModel *)model;

@end
