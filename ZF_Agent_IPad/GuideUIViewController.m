//
//  GuideUIViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/28.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "GuideUIViewController.h"
#import "AppDelegate.h"

@interface GuideUIViewController ()

@property (nonatomic, strong) UIButton *useBtn;
@property (nonatomic, strong) UIButton *applyBtn;

@end

@implementation GuideUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    float wide;
    float high;
    
    if (iOS7) {
        wide=SCREEN_HEIGHT;
        high=SCREEN_WIDTH;
        
    }
    else
    {
        wide=SCREEN_WIDTH;
        high=SCREEN_HEIGHT;
        
    }
    
    NSArray *arr=[NSArray arrayWithObjects:@"pad1.png",@"pad2.png",@"pad3.png",@"pad4.png", nil];
    //数组内存放的是我要显示的假引导页面图片
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize=CGSizeMake(wide*arr.count, high);
    scrollView.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [scrollView addSubview:img];
    }
    
    
    _useBtn=[[UIButton alloc] init];
    _useBtn.frame=CGRectMake(254+wide*3, high-78-50, (wide-507-77)/2.0, 50);
    _useBtn.layer.masksToBounds=YES;
    _useBtn.layer.borderWidth=10.0;
    _useBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_useBtn setTitle:@"马上使用" forState:UIControlStateNormal];
    [_useBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    //[_useBtn setBackgroundImage:[UIImage imageNamed:@"usedBtn.png"] forState:UIControlStateNormal];
    [_useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_useBtn];
    
    
    _applyBtn=[[UIButton alloc] init];
    _applyBtn.frame=CGRectMake(254+wide*3+(wide-507-77)/2.0+77, high-78-50, (wide-507-77)/2.0, 50);
    _applyBtn.layer.masksToBounds=YES;
    _applyBtn.layer.borderWidth=10.0;
    //_applyBtn.layer. =10.0;
    _applyBtn.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
    [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyBtn setTitle:@"申请成为代理商" forState:UIControlStateNormal];
    [_applyBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
    [_applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_applyBtn];

    
}


-(void)useBtnClick:(id)sender
{
    //[self removeFromParentViewController];
    //[self presentViewController:[[RootViewController alloc] init] animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)applyBtnClick:(id)sender
{
    
    //[self presentViewController:[[RootViewController alloc] init] animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"gotoRegisterNotification" object:self];
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
