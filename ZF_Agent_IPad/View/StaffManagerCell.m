//
//  StaffManagerCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffManagerCell.h"

@implementation StaffManagerCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"StaffManagerCell";
    StaffManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[StaffManagerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
    CGFloat Maigin = 10.f;
    CGFloat labelH = 25.f;
    CGFloat labelW = 170.f;
    UIFont *mainFont = [UIFont systemFontOfSize:15.f];
    
    _loginIDLabel = [[UILabel alloc]init];
    _loginIDLabel.backgroundColor = [UIColor clearColor];
    _loginIDLabel.font = mainFont;
    _loginIDLabel.textAlignment = NSTextAlignmentCenter;
    _loginIDLabel.frame = CGRectMake(80, 20, labelW, labelH);
    [self.contentView addSubview:_loginIDLabel];
    
    _userNameLabel = [[UILabel alloc]init];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.font = mainFont;
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_loginIDLabel.frame) + Maigin * 2, 20, labelW, labelH);
    [self.contentView addSubview:_userNameLabel];
    
    _creatTimeLabel = [[UILabel alloc]init];
    _creatTimeLabel.backgroundColor = [UIColor clearColor];
    _creatTimeLabel.font = mainFont;
    _creatTimeLabel.textAlignment = NSTextAlignmentCenter;
    _creatTimeLabel.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame) + Maigin * 2, 20, labelW + 30, labelH);
    [self.contentView addSubview:_creatTimeLabel];
    
    _deleteBtn = [[UIButton alloc]init];
    _deleteBtn.titleLabel.font = mainFont;
    [_deleteBtn setBackgroundColor:[UIColor clearColor]];
    [_deleteBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deletedClicked) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.frame = CGRectMake(CGRectGetMaxX(_creatTimeLabel.frame) + Maigin * 5, 20, 80, 25);
    [self.contentView addSubview:_deleteBtn];
    
}

-(void)deletedClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteClickedWithStaffManagerModel:)]) {
        [_delegate deleteClickedWithStaffManagerModel:_staffModel];
    }
}

-(void)setContentWithModel:(StaffManagerModel *)model
{
    self.staffModel = model;
    _loginIDLabel.text = model.loginID;
    _userNameLabel.text = model.name;
    _creatTimeLabel.text = model.createdTime;
    
}
@end
