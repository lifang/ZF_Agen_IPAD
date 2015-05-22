//
//  ApplySuccessController.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/5/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ApplySuccessController.h"

@interface ApplySuccessController ()

@end

@implementation ApplySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    // Do any additional setup after loading the view.
    [self setupNavBar];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavBar
{
    self.title = @"申请成为合作伙伴";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBarHidden = NO;
}

-(void)initAndLayoutUI
{
    CGFloat width;
    CGFloat height;
    if (iOS7) {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }else{
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"applySuccess"];
    imageV.frame = CGRectMake(width / 2 - 30, 100, 70, 70);
    [self.view addSubview:imageV];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"合作伙伴申请提交成功";
    firstLabel.font = [UIFont boldSystemFontOfSize:25];
    firstLabel.frame = CGRectMake(width / 2 - 120, CGRectGetMaxY(imageV.frame) + 30, 300, 40);
    [self.view addSubview:firstLabel];
    
    UIFont *mainFont = [UIFont boldSystemFontOfSize:15];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.font = mainFont;
    secondLabel.text = @"华尔街金融平台欢迎您的加入";
    secondLabel.frame = CGRectMake(CGRectGetMinX(firstLabel.frame) + 30, CGRectGetMaxY(firstLabel.frame) + 40, 200, 25);
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.font = mainFont;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"我们的工作人员会在一个工作日内与您联系"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,9)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(15,4)];
    [str addAttribute:NSFontAttributeName value:mainFont range:NSMakeRange(0, 9)];
    [str addAttribute:NSFontAttributeName value:mainFont range:NSMakeRange(9, 6)];
    [str addAttribute:NSFontAttributeName value:mainFont range:NSMakeRange(15, 4)];
    thirdLabel.attributedText = str;
    thirdLabel.frame = CGRectMake(CGRectGetMinX(firstLabel.frame) - 10, CGRectGetMaxY(secondLabel.frame), 300, 25);
    [self.view addSubview:thirdLabel];
    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.font = mainFont;
    fourthLabel.text = @"请保持您的手机畅通";
    fourthLabel.frame = CGRectMake(CGRectGetMinX(firstLabel.frame) + 50, CGRectGetMaxY(thirdLabel.frame), 140, 25);
    [self.view addSubview:fourthLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundColor:kMainColor];
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(fourthLabel.frame.origin.x, CGRectGetMaxY(fourthLabel.frame) + 30, 140, 40);
    [self.view addSubview:backBtn];
}

-(void)backClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
