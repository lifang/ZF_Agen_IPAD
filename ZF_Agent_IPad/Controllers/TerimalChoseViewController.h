//
//  TerimalChoseViewController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/20.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "CommonViewController.h"
#import "TerminalSelectModel.h"

@protocol SelectedTerminalDelegate <NSObject>

- (void)getSelectedTerminal:(NSMutableArray *)array;

@end
@interface TerimalChoseViewController : CommonViewController
@property (nonatomic, assign) id<SelectedTerminalDelegate>delegate;

@property (nonatomic, strong) NSString *TerminalId;
@end
