//
//  TerminalSelectModel.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalSelectModel.h"

@implementation TerminalSelectModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _selectId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"serial_num"]) {
            _serial_num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        }
        if ([dict objectForKey:@"money"]) {
            _retail_price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"money"]];
        }
        if ([dict objectForKey:@"retail_price"]) {
            _t_price = [[dict objectForKey:@"retail_price"] floatValue]/100;
        }

    }
    return self;
}


@end
