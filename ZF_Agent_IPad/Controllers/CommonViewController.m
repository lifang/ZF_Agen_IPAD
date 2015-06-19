//
//  CommonViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "MobClick.h"

static NSDictionary *s_mappingPlist = nil;

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

-(NSDictionary *)getMappingDictionary{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path =[[NSBundle mainBundle] pathForResource:@"MappingPlist" ofType:@"plist"];
        NSDictionary *mappingDic=[NSDictionary dictionaryWithContentsOfFile:path];
        s_mappingPlist=[mappingDic objectForKey:@"Mapping"];
    });
    return s_mappingPlist;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    NSString *pageKey = [[self getMappingDictionary]objectForKey:NSStringFromClass(self.class)];
    
    
    NSLog(@"++++++++++++++++++++++++++++++++++++++++%@",pageKey);
    if (pageKey) {
        [MobClick beginLogPageView:pageKey];
    }

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
- (void)viewDidDisappear:(BOOL)animated {
    NSString *pageKey = [[self getMappingDictionary] objectForKey:NSStringFromClass(self.class)];
    NSLog(@"========================================%@",pageKey);
    if (pageKey) {
        [MobClick endLogPageView:pageKey];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
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
