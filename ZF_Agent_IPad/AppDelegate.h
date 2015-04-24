//
//  AppDelegate.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *userID;       //用户id
@property (nonatomic, strong) NSString *agentUserID;  //代理商对应的用户id

@property (nonatomic, strong) NSString *agentID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSMutableDictionary *authDict;   //权限

@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, assign) BOOL hasProfit;         //是否有分润
+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;
- (void)saveLoginInfo:(NSDictionary *)dict;


@end

