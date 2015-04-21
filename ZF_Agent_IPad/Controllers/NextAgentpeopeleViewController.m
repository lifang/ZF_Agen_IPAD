//
//  NextAgentpeopeleViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/17.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "NextAgentpeopeleViewController.h"
#import "OpenProfitViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "SubAgentDetailModel.h"
@interface NextAgentpeopeleViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isopen;
@property (nonatomic, strong) SubAgentDetailModel *agentDetail;
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
    _scrollView.contentSize=CGSizeMake(wide, 1100);
    
    
    [self.view addSubview:_scrollView];
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    
    
    
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 80, 30);
    
    [filterButton setTitle:@"设置分润" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(setOPenProfirclick) forControlEvents:UIControlEventTouchUpInside];
    filterButton.hidden=YES;

    
    spaceItem.width = 52;
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,shoppingItem,spaceItem,spaceItem,nil];

    [self getSubAgentDetail];
    
    // Do any additional setup after loading the view.
}
-(void)setOPenProfirclick
{
    
    OpenProfitViewController*openV=[[OpenProfitViewController alloc]init];
    openV.hidesBottomBarWhenPushed=YES;
    openV.subAgentID = _subAgent.agentID;

    [self.navigationController pushViewController:openV animated:YES];
    
    
    
    
    
}
-(void)openclick
{
    _isopen=!_isopen;
    
    if(_isopen)
    {
        filterButton.hidden=NO;

        [openbutton setImage:kImageName(@"open") forState:UIControlStateNormal];
        
    }else
    {
        filterButton.hidden=YES;

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
    
    
    
    
    NSArray*namesarry1=[NSArray arrayWithObjects:@"代理商类型：个人",[NSString stringWithFormat:@"负责人姓名: %@", _agentDetail.personName],[NSString stringWithFormat:@"负责人身份证号: %@", _agentDetail.personID],[NSString stringWithFormat:@"手机: %@", _agentDetail.mobilePhone],[NSString stringWithFormat:@"邮箱: %@", _agentDetail.email],[NSString stringWithFormat:@"所在地: %@ %@", _agentDetail.provinceName,_agentDetail.cityName],[NSString stringWithFormat:@"详细地址: %@", _agentDetail.address],nil];
    for(int i=0;i<namesarry1.count;i++)
    {
        
        
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+40,wide/2, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry1 objectAtIndex:i];
        
        
    }
    NSArray*namesarry2=[NSArray arrayWithObjects:@"身份证照片",nil];
    for(int i=0;i<namesarry2.count;i++)
    {
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+600,wide/2, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry2 objectAtIndex:i];
        
        
        UIButton* addressbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        addressbutton.frame = CGRectMake(wide/2+70,i*60+600,35, 35);
        
        
        //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addressbutton setBackgroundImage:kImageName(@"ppicture") forState:UIControlStateNormal];
        
        
        [addressbutton addTarget:self action:@selector(pictureclick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:addressbutton];
        
        
        addressbutton.tag=i+418;
        
        
        
    }
    UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(60, 680,wide-120, 1)];
    
    line.backgroundColor=[UIColor grayColor];
    
    [_scrollView addSubview:line];
    
    
    
    UILabel*idlable=[[UILabel alloc]initWithFrame:CGRectMake(60, 720,wide/2, 30)];
    idlable.textAlignment = NSTextAlignmentRight;
    
    idlable.text=[NSString stringWithFormat:@"登录ID: %@", _agentDetail.loginName];
    
    [_scrollView addSubview:idlable];
    
    
    
    
    NSArray*namesarry6=[NSArray arrayWithObjects:[NSString stringWithFormat:@"加入时间: %@", _agentDetail.createTime],[NSString stringWithFormat:@"已售出: %d", _agentDetail.saleCount],[NSString stringWithFormat:@"剩余库存: %d", _agentDetail.remainCount],[NSString stringWithFormat:@"终端开通量: %d", _agentDetail.openCount], nil];
    
    
    for(int i=0;i<namesarry6.count;i++)
    {
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, i*60+770,wide/2, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentRight;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry6 objectAtIndex:i];
        
        
        
        
        
        
        
    }

//    UIButton* savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    savebutton.frame = CGRectMake(wide/2-200,1300,280, 40);
//    
//    savebutton.center=CGPointMake(wide/2, 900);
//    
//    UILabel*line2=[[UILabel alloc]initWithFrame:CGRectMake(60, 820,wide-120, 1)];
//    
//    line2.backgroundColor=[UIColor grayColor];
//    
//    [_scrollView addSubview:line2];
//    
//    
//    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
//    
//    //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
//    
//    
//    [savebutton addTarget:self action:@selector(sexclick) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:savebutton];
    
    
    
}
-(void)pictureclick:(UIButton*)send
{
    
    
    
    
}

#pragma mark - Request

- (void)getSubAgentDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getSubAgentDetailWithToken:delegate.token subAgentID:_subAgent.agentID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseAgentDetailWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseAgentDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _agentDetail = [[SubAgentDetailModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    [self createui];

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
