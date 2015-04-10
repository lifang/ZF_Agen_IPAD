//
//  OpeningDetailsModel.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "OpeningDetailsModel.h"

@implementation OpeningDetailsModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"key"]) {
            _resourceKey = [NSString stringWithFormat:@"%@",[dict objectForKey:@"key"]];
        }
        if ([dict objectForKey:@"value"]) {
            _resourceValue = [NSString stringWithFormat:@"%@",[dict objectForKey:@"value"]];
        }
        if ([dict objectForKey:@"types"]) {
            _type = (ResourceType)[[dict objectForKey:@"types"] intValue];
        }
    }
    return self;
}


@end
