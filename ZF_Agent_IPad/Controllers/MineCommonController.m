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
    
    self.chooseView = chooseView;
    [self.view addSubview:chooseView];
    

}

//我的信息
-(void)orderClick
{
    BaseInformationViewController *baseInformationVC = [[BaseInformationViewController alloc]init];
    baseInformationVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:baseInformationVC animated:NO];
}
//售后记录
-(void)aftersellBtnClick
{
    SubAgentListController *afterVC = [[SubAgentListController alloc]init];
    afterVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:afterVC animated:NO];
}
//我的信息
-(void)messageBtnClick
{
    PrepareGoodManagerController *baseInformationVC = [[PrepareGoodManagerController alloc]init];
    baseInformationVC.navigationController.navigationBarHidden = YES;

    [self.navigationController pushViewController:baseInformationVC animated:NO];
}
////我的商户
//-(void)shopBtnClick
//{
//    MyShopViewController *shopVC = [[MyShopViewController alloc]init];
//    [self.navigationController pushViewController:shopVC animated:NO];
//}
//员工管理
-(void)applyBtnClick
{
    StaffManagerController *staffVC = [[StaffManagerController alloc]init];
    staffVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:staffVC animated:NO];
}

@end
