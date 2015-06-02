//
//  MessageChildViewController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"
#import "MessageModel.h"

static NSString *RefreshMessageListNotification = @"RefreshMessageListNotification";

@interface MessageChildViewController : CommonViewController
@property (nonatomic, assign) NSString *messageID; //推送需要传的
@property (nonatomic, assign) BOOL isFromPush;  //是否推送进来的

@property (nonatomic, strong) MessageModel *message;

@end
