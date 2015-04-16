//
//  StaffManagerModel.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StaffManagerModel.h"

@implementation StaffManagerModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _userID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"username"]) {
            _loginID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
        }
        else{
            _loginID = @"";
        }
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        else{
            _name = @"";
        }
        if ([dict objectForKey:@"createdAt"]) {
            _createdTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"createdAt"]];
        }
        else{
            _createdTime = @"";
        }
        if ([dict objectForKey:@"rolesStr"]) {
            _roles = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rolesStr"]];
        }
        else{
            _roles = @"";
        }
        
    }
    return self;
}
@end
