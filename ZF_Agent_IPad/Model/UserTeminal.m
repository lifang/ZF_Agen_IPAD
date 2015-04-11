//
//  UserTeminal.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserTeminal.h"

@implementation UserTeminal

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _terminalID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        else {
            _terminalNum = @"";
        }
    }
    return self;
}
@end
