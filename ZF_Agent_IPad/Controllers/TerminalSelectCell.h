//
//  TerminalSelectCell.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalSelectModel.h"

@interface TerminalSelectCell : UITableViewCell

@property(strong,nonatomic) UIView * backView;

@property(strong,nonatomic) UILabel * terminalLB;

@property(strong,nonatomic) UILabel * priceLB;


@property(strong,nonatomic) TerminalSelectModel * TerminalSelectModel;

@property(weak,nonatomic) id superTarget;

-(void)setTerminalSelectModel:(TerminalSelectModel *)TerminalSelectModel andTarget:(id)target;

@end
