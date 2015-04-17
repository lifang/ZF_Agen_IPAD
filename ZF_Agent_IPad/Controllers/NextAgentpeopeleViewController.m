//
//  NextAgentpeopeleViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/17.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "NextAgentpeopeleViewController.h"

@interface NextAgentpeopeleViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isopen;
@end

@implementation NextAgentpeopeleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame=CGRectMake(0, 0, wide, height);
    _scrollView.contentSize=CGSizeMake(wide, 1500);
    
    
    [self.view addSubview:_scrollView];
    
    [self createui];
    
    
    // Do any additional setup after loading the view.
}
-(void)openclick
{
    _isopen=!_isopen;
    
    if(_isopen)
    {
        [openbutton setImage:kImageName(@"open") forState:UIControlStateNormal];
        
    }else
    {
        
        [openbutton setImage:kImageName(@"close") forState:UIControlStateNormal];
        
        
    }
    
    
    
    
}
-(void)createui
{
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    
    UILabel*openlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-160-90,43,80, 40)];
    [_scrollView addSubview:openlable];
    openlable.textAlignment = NSTextAlignmentRight;
    //    newaddress.font=[UIFont systemFontOfSize:18];
    
    openlable.text=@"开通分润";
    openbutton= [UIButton buttonWithType:UIButtonTypeCustom];
    openbutton.frame = CGRectMake(wide-160,40,80, 46);
    [openbutton addTarget:self action:@selector(openclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:openbutton];
    
    if(_isopen)
    {
        [openbutton setImage:kImageName(@"open") forState:UIControlStateNormal];
        
    }else
    {
        
        [openbutton setImage:kImageName(@"close") forState:UIControlStateNormal];
        
        
    }
    
    
    
    
    NSArray*namesarry1=[NSArray arrayWithObjects:@"代理商类型",@"负责人姓名",@"负责人身份证号",@"手机", @"邮箱",@"所在地",@"详细地址",nil];
    for(int i=0;i<namesarry1.count;i++)
    {
        
        
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+100,wide/2-270, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry1 objectAtIndex:i];
        
        
    }
    NSArray*namesarry2=[NSArray arrayWithObjects:@"身份证照片",nil];
    for(int i=0;i<namesarry2.count;i++)
    {
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+600,wide/2-270, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry2 objectAtIndex:i];
        
        
        UIButton* addressbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        addressbutton.frame = CGRectMake(wide/2-200,i*60+600,35, 35);
        
        
        //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addressbutton setBackgroundImage:kImageName(@"ppicture") forState:UIControlStateNormal];
        
        
        [addressbutton addTarget:self action:@selector(pictureclick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:addressbutton];
        
        
        addressbutton.tag=i+418;
        
        
        
    }
    UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60, 680,wide-120, 1)];
    
    line.backgroundColor=[UIColor grayColor];
    
    [_scrollView addSubview:line];
    
    
    
    UILabel*idlable=[[UILabel alloc]initWithFrame:CGRectMake(60, 720,wide/2-270, 30)];
    idlable.textAlignment = NSTextAlignmentRight;
    
    idlable.text=@"登录ID";
    
    [_scrollView addSubview:idlable];
    
    
    UIButton* savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(wide/2-200,1300,280, 40);
    
    savebutton.center=CGPointMake(wide/2, 860);
    
    UILabel*line2=[[UILabel alloc]initWithFrame:CGRectMake(60, 860,wide-120, 1)];
    
    line2.backgroundColor=[UIColor grayColor];
    
    [_scrollView addSubview:line2];
    
    
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    
    //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    
    
    [savebutton addTarget:self action:@selector(sexclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:savebutton];
    
    
    
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
