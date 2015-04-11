//
//  ConsumptionCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionCell : UITableViewCell

//初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView;

/** 交易时间 */
@property(nonatomic,strong)UILabel *timeLabel;
/** 结算时间 */
@property(nonatomic,strong)UILabel *settleLabel;
/** 手续费 */
@property(nonatomic,strong)UILabel *poundageLabel;
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 交易金额 */
@property(nonatomic,strong)UILabel *dealMoney;
/** 交易状态 */
@property(nonatomic,strong)UILabel *dealStates;

@end
