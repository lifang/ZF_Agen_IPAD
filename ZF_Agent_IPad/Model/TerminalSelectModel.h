//
//  TerminalSelectModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminalSelectModel : NSObject

@property (nonatomic, strong) NSString *selectId;

@property (nonatomic, strong) NSString *serial_num;

@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *retail_price;

@property (nonatomic, assign) CGFloat t_price;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
