//
//  HomepageViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "HomepageViewController.h"
#import "ZYHomeViewController.h"
#import "BasicNagigationController.h"
#import "GoodListViewController.h"
@interface HomepageViewController ()

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.AG = 78;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewcontrollew) name:@"addressmanger" object:nil];
    ZYHomeViewController *viewController1 = [[ZYHomeViewController alloc] init];
    GoodListViewController *viewController2 = [[GoodListViewController alloc] init];
    ZYHomeViewController *viewController3 = [[ZYHomeViewController alloc] init];
    ZYHomeViewController *viewController4 = [[ZYHomeViewController alloc] init];
    ZYHomeViewController *viewController5 = [[ZYHomeViewController alloc] init];
    
    //创建一个导航，以第一个视图控制器为根视图
    BasicNagigationController *navController = [[BasicNagigationController alloc] initWithRootViewController:viewController2];
    BasicNagigationController *navController2 = [[BasicNagigationController alloc] initWithRootViewController:viewController4];
    BasicNagigationController *navController3 = [[BasicNagigationController alloc] initWithRootViewController:viewController1];
    BasicNagigationController *navController4 = [[BasicNagigationController alloc] initWithRootViewController:viewController3];
    BasicNagigationController *navController5 = [[BasicNagigationController alloc] initWithRootViewController:viewController5];
    
    //创建一个数组保存导航和另外四个视图控制器
    NSArray *array = [NSArray arrayWithObjects:navController3,navController,navController4,navController2,nil];
    
    self.array5 = [NSArray arrayWithObjects:navController3,navController,navController4,navController5,nil];
    self.viewControllers = array;
    [self setSeletedIndex:0];
    self.naviController.navigationBarHidden = YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addressmanger" object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewcontrollew
{
    self.viewControllers = self.array5;
    [self setSeletedIndex:3];
    
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self];
    self.naviController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressmangers" object:self userInfo:nil];
    
}
@end
