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
        
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        [self setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [self setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
}

@end
