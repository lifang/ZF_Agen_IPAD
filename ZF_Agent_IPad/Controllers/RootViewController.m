//
//  RootViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "RootViewController.h"
#import "NavigationBarAttr.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showLoginViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录与主界面

- (void)showLoginViewController {
    if (!_loginNav) {
        LoginViewController *loginC = [[LoginViewController alloc] init];
        _loginNav = [[BasicNagigationController alloc] initWithRootViewController:loginC];
        _loginNav.view.frame = self.view.bounds;
        [self.view addSubview:_loginNav.view];
        [self addChildViewController:_loginNav];
        [NavigationBarAttr setNavigationBarStyle:_loginNav];
    }
    if (_homeController) {
        [_homeController.view removeFromSuperview];
        [_homeController removeFromParentViewController];
        _homeController = nil;
    }
    [self.view bringSubviewToFront:_loginNav.view];
}

- (void)showMainViewController {
    if (!_homeController) {
        _homeController = [[HomepageViewController alloc] init];
        _homeController.view.frame = self.view.bounds;
        [self.view addSubview:_homeController.view];
        [self addChildViewController:_homeController];
    }
    if (_loginNav) {
        [_loginNav.view removeFromSuperview];
        [_loginNav removeFromParentViewController];
        _loginNav = nil;
    }
    [self.view bringSubviewToFront:_homeController.view];
}
@end
