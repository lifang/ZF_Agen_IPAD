//
//  OrderManagerController.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RefreshViewController.h"
static NSString *RefreshOrderListNotification = @"RefreshOrderListNotification";

@interface OrderManagerController : RefreshViewController

{

    BOOL typechang;
    
    UIButton*buybutton;
    UIButton*rentbutton;


}
@end
