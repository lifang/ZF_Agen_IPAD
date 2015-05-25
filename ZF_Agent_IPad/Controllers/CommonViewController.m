//
//  CommonViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (kDeviceVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    ZYCustomTabBarViewController *tarbar=[[ZYCustomTabBarViewController alloc] init];
    tarbar.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    
}

//监听事件  子类重写
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification {
    
}

- (void)handleKeyboardDidHidden {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
