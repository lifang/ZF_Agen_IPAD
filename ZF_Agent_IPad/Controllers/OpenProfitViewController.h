//
//  OpenProfitViewController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "CommonViewController.h"
static NSString *RefreshBenefitListNotification = @"RefreshBenefitListNotification";

@interface OpenProfitViewController : CommonViewController

{ UITextField*neworiginaltextfield;
    
    NSInteger  numberint;
    NSInteger  alertint;

}
@property (nonatomic, strong) NSString *subAgentID;

@end
