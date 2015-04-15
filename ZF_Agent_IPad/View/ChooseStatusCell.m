//
//  ChooseStatusCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ChooseStatusCell.h"

@implementation ChooseStatusCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ChooseStatusCell";
    ChooseStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ChooseStatusCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColor(220, 220, 220, 1.0);
        [self initAndLayoutUI];
    }
    return self;
}

-(void)initAndLayoutUI
{
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:18];
    _statusLabel.frame = CGRectMake(10, 5, 100, 30);
    [self.contentView addSubview:_statusLabel];
}

@end
