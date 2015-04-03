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

@property (nonatomic, strong) NSString *agentID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) RootViewController *rootViewController;

+ (AppDelegate *)shareAppDelegate;

+ (RootViewController *)shareRootViewController;


@end

