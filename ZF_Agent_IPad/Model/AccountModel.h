//
//  AccountModel.h
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject<NSCopying,NSCoding>

@property(nonatomic,strong)NSString *username;

@property(nonatomic,strong)NSString *password;

@property(nonatomic,strong)NSString *token;

@property(nonatomic,strong)NSString *userID;

@end
