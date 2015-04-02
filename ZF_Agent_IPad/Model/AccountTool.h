//
//  AccountTool.h
//  iPadff
//
//  Created by 黄含章 on 15/3/25.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"
#define kLastestPath @"lasteseUserInfo"
#define kLastestFile @"lastestUser"

@interface AccountTool : NSObject
//存储帐号信息
+(void)save:(AccountModel *)account;
//读取帐号
+(AccountModel *)userModel;
@end
