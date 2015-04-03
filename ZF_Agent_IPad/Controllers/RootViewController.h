//
//  RootViewController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomepageViewController.h"
#import "LoginViewController.h"

@interface RootViewController : UIViewController

@property (nonatomic, strong) UINavigationController *loginNav;

@property(nonatomic,strong)HomepageViewController *homeController;


- (void)showLoginViewController;

- (void)showMainViewController;

@end
