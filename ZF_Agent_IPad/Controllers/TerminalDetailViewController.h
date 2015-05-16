//
//  TerminalDetailViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ScanImageViewController.h"
#import "TerminalManagerModel.h"

@interface TerminalDetailViewController : ScanImageViewController

@property(nonatomic,strong)NSString *dealStatus;

@property(nonatomic,assign)BOOL isHaveVideo;

@property (nonatomic, strong) NSString *tm_ID; //终端信息id

@property(nonatomic,strong)NSString *appID;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *openStatus;

@property(nonatomic,strong)NSString *protocol;

@end
