//
//  OpeningModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OpeningModel : NSObject

@property (nonatomic, strong) NSString *openType;
@property (nonatomic, strong) NSString *infor;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;


@property (nonatomic, assign) NSInteger index;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
