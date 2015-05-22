//
//  ChangePhoneSuccessViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangePhoneSuccessViewController.h"
#import "BaseInformationViewController.h"

@interface ChangePhoneSuccessViewController ()

@end

@implementation ChangePhoneSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改手机";
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"您的手机号码已更新！";
    label.frame = CGRectMake(SCREEN_WIDTH / 2 - 80, 130, 200, 30);
    if (iOS7) {
        label.frame = CGRectMake(SCREEN_HEIGHT / 2 - 80, 130, 200, 30);
    }
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = kColor(66, 66, 66, 1.0);
    [self.view addSubview:label];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(226, 226, 226, 1.0);
    line.frame = CGRectMake(40, CGRectGetMaxY(label.frame) + 60, SCREEN_WIDTH - 2 * 40, 1);
    if (iOS7) {
        line.frame = CGRectMake(40, CGRectGetMaxY(label.frame) + 60, SCREEN_HEIGHT - 2 * 40, 1);
    }
    [self.view addSubview:line];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(label.frame.origin.x - 20, CGRectGetMaxY(line.frame) + 50, label.frame.size.width + 40, 40);
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:kMainColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClicked
{
    BaseInformationViewController *baseVC = [[BaseInformationViewController alloc]init];
    baseVC.newsPhone = _phone;
    [self.navigationController pushViewController:baseVC animated:NO];
}

@end
