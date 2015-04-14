//
//  CSModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/8.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkInterface.h"

//售后单标识
static NSString *firstStatusIdentifier = @"firstStatusIdentifier";
//2
static NSString *secondStatusIdentifier = @"secondStatusIdentifier";
//3
static NSString *thirdStatusIdentifier = @"thirdStatusIdentifier";
//4
static NSString *forthStatusIdentifier = @"forthStatusIdentifier";
//5
static NSString *fifthStatusIdentifier = @"fifthStatusIdentifier";

//注销标识
static NSString *firstStatusIdentifier1 = @"firstStatusIdentifier1";
//2
static NSString *secondStatusIdentifier1 = @"secondStatusIdentifier1";
//3
static NSString *thirdStatusIdentifier1 = @"thirdStatusIdentifier1";
//4
static NSString *forthStatusIdentifier1 = @"forthStatusIdentifier1";
//5
static NSString *fifthStatusIdentifier1 = @"fifthStatusIdentifier1";

//更新标识
static NSString *firstStatusIdentifier2 = @"firstStatusIdentifier2";
//2
static NSString *secondStatusIdentifier2 = @"secondStatusIdentifier2";
//3
static NSString *thirdStatusIdentifier2 = @"thirdStatusIdentifier2";
//4
static NSString *forthStatusIdentifier2 = @"forthStatusIdentifier2";
//5
static NSString *fifthStatusIdentifier2 = @"fifthStatusIdentifier2";

typedef enum {
    CSStatusAll = -1,
    CSStatusFirst = 1,
    CSStatusSecond,
    CSStatusThird,
    CSStatusForth,
    CSStatusFifth,
}CSStatus;

@interface CSModel : NSObject

@property (nonatomic, strong) NSString *csID;

@property (nonatomic, strong) NSString *terminalNum;

@property (nonatomic, strong) NSString *applyNum;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *createTime;

- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getCellIdentifier;
- (NSString *)getCellIdentifier1;
- (NSString *)getCellIdentifier2;

//编号
- (NSString *)getCSNumberPrefixWithCSType:(CSType)csType;

@end
