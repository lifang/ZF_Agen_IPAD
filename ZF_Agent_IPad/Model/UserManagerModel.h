//
//  UserManagerModel.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManagerModel : NSObject

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *agentID;

@property(nonatomic,strong)NSString *customersId;

@property(nonatomic,strong)NSString *phone;

@property(nonatomic,strong)NSString *email;

@property(nonatomic,strong)NSString *createdAt;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
