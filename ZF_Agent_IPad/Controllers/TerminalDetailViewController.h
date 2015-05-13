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

@property (nonatomic, strong) NSString *tm_ID; //终端信息id

@property (nonatomic, strong) NSString *videoVerify; //视频认证

@end
