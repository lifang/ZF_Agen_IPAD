//
//  StaffButton.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffButton.h"

@implementation StaffButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)BtnClickedWithButton:(UIButton *)button
{
    [self BtnClicked:button];
}

-(void)BtnClicked:(UIButton *)button
{
    if (!_isSelected) {
        [self setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [self setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    self.isSelected = !self.isSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(staffClickedWithButton:)]) {
        [_delegate staffClickedWithButton:button];
    }
}

-(void)setBGWithisSelected:(BOOL)isSelected
{
    if (!_isSelected) {
        [self setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [self setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
}

@end
