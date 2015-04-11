//
//  TransferCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TransferCell.h"

@implementation TransferCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TransferCell";
    TransferCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TransferCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        UIColor *mainColor = kColor(67, 67, 67, 1.0);
        
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = mainFont;
        _timeLabel.textColor = mainColor;
        [self addSubview:_timeLabel];
        
        self.payLabel = [[UILabel alloc]init];
        _payLabel.textAlignment = NSTextAlignmentCenter;
        _payLabel.font = mainFont;
        _payLabel.textColor = mainColor;
        [self addSubview:_payLabel];
        
        self.getLabel = [[UILabel alloc]init];
        _getLabel.textAlignment = NSTextAlignmentCenter;
        _getLabel.font = mainFont;
        _getLabel.textColor = mainColor;
        [self addSubview:_getLabel];
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.textAlignment = NSTextAlignmentCenter;
        _terminalLabel.font = mainFont;
        _terminalLabel.textColor = mainColor;
        [self addSubview:_terminalLabel];
        
        self.dealMoney = [[UILabel alloc]init];
        _dealMoney.textAlignment = NSTextAlignmentCenter;
        _dealMoney.font = mainFont;
        _dealMoney.textColor = mainColor;
        [self addSubview:_dealMoney];
        
        self.dealStates = [[UILabel alloc]init];
        _dealStates.textAlignment = NSTextAlignmentCenter;
        _dealStates.font = mainFont;
        _dealStates.textColor = mainColor;
        [self addSubview:_dealStates];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainY = 25.f;

    _timeLabel.frame = CGRectMake(30, mainY, 180, mainY);
    
    _payLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) - 10, mainY, 180, mainY);
    
    _getLabel.frame = CGRectMake(CGRectGetMaxX(_payLabel.frame) - 10, mainY, 180, mainY);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_getLabel.frame) - 30, mainY, 200, mainY);
    
    _dealMoney.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 10, mainY, 100, mainY);
    
    _dealStates.frame = CGRectMake(CGRectGetMaxX(_dealMoney.frame) + 70, mainY, 50, mainY);
    
}

@end
