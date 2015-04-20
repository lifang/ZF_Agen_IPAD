//
//  PrepareGoodManagerController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "MineCommonController.h"

@interface PrepareGoodManagerController : MineCommonController

{
    UIButton*agentnumberbutton;
    
    UIButton*blankbutton;
    UIView*datepickview;
    UIButton *cancelBtn;
    UIView*datepickviewend;
    UIButton *cancelBtnend;
    UIButton*starbuttom ;
    UIButton*endbuttom;
    NSInteger changeA;
    NSString*agentid;
    NSString*nextagentid;
    UIView*witeview;
    UIImageView*bigsview;
    NSInteger changeB;
    UIButton*nextagentbutton;
    BOOL changeagent;

    UITextField*neworiginaltextfield;
    UILabel*namelable;

}
@end
