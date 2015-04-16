//
//  StaffButton.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StaffBtnClickedDelegate <NSObject>

@optional

-(void)staffClickedWithButton:(UIButton *)button;

@end

@interface StaffButton : UIButton

@property(nonatomic,weak)id <StaffBtnClickedDelegate> delegate;

@property(nonatomic,assign)BOOL isSelected;

-(void)BtnClickedWithButton:(UIButton *)button;

-(void)setBGWithisSelected:(BOOL)isSelected;

@end
