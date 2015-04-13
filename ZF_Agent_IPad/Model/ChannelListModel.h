//
//  ChannelListModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillingModel : NSObject

@property (nonatomic, strong) NSString *billID;
@property (nonatomic, strong) NSString *billName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface ChannelListModel : NSObject

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSString *channelName;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
