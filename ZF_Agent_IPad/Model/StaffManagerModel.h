//
//  StaffManagerModel.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffManagerModel : NSObject

@property(nonatomic,strong)NSString *userID;

@property(nonatomic,strong)NSString *loginID;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *createdTime;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
