//
//  StaffChangeController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffManagerModel.h"

@interface StaffChangeController : UIViewController

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *loginID;
@property(nonatomic,strong)StaffManagerModel *staffmodel;
@property(nonatomic,strong)NSArray *statusDetailArray;

@end
