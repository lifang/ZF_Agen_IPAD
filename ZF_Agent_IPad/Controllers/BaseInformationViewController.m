//
//  BaseInformationViewController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "BaseInformationViewController.h"

@interface BaseInformationViewController ()

@end

@implementation BaseInformationViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.swithView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
