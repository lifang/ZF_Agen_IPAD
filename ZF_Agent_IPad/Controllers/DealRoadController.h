//
//  DealRoadController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealRoadController : UIViewController

{
    NSMutableArray *agentItem;
    UIButton* blankbutton ;
    
    NSString*agentid;
    NSInteger changeA;
    UIView*datepickview;
    UIButton *cancelBtn;
    UIView*datepickviewend;
    UIButton *cancelBtnend;

    BOOL changeD;
    BOOL changeagent;

}

@end
