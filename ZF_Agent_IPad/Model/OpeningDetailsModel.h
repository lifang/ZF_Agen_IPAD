//
//  OpeningDetailsModel.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

/*终端管理 开通资料信息*/
#import <Foundation/Foundation.h>

typedef enum {
    ResourceNone = 0,
    ResourceText,      //文字
    ResourceImage,     //图片
}ResourceType;

@interface OpeningDetailsModel : NSObject

@property (nonatomic, strong) NSString *resourceKey;
@property (nonatomic, strong) NSString *resourceValue;
@property (nonatomic, assign) ResourceType type;

@property (nonatomic, assign) NSInteger index;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
