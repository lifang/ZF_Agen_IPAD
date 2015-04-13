//
//  TerminalModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

//交易流水的终端

@interface TerminalModel : NSObject

//支付通道id
@property (nonatomic, strong) NSString *channelID;
//终端号
@property (nonatomic, strong) NSString *terminalNum;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
