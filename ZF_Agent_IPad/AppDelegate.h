//
//  AppDelegate.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
typedef enum {
    UserAgent = 2,     //代理商
    UserEmployee = 6,  //员工
}UserType;
typedef enum {
    AuthWholesale = 1,  //批购权限
    AuthProcurement,    //代购权限
    AuthTM_CS,          //终端管理+售后记录
    AuthT_B,            //交易流水+分润
    AuthSubAgent,       //下级代理商管理
    AuthUM,             //用户管理
    AuthEA,             //员工账号
    AuthAR,             //代理商资料
    AuthStock,          //库存
    AuthOrder,          //订单
}AuthType; //权限

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *userID;       //用户id
@property (nonatomic, strong) NSString *agentUserID;  //代理商对应的用户id

@property (nonatomic, strong) NSString *agentID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSMutableDictionary *authDict;   //权限
@property (nonatomic, assign) UserType userType;
@property (nonatomic, assign) BOOL isFirstLevelAgent; //是否一级代理商

@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, assign) BOOL hasProfit;         //是否有分润
+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;
- (void)saveLoginInfo:(NSDictionary *)dict;
//登录后返回
-(void)clearLoginInfo;
@property(nonatomic,assign)BOOL isFirst;

@end

