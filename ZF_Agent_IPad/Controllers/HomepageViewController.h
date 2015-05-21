//
//  HomepageViewController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ZYCustomTabBarViewController.h"
static NSString *s_messageTab = @"s_messageTab";
static NSString *ShowTabBadgeNotification = @"ShowTabBadgeNotification";

@interface HomepageViewController : ZYCustomTabBarViewController

@property (strong, nonatomic) UINavigationController *naviController;
@property(nonatomic,strong)NSArray *array5;
@end
