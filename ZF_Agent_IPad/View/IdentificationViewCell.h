//
//  IdentificationViewCell.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentificationViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** POS机 */
@property(nonatomic,strong)UILabel *posLabel;
/** 支付通道 */
@property(nonatomic,strong)UILabel *payRoad;
/** 开通状态 */
@property(nonatomic,strong)UILabel *dredgeStatus;
/** 申请开通 */
@property(nonatomic,strong)UIButton *applicationBtn;

@property(nonatomic,strong)UIButton *videoConfirmBtn;

@end
