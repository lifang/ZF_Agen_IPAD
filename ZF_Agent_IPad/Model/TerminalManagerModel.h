//
//  TerminalManagerModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TerminalStatusNone = 0,
    TerminalStatusOpened,       //已开通
    TerminalStatusPartOpened,   //部分开通
    TerminalStatusUnOpened,     //未开通
    TerminalStatusCanceled,     //已注销
    TerminalStatusStopped,      //已停用
}TerminalStatus;


@interface TerminalManagerModel : NSObject

@property (nonatomic, strong) NSString *TM_ID;      //终端记录id

@property (nonatomic, strong) NSString *TM_status;  //终端记录状态

@property (nonatomic, strong) NSString *TM_serialNumber;  //终端号

@property (nonatomic, strong) NSString *TM_channelName;  //通道

@property (nonatomic, strong) NSString *TM_brandsName;  //品牌

@property (nonatomic, strong) NSString *TM_model_number;  //型号

@property (nonatomic, strong) NSString *VideoVerify;  //有无视频认证
/*
 若有值，订单状态为已开通，找回POS密码操作,否则是自助开通
 若有值，订单状态为未开通，无同步操作
 */
@property (nonatomic, strong) NSString *appID;
- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusString;


@end
