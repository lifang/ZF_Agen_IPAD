//
//  RecordModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (nonatomic, strong) NSString *recordName;

@property (nonatomic, strong) NSString *recordTime;

@property (nonatomic, strong) NSString *recordContent;

//售后字段
- (id)initWithParseDictionary:(NSDictionary *)dict;

//终端详情
- (id)initWithParseTerminalDictionary:(NSDictionary *)dict;



@end
