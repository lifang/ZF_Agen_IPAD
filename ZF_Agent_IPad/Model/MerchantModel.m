//
//  MerchantModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MerchantModel.h"

@implementation MerchantModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _merchantID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        if ([dict objectForKey:@"legal_person_name"]) {
            _merchantLegal = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legal_person_name"]];
        }
    }
    return self;
}


@end
