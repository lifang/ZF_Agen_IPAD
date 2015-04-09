//
//  SwitchView.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchViewClicked <NSObject>

@optional

-(void)SwitchViewClickedAtIndex:(int)Index;

@end

@interface SwitchView : UIView

- (id)initWithFrame:(CGRect)frame With:(NSArray *)btnArray;

-(void)setSelectedBtnAtIndex:(int)Index;

@property(nonatomic,weak)id<SwitchViewClicked> SwitchViewClickedDelegate;

@end
