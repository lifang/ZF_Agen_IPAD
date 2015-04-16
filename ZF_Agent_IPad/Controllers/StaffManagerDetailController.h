//
//  StaffManagerDetailController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffManagerModel.h"

typedef enum {
    staffStatusCreated = 1,//创建
    staffStatusDetail,    //详情
}staffStatus;

@interface StaffManagerDetailController : UIViewController

@property(nonatomic,strong)StaffManagerModel *staffModel;

@property(nonatomic,assign)staffStatus statffStatus;

@end
