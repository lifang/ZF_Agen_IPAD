//
//  AddressModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _addressID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"receiver"]) {
            _addressReceiver = [NSString stringWithFormat:@"%@",[dict objectForKey:@"receiver"]];
        }
        else{
            _addressReceiver = @"";
        }
        if ([dict objectForKey:@"address"]) {
            _address = [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
        }
        else{
            _address = @"";
        }
        if ([dict objectForKey:@"moblephone"]) {
            _addressPhone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"moblephone"]];
        }
        else{
            _addressPhone = @"";
        }
        if ([dict objectForKey:@"isDefault"]) {
            _isDefault = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isDefault"]];
        }
        if ([dict objectForKey:@"city_id"]) {
            _cityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_id"]];
        }
        else{
            _cityID = @"";
        }
        if ([dict objectForKey:@"zipCode"]) {
            _zipCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zipCode"]];
        }
        else{
            _zipCode = @"";
        }
        if ([dict objectForKey:@"city_parent_name"]) {
            _city_parent_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_parent_name"]];
        }
        else{
            _city_parent_name = @"";
        }
        if ([dict objectForKey:@"city_name"]) {
            _city_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_name"]];
        }
        else{
            _city_name = @"";
        }
    }
    return self;
}
@end
