//
//  AfterSellCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSModel.h"

typedef enum {
    AfterSellTypeNone = 0,
    AfterSellTypeSell = 1,
    AfterSellTypeCancel = 2,
    AfterSellTypeUpdate = 3,
}AfterSellType;


@interface AfterSellCell : UITableViewCell
//初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView WithAfterSellType:(AfterSellType)type WithCsModel:(CSModel*)model;

@property(nonatomic,strong)UILabel *afterNum;

@property(nonatomic,strong)UILabel *terminalNum;

@property(nonatomic,strong)UILabel *dateLable;

@property(nonatomic,strong)UILabel *afterStatus;

@property(nonatomic,strong)CSModel *csModel;

-(void)setContentWithData:(CSModel *)model;

@end
