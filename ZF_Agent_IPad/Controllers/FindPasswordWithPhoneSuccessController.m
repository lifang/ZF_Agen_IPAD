//
//  FindPasswordWithPhoneSuccessController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/19.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "FindPasswordWithPhoneSuccessController.h"

@interface FindPasswordWithPhoneSuccessController ()

@end

@implementation FindPasswordWithPhoneSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *label1 = [[UILabel alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:20];
    label1.text = @"您的密码已更新！";
    label1.font = mainFont;
    label1.frame = CGRectMake(430, 120, 160, 40);
    [self.view addSubview:label1];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(233, 233, 233, 1.0);
    line.frame = CGRectMake(60, CGRectGetMaxY(label1.frame) + 40, label1.frame.size.width * 6 - 50, 2);
    [self.view addSubview:line];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"马上登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = mainFont;
    [loginBtn setBackgroundColor:kMainColor];
    loginBtn.frame = CGRectMake(label1.frame.origin.x - 20, CGRectGetMaxY(line.frame) + 40, 240, 40);
    [self.view addSubview:loginBtn];

}

-(void)setupNavBar
{
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *zeroBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    zeroBar.width = 30.f;
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 48, 48);
    [leftBtn setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    NSArray *leftArr = [NSArray arrayWithObjects:zeroBar,leftBar, nil];
    self.navigationItem.leftBarButtonItems = leftArr;
}

-(void)loginClick
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
