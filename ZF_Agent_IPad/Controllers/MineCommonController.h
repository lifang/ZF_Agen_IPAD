//
//  MineCommonController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseView.h"
#import "ScanImageViewController.h"

@interface MineCommonController : ScanImageViewController

@property(nonatomic,strong)ChooseView *chooseView;

-(void)orderClick;

-(void)setLeftViewWith:(ChooseViewType)choosetype;
-(void)messageBtnClick;

-(void)aftersellBtnClick;


@end
