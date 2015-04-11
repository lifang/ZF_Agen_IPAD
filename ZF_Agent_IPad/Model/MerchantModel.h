//
//  MerchantModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantModel : NSObject

@property (nonatomic, strong) NSString *merchantID;

@property (nonatomic, strong) NSString *merchantName;

@property (nonatomic, strong) NSString *merchantLegal;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
