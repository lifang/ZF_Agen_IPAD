//
//  AccountModel.m
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_userID forKey:@"userID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _token = [aDecoder decodeObjectForKey:@"token"];
        _userID = [aDecoder decodeObjectForKey:@"userID"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    AccountModel *user = [[self class] allocWithZone:zone];
    user.username = [_username copyWithZone:zone];
    user.password = [_password copyWithZone:zone];
    user.token = [_token copyWithZone:zone];
    user.userID = [_userID copyWithZone:zone];
    return user;
}

@end
