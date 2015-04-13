//
//  TerminalModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TerminalModel.h"

@implementation TerminalModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _channelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payChannelId"]];
        _terminalNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serialNum"]];
    }
    return self;
}

@end
