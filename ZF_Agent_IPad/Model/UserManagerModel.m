//
//  UserManagerModel.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerModel.h"

@implementation UserManagerModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"customersId"]) {
            _customersId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"customersId"]];
        }
        if ([dict objectForKey:@"agentId"]) {
            _agentID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"agentId"]];
        }
        if ([dict objectForKey:@"email"]) {
            _email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
        }
        else {
            _email = @"";
        }
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        else {
            _name = @"";
        }
        if ([dict objectForKey:@"createdAt"]) {
            _createdAt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createdAt"]];
        }
        else {
            _createdAt = @"";
        }
        if ([dict objectForKey:@"phone"]) {
            _phone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        else {
            _phone = @"";
        }
        
    }
    return self;
}
@end
