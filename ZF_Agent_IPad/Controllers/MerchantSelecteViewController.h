//
//  MerchantSelecteViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MerchantDetailModel.h"
#import "MerchantModel.h"

@protocol ApplyMerchantSelectedDelegate <NSObject>

- (void)getSelectedMerchant:(MerchantDetailModel *)model;
- (void)displaySelectedMerchant:(MerchantModel *)model;

@end

@interface MerchantSelecteViewController : UIViewController

@property (nonatomic, assign) id<ApplyMerchantSelectedDelegate>delegate;


@end
