//
//  BnakSelectViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"

@protocol BankSelectedDelegate <NSObject>

- (void)getSelectedBank:(BankModel *)model;

@end

@interface BnakSelectViewController : UIViewController

@property (nonatomic, assign) id<BankSelectedDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *bankItems;

@property (nonatomic, strong) NSString *terminalID;


@end
