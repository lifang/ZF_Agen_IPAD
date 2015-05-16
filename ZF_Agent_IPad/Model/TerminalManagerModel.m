//
//  TerminalManagerModel.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalManagerModel.h"

@implementation TerminalManagerModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _TM_ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _TM_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        _TM_serialNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        if ([dict objectForKey:@"brandsName"]) {
            _TM_brandsName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandsName"]];
        }else{
            _TM_brandsName = @"";
        }
        _TM_channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"channelName"]];
        if ([dict objectForKey:@"model_number"]) {
            _TM_model_number = [NSString stringWithFormat:@"%@",[dict objectForKey:@"model_number"]];
        }else{
            _TM_model_number = @"";
        }
        if ([dict objectForKey:@"appid"]) {
            _appID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"appid"]];
        }else{
            _appID = @"";
        }
        if ([dict objectForKey:@"hasVideoVerify"]) {
            _isHaveVideo = [[dict objectForKey:@"hasVideoVerify"] integerValue];
        }
        if ([dict objectForKey:@"type"]) {
            _type = [dict objectForKey:@"type"];
        }else{
            _type = @"";
        }
        if ([dict objectForKey:@"openstatus"]) {
            _openstatus = [dict objectForKey:@"openstatus"];
        }else{
            _openstatus = @"";
        }
        if ([dict objectForKey:@"openingProtocol"]) {
            _protocol = [NSString stringWithFormat:@"%@",[dict objectForKey:@"openingProtocol"]];
        }else{
            _protocol = @"";
        }
        
    }
    return self;
}

- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [self.TM_status intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}


@end
