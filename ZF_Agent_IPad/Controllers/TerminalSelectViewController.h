//
//  TerminalSelectViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalSelectModel.h"

@protocol SelectedTerminalDelegate <NSObject>

- (void)getSelectedTerminal:(NSMutableArray *)array;

@end

@interface TerminalSelectViewController : CommonViewController

@property (nonatomic, assign) id<SelectedTerminalDelegate>delegate;

@property (nonatomic, strong) NSString *TerminalId;




@end
