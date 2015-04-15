//
//  StaffManagerDetailController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    staffStatus1 = 1,//批购
    staffStatus2,    //代购
    staffStatus3,    //终端管理/售后记录查看
    staffStatus4,    //交易分润查询
    staffStatus5,    //下级代理商管理
    staffStatus6,    //用户管理
    staffStatus7,    //员工账号管理
    staffStatus8,    //代理商资料/收货地址管理
}staffStatus;

@interface StaffManagerDetailController : UIViewController

@end
