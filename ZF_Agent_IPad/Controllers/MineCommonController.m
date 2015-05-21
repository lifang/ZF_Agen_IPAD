//
//  MineCommonController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MineCommonController.h"
#import "BaseInformationViewController.h"
#import "StaffManagerController.h"
#import "SubAgentListController.h"
#import "PrepareGoodManagerController.h"
#import "AdjustGoodsViewController.h"
#import "SafeViewController.h"
@interface MineCommonController ()

@end

@implementation MineCommonController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLeftViewWith:(ChooseViewType)choosetype
{
    ChooseView *chooseView = [[ChooseView alloc]initWithFrame:CGRectMake(0, 0, 160.f, SCREEN_HEIGHT) With:choosetype];
    if (iOS7) {
        chooseView = [[ChooseView alloc]initWithFrame:CGRectMake(0, 0, 160.f, SCREEN_WIDTH) With:choosetype];
    }
    [chooseView.orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.aftersellBtn addTarget:self action:@selector(aftersellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.shopBtn addTarget:self action:@selector(shopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.safeBtn addTarget:self action:@selector(safeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.exitbtn addTarget:self action:@selector(exitbtnclick) forControlEvents:UIControlEventTouchUpInside];

    self.chooseView = chooseView;
    [self.view addSubview:chooseView];
    

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8900 && buttonIndex == 0) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [[AppDelegate shareRootViewController] showLoginViewController];
    }
}
-(void)exitbtnclick
{
    
    [self setLeftViewWith:ChooseViewexit];
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"确定要退出？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertV.tag = 8900;
    [alertV show];


}
//我的信息
-(void)orderClick
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthAR]] boolValue]) {
        BaseInformationViewController *baseInformationVC = [[BaseInformationViewController alloc]init];
        baseInformationVC.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:baseInformationVC animated:NO];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"您没有查看代理商资料权限";
    }
    
}
//下级代理商管理
-(void)aftersellBtnClick
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthSubAgent]] boolValue]) {
        SubAgentListController *afterVC = [[SubAgentListController alloc]init];
        afterVC.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:afterVC animated:NO];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"您没有下级代理商管理权限";
    }
}
//配货
-(void)messageBtnClick
{
    PrepareGoodManagerController *baseInformationVC = [[PrepareGoodManagerController alloc]init];
    baseInformationVC.navigationController.navigationBarHidden = YES;

    [self.navigationController pushViewController:baseInformationVC animated:NO];
}
//调货
-(void)shopBtnClick
{
    AdjustGoodsViewController *shopVC = [[AdjustGoodsViewController alloc]init];
    shopVC.navigationController.navigationBarHidden = YES;

    [self.navigationController pushViewController:shopVC animated:NO];
}
//员工管理
-(void)applyBtnClick
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthEA]] boolValue]) {
        StaffManagerController *staffVC = [[StaffManagerController alloc]init];
        staffVC.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:staffVC animated:NO];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"您没有查看员工账号权限";
    }
    
}

-(void)safeBtnClick
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthUM]] boolValue]) {
        SafeViewController *safeVC = [[SafeViewController alloc]init];
        safeVC.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:safeVC animated:NO];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"您没有修改信息权限";
    }
}

@end
