//
//  UserManagerTerminalCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerTerminalCell.h"

@implementation UserManagerTerminalCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UserManagerTerminalCell";
    UserManagerTerminalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UserManagerTerminalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAndLayoutUI];
    }
    return self;
}

-(void)initAndLayoutUI
{
    _terminalLabel = [[UILabel alloc]init];
    _terminalLabel.textAlignment = NSTextAlignmentCenter;
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.font = [UIFont systemFontOfSize:15];
    _terminalLabel.frame = CGRectMake(40, -5, 180, 25);
    [self.contentView addSubview:_terminalLabel];
}

@end
