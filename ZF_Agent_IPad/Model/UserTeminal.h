//
//  UserTeminal.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTeminal : NSObject

@property (nonatomic, strong) NSString *terminalID;

@property (nonatomic, strong) NSString *terminalNum;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
