//
//  ZYHomeViewController.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "PollingView.h"
#import "BasicNagigationController.h"
#import "NetworkInterface.h"
#import "HomeImageModel.h"
#import "ChannelWebsiteController.h"
#import "AppDelegate.h"
#import "TerminalViewController.h"
#import "GoodListViewController.h"
#import "OrderManagerController.h"
#import "DealRoadController.h"
#import "StockManagerController.h"
#import "UserManagerController.h"
#import "IdentificationViewController.h"
#import "AfterSellController.h"
#import "GoodDetailViewController.h"

@interface ZYHomeViewController ()
@property(nonatomic,strong)PollingView *pollingView;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityId;
@property (nonatomic, strong) NSMutableArray *pictureItem;
@property (nonatomic, strong) NSString *downurl;

@end

@implementation ZYHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pictureItem = [[NSMutableArray alloc] init];
    [self loadHomeImageList];
    
    UIView*vei=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH -60, SCREEN_HEIGHT )];
    [self.view addSubview:vei];
    if(iOS8)
    {
        rootview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH -60, SCREEN_HEIGHT )];
        [self.view addSubview:rootview];
        rootview.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        rootview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT -60, SCREEN_WIDTH )];
        [self.view addSubview:rootview];
        NSLog(@"%f",SCREEN_WIDTH);
        rootview.backgroundColor=[UIColor whiteColor];
    }
    [self initNavigationView];
    [self checkVersion];
}
//#pragma mark - Request

- (void)loadHomeImageList {
    [NetworkInterface getHomeImageListFinished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self parseImageDataWithDict:object];
                }
            }
        }
    }];
}

#pragma mark - Data

- (void)parseImageDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id imageList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    [_pictureItem removeAllObjects];
    for (int i = 0; i < [imageList count]; i++) {
        id imageDict = [imageList objectAtIndex:i];
        if ([imageDict isKindOfClass:[NSDictionary class]]) {
            HomeImageModel *model = [[HomeImageModel alloc] initWithParseDictionary:imageDict];
            [_pictureItem addObject:model];
        }
    }
    NSMutableArray *urlList = [[NSMutableArray alloc] init];
    for (HomeImageModel *model in _pictureItem) {
        [urlList addObject:model.pictureURL];
    }
    [_pollingView downloadImageWithURLs:urlList target:self action:@selector(tapPicture:)];
    
}
- (void)tapPicture:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)[tap view];
    NSInteger index = imageView.tag - 1;
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    detailC.hidesBottomBarWhenPushed =  YES ;
    detailC.supplyType=2;
    if (index >= 0 && index < [_pictureItem count]) {
        HomeImageModel *imageModel = [_pictureItem objectAtIndex:index];
        detailC.goodID = imageModel.goodId;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

-(void)initPollingView
{
    //图片比例 40:17
    
    if(iOS7)
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(-3, 0, SCREEN_HEIGHT, SCREEN_WIDTH*0.4+65)];
    }
    else
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(-3, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.4+65)];
    }
    [rootview addSubview:_pollingView];
}
- (void)initNavigationView {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
    }
    else
    {
        wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
    }
    UIImageView *topViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wide, 58)];
 
    topViews.image = kImageName(@"toptouming");
    [self.view addSubview:topViews];

    UIImageView *topView = [[UIImageView alloc] init ];
    topView.image = kImageName(@"home_logo.png");
    [self.view addSubview:topView];
    
    UIImageView *itemImageView = [[UIImageView alloc]init ];
    itemImageView.image = kImageName(@"home_right.png");
    [self.view addSubview:itemImageView];
    
    
    if(iOS7)
    {
        topView.frame = CGRectMake(SCREEN_HEIGHT/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_HEIGHT/2+15, 25, 119, 30);
        
    }
    else
    {
        topView.frame = CGRectMake(SCREEN_WIDTH/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_WIDTH/2+15, 25, 119, 30);
    }
    
    [self initModuleView];
    [self initPollingView];

}

- (void)initModuleView {
       NSArray *nameArray = [NSArray arrayWithObjects:
                          @"我要进货",
                          @"订单管理",
                          @"终端管理",
                          @"交易流水",
                          @"库存管理",
                          @"用户管理",
                          @"售后记录",
                          @"开通认证",
                          nil];
    for(NSInteger i=0;i<8;i++)
    {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    
        button.tag=i+1000;
        
        [self.view addSubview:button];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home%ld",i+1]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tarbarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
        UILabel*lable=[[UILabel alloc]init];
        lable.text=[nameArray objectAtIndex:i];
        lable.textColor=[UIColor grayColor];
        
        if(i<4)
        {
//            button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i+1)-32,SCREEN_HEIGHT/2+50,  64, 64);
//            lable.frame=CGRectMake((2*i+1)*(SCREEN_WIDTH-60)/8-32,SCREEN_HEIGHT/2+110,  80, 54);
            
            if(iOS7)
            {
                
                button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i+1)-32,SCREEN_WIDTH/2+50,  64, 64);
                lable.frame=CGRectMake((2*i+1)*(SCREEN_HEIGHT-60)/8-38,SCREEN_WIDTH/2+110,  90, 54);
                
                if (button.tag==1000) {
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)* 1.6, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                    
                    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x-40, CGRectGetMaxY(button.frame)+50, SCREEN_HEIGHT-156, 2)];
                    line2.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line2];
                    
                }
                if (button.tag==1001) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.2, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }
                if (button.tag==1002) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.15, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }
            }
        
            else
                
            {
                button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i+1)-32,SCREEN_HEIGHT/2+50,  64, 64);
                lable.frame=CGRectMake((2*i+1)*(SCREEN_WIDTH-60)/8-38,SCREEN_HEIGHT/2+110,  90, 54);
                if (button.tag==1000) {
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)* 1.6, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x-40, CGRectGetMaxY(button.frame)+50, SCREEN_WIDTH -156, 2)];
                    line2.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line2];
                    
                }
                if (button.tag==1001) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.2, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }
                if (button.tag==1002) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.15, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }

            }

        }
        
        else
            
        {
            
            if(iOS7)
            {
                lable.frame=CGRectMake((2*i-7)*(SCREEN_HEIGHT-60)/8-32,SCREEN_WIDTH/2+250,  80, 54);
                button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i-7)-32,SCREEN_WIDTH/2+200,  64, 64);
            }
            
            else
                
            {
                
                lable.frame=CGRectMake((2*i-7)*(SCREEN_WIDTH-60)/8-32,SCREEN_HEIGHT/2+250,  80, 54);
                
                button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i-7)-32,SCREEN_HEIGHT/2+200,  64, 64);
            }
        }
        
        [self.view addSubview:lable];
    }
    
}

#pragma mark - Action

- (void)tarbarClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1000: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthOrder]] boolValue]) {
                [delegate.rootViewController.homeController setSeletedIndex:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newrefsh" object:nil];
            }else
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有进货权限";

            }
            
          }
            break;
        case 1001: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthOrder]] boolValue]) {
                OrderManagerController *OrderManager = [[OrderManagerController alloc]init];
                OrderManager.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:OrderManager animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有订单权限";
            }
        }
            break;
        case 1002: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthTM_CS]] boolValue]) {
                //终端管理
                TerminalViewController *terminalVC = [[TerminalViewController alloc]init];
                terminalVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:terminalVC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有终端管理权限";
            }
        }
            break;
        case 1003: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthT_B]] boolValue]) {
                //交易流水
                DealRoadController *DealRoad = [[DealRoadController alloc]init];
                DealRoad.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:DealRoad animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有交易流水权限";
            }
        }
            break;
        case 1004: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthStock]] boolValue]) {
                StockManagerController *stockVC = [[StockManagerController alloc]init];
                stockVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:stockVC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有库存管理权限";
            }
            
        }
            break;
        case 1005: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthUM]] boolValue]) {
                UserManagerController *userVC = [[UserManagerController alloc]init];
                userVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userVC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有用户管理权限";
            }
            
        }
            break;
        case 1006: {
            AppDelegate *delegate = [AppDelegate shareAppDelegate];
            if ([[delegate.authDict objectForKey:[NSNumber numberWithInt:AuthTM_CS]] boolValue]) {
                AfterSellController *afterVC = [[AfterSellController alloc]init];
                afterVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:afterVC animated:YES];
            }
            else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = @"您没有售后权限";
            }
        }
            break;
        case 1007: {
            IdentificationViewController *identificationVC = [[IdentificationViewController alloc]init];
            identificationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:identificationVC animated:YES];
        }
            break;
        default:
            break;
    }
}


//检测版本
-(void)checkVersion
{
    
    [NetworkInterface checkVersionFinished:^(BOOL success, NSData *response) {
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"版本:%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]])
            {
                
              int errorCode = [[object objectForKey:@"code"] intValue];
              if (errorCode == RequestSuccess)
                {
                    //成功
                    [self parseappVersionWithDictionary:object];
                }
            }
        }
       
    }];
}

-(void)parseappVersionWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"]isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSDictionary *info=[dic objectForKey:@"result"];
    int versions=[[info objectForKey:@"versions"] intValue];
    NSString *localVersion=[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    _downurl=[info objectForKey:@"down_url"];
    
    if ([localVersion intValue] < versions)
    {
        // 有更新
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"发现新版本,您确定要更新?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
}


/*
 //AppStore 更新
 -(void)checkVersion
 {
 
     _downurl = @"https://itunes.apple.com/app/id1015219698";
     NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
     NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
     NSArray *localVersionComponents = [localVersion componentsSeparatedByString:@"."];
 
     NSString *strURL=[[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=1015219698"];
     NSURL *url=[NSURL URLWithString:strURL];
 
     NSData *postData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
 
     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:postData];
 
     NSOperationQueue *queue=[NSOperationQueue mainQueue];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data) {//请求成功
             NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
             NSLog(@"%@",dict);
             NSString *error=dict[@"error"];
             if (error) {
 
             }
             else
             {
                 NSArray *infoArray = [dict objectForKey:@"results"];
                 if ([infoArray count]) {
                     NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                     NSString *AppStoreVersion = [releaseInfo objectForKey:@"version"];
                     NSArray *AppStoreVersionComponents = [AppStoreVersion componentsSeparatedByString: @"."];
 
                     if ([localVersionComponents count] == 3 && [AppStoreVersionComponents count] == 3)
                     {
                         if ([AppStoreVersionComponents[0] integerValue] > [localVersionComponents[0] integerValue])
                         { // A.b.c
                             [self displayUpdateMessage];
                         }
                         else if([AppStoreVersionComponents[1] integerValue] > [localVersionComponents[1] integerValue])
                         { // a.B.c
                             [self displayUpdateMessage];
                         }
                         else if([AppStoreVersionComponents[2] integerValue] > [localVersionComponents[2] integerValue])
                         { // a.b.C
                             [self displayUpdateMessage];
                         }
                     }
                 }
             }
         }
     }];
 }
 
 
 
 -(void)displayUpdateMessage
 {
 
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                         message:@"发现新版本，是否前往下载？"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"前往下载", nil];
     [alertView show];
 
 }
 
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==!alertView.cancelButtonIndex)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_downurl]];
    }
}


@end
