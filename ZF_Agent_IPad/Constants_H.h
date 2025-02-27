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



#define kAppChannel  7  //推送channel

#define kAppVersionType  6   //版本更新

#define UMENG_APPKEY @"553deff867e58ed9fc000146" //友盟key

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


#define kServiceURL @"http://121.40.84.2:28080/ZFAgent/api" //test
//#define kServiceURL @"http://121.40.224.25:9090/api" //YUFA
//#define kServiceURL @"http://agent.ebank007.com/api" //线上

#define kVideoAuthIP    @"121.40.84.2"  //test
//#define kVideoAuthIP      @"121.40.64.120"   //线上
#define kVideoAuthPort  8906

//视频提示地址
#define kVideoServiceURL @"http://121.40.84.2:38080/ZFManager/notice/video"
//#define kVideoServiceURL @"http://admin.ebank007.com/notice/video"   //线上

//支付地址
#define kWhalesaleCallBackURL   @"http://121.40.84.2:28080/ZFAgent/deposit_app_notify_url.jsp"
#define kProcurementCallBackURL @"http://121.40.84.2:28080/ZFAgent/app_notify_url.jsp"

//#define kWhalesaleCallBackURL    @"http://agent.ebank007.com/deposit_app_notify_url.jsp"  //线上
//#define kProcurementCallBackURL  @"http://agent.ebank007.com/app_notify_url.jsp"  //线上


//UnionPay
#define kMode_Production             @"01" //测试
#define kUnionPayURL  @"http://121.40.84.2:28080/ZFAgent/unionpay.do" //测试

//#define kMode_Production             @"00"  //线上
//#define kUnionPayURL  @"http://agent.ebank007.com/unionpay.do" //线上

//#define kMode_Production             @"00"  //YUFA
//#define kUnionPayURL  @"http://121.40.224.25:9090/unionpay.do" //YUFA



//#define kBaiduAPIKey  @"hOX57GFAtv3sbji8a4tmrzzb" //APPstore
#define kBaiduAPIKey @"7OqFwW72f3vKiAGzvqoMUOSc" //zhangfu
