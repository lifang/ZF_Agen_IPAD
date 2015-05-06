//
//  Constants_H.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define kMainColor kColor(10, 87, 204, 1.0)

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScaling  kScreenWidth / 320   //用于计算高度

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kLineHeight   1.0f

#define kPageSize 10   //分页加载每页行数

//#define kServiceURL @"http://114.215.149.242:28080/ZFAgent/api"
#define kServiceURL @"http://121.40.64.167:9090/api"
//#define kServiceURL @"http://agent.ebank007.com/api"


#define kImageName(name) [UIImage imageNamed:name]
#define NavTitle_FONTSIZE  36

#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0&&8.0>[UIDevice currentDevice].systemVersion.floatValue )
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define SubHead_FONT(s) [UIFont fontWithName:@"[STHeitiSC](light)" size:s]
#define NavTitle_FONT(s) [UIFont fontWithName:@"[STHeitiSC](Medium)" size:s]
#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kWhalesaleCallBackURL    @"http://agent.ebank007.com/deposit_app_notify_url.jsp"
#define kProcurementCallBackURL  @"http://agent.ebank007.com/app_notify_url.jsp"

#define kVideoAuthIP      @"121.40.64.120"   //线上
#define kVideoAuthPort  8906