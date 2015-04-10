//
//  UserManagerTerminalCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define userManagerTerminalCellHeight

@interface UserManagerTerminalCell : UITableViewCell

//初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UILabel *terminalLabel;

@end
