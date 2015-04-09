//
//  MyMessageViewController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MineCommonController.h"
#import "SwitchView.h"

@interface MyMessageViewController : MineCommonController

-(void)SwitchViewClickedAtIndex:(int)Index;

@property(nonatomic,strong)SwitchView *swithView;

@property(nonatomic,assign)int Index;

@property(nonatomic,strong)NSString *IntegralNum;

@end
