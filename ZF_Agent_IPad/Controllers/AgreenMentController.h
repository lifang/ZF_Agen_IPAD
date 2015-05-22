//
//  AgreenMentController.h
//  iPadff
//
//  Created by 黄含章 on 15/5/15.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"
typedef enum {
    PushNone = 0,
    PushDredge = 1,
    PushTeminal,
    PushTeminalChild,
}PushStyle;  //开通类型
@interface AgreenMentController : CommonViewController

@property(nonatomic,strong)NSString *tm_id;
@property(nonatomic,strong)NSString *protocolStr;

@property(nonatomic,assign)PushStyle pushStyle;
@end
