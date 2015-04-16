//
//  AdjustGoodsViewController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "MineCommonController.h"

@interface AdjustGoodsViewController : MineCommonController
{    UIButton* blankbutton ;
    UIView*datepickview;
    UIButton *cancelBtn;
    UIView*datepickviewend;
    UIButton *cancelBtnend;
    UIButton*starbuttom ;
    UIButton*endbuttom;
    NSInteger changeA;
    NSString*agentid;
    NSString*nextagentid;
    NSString*nextagentids;

    UIView*witeview;
    UIImageView*bigsview;
    NSInteger changeB;
    UIButton*nextagentbutton;
    BOOL changeagent;
    UIButton*nextagentbuttons;

    UITextField*neworiginaltextfield;
    UILabel*namelable;
    
}

@end
