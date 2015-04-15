//
//  MessageViewCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageViewCell.h"

@implementation MessageViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"dynamic";
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.leftBtn = [[UIButton alloc]init];
        self.btnStatus = YES;
        [_leftBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.textColor = kColor(70, 70, 70, 1.0);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
       
    }
    return self;
}

-(void)btnClicked
{
    [self.MessageCellClickedDelegate messageCellClickedWithMessageID:_selectedID WithBtnStatus:_btnStatus];
    if (self.btnStatus == YES) {
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    self.btnStatus = !self.btnStatus;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_isRead) {
        self.textLabel.textColor = kColor(183, 183, 183, 1.0);
        self.timeLabel.textColor = kColor(183, 183, 183, 1.0);
    }else{
        self.textLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = kColor(70, 70, 70, 1.0);;
    }
    self.leftBtn.frame = CGRectMake(36, 20, 25, 25);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame) + 20, 15, 400, 40);
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                            toItem:self.textLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:300]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:200]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40]];
}

@end
