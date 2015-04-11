//
//  TerminalChoseCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalChoseCell.h"

@implementation TerminalChoseCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TerminalChoseCell";
    TerminalChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TerminalChoseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColor(212, 212, 212, 1.0);
    }
    return self;
}

@end
