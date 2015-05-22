//
//  TransferGoodModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/14.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TransferGoodModel.h"

@implementation TransferGoodModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"fromname"]) {
            _fromAgentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fromname"]];
        }
        else
        {
        _fromAgentName=@"";
            
        }
        if ([dict objectForKey:@"toname"]) {
            _toAgentName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"toname"]];
        }
        else
        {
            _toAgentName=@"";

            
        }
        if ([dict objectForKey:@"created_at"]) {
            _createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
        }
        else
        {
            _createTime=@"";

        }
        _count = [[dict objectForKey:@"quantity"] intValue];
    }
    return self;
}

@end
