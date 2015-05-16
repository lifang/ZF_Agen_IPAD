//
//  IdentificationModel.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "IdentificationModel.h"

@implementation IdentificationModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _TM_ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _TM_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        _TM_serialNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"serial_num"]];
        if ([dict objectForKey:@"brandName"]) {
            _TM_brandsName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"brandName"]];
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
            _isHaveVideo = [[dict objectForKey:@"hasVideoVerify"] boolValue];
        }
        if ([dict objectForKey:@"openstatus"]) {
            _openstatus = [dict objectForKey:@"openstatus"];
        }else{
            _openstatus = @"";
        }
        if ([dict objectForKey:@"openstatus"]) {
            _openstatus = [dict objectForKey:@"openstatus"];
        }else{
            _openstatus = @"";
        }
        if ([dict objectForKey:@"type"]) {
            _type = [dict objectForKey:@"type"];
        }else{
            _type =@"";
        }
        if ([dict objectForKey:@"openingProtocol"]) {
            _protocol = [dict objectForKey:@"openingProtocol"];
        }else{
            _protocol =@"";
        }
    }
    return self;
}

- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [self.TM_status intValue];
    switch (index) {
        case SerminalStatusOpened:
            statusString = @"已开通";
            break;
        case SerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case SerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case SerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case SerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}


@end
