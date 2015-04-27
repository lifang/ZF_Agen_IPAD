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

@interface ZYHomeViewController ()
@property(nonatomic,strong)PollingView *pollingView;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityId;
@property (nonatomic, strong) NSMutableArray *pictureItem;


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
    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
    if (index >= 0 && index < [_pictureItem count]) {
        HomeImageModel *imageModel = [_pictureItem objectAtIndex:index];
        websiteC.title = @"详情";
        websiteC.urlString = imageModel.websiteURL;
        websiteC.hidesBottomBarWhenPushed =  YES ;
        [self.navigationController pushViewController:websiteC animated:YES];
    }
}

-(void)initPollingView
{
    //图片比例 40:17
    
    if(iOS7)
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH*0.4+65)];
    }
    else
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.4+65)];
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
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home%d",i+1]] forState:UIControlStateNormal];
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

            [delegate.rootViewController.homeController setSeletedIndex:1];
            
        }
            break;
        case 1001: {
            
            OrderManagerController *OrderManager = [[OrderManagerController alloc]init];
            OrderManager.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:OrderManager animated:YES];

            
            //开通认证
            
            
        }
            break;
        case 1002: {
            //终端管理
            TerminalViewController *terminalVC = [[TerminalViewController alloc]init];
            terminalVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:terminalVC animated:YES];
           
        }
            break;
        case 1003: {
            //交易流水
            DealRoadController *DealRoad = [[DealRoadController alloc]init];
            DealRoad.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:DealRoad animated:YES];
            

        }
            break;
        case 1004: {
            StockManagerController *stockVC = [[StockManagerController alloc]init];
            stockVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockVC animated:YES];
        }
            break;
        case 1005: {
            UserManagerController *userVC = [[UserManagerController alloc]init];
            userVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userVC animated:YES];
        }
            break;
        case 1006: {
            //系统公告
            AfterSellController *afterVC = [[AfterSellController alloc]init];
            afterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:afterVC animated:YES];
           
        }
            break;
        case 1007: {
            IdentificationViewController *identificationVC = [[IdentificationViewController alloc]init];
            identificationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:identificationVC animated:YES];
            //开通认证

        
        }
            break;
        default:
            break;
    }
}


@end
