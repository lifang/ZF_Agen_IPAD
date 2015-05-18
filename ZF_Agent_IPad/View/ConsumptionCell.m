//
//  ConsumptionCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ConsumptionCell.h"

@implementation ConsumptionCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ConsumptionCell";
    ConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ConsumptionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
        
        self.settleLabel = [[UILabel alloc]init];
        _settleLabel.textAlignment = NSTextAlignmentCenter;
        _settleLabel.font = mainFont;
        _settleLabel.textColor = mainColor;
        [self addSubview:_settleLabel];
        
        self.poundageLabel = [[UILabel alloc]init];
        _poundageLabel.textAlignment = NSTextAlignmentCenter;
        _poundageLabel.font = mainFont;
        _poundageLabel.textColor = mainColor;
        [self addSubview:_poundageLabel];
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.textAlignment = NSTextAlignmentCenter;
        _terminalLabel.font = mainFont;
        _terminalLabel.textColor = mainColor;
        [self addSubview:_terminalLabel];
        
        self.dealMoney = [[UILabel alloc]init];
//        _dealStates.textAlignment = NSTextAlignmentCenter;
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
    
    _settleLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) - 20, mainY, 180, mainY);
    
    _poundageLabel.frame = CGRectMake(CGRectGetMaxX(_settleLabel.frame) - 130, mainY, 180, mainY);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_poundageLabel.frame) + 30, mainY, 200, mainY);
    
    _dealMoney.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 70, mainY, 200, mainY);
    
    _dealStates.frame = CGRectMake(CGRectGetMaxX(_dealMoney.frame) - 50, mainY, 110, mainY);
    
}

@end
