//
//  OpeningModel.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "OpeningModel.h"

@implementation OpeningModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"type"]) {
            _openType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
        }
        if ([dict objectForKey:@"terminal_name"]) {
            _infor = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminal_name"]];
        }
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"phone"]) {
            _phone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
    }
    return self;
}


@end
