//
//  ZYHomeViewController.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "LocationButton.h"
#import "PollingView.h"
#import "GoodListViewController.h"
#import "BasicNagigationController.h"
#import "LocationViewController.h"
#import "NetworkInterface.h"
#import "HomeImageModel.h"
#import "ChannelWebsiteController.h"
#import "AppDelegate.h"

@interface ZYHomeViewController ()<sendCity,CLLocationManagerDelegate>
@property(nonatomic,strong)PollingView *pollingView;
@property(nonatomic,strong)LocationViewController *locationVC;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)LocationButton *locationBtn;
@property (nonatomic, strong) NSMutableArray *pictureItem;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ZYHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    _locationVC.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)sendCity:(NSString *)city WithCity_id:(NSString *)city_id
{
    _cityName = city;
    _cityId = city_id;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pictureItem = [[NSMutableArray alloc] init];
    [self loadHomeImageList];
    
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    locationVC.hidesBottomBarWhenPushed = YES;
    self.locationVC = locationVC;
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
    [self getUserLocation];
    [self initNavigationView];
}
#pragma mark - Request

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
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *imageList = [dict objectForKey:@"result"];
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
    
    
    
    LocationButton *rightBtn = [[LocationButton alloc]init];
    self.locationBtn = rightBtn;
    [_locationBtn addTarget:self action:@selector(locationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if(iOS7)
    {
        topView.frame = CGRectMake(SCREEN_HEIGHT/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_HEIGHT/2+15, 25, 119, 30);
               rightBtn.frame = CGRectMake(SCREEN_HEIGHT-180, itemImageView.frame.origin.y, 60, 30);
        
    }
    else
    {
        topView.frame = CGRectMake(SCREEN_WIDTH/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_WIDTH/2+15, 25, 119, 30);
        

        rightBtn.frame = CGRectMake(SCREEN_WIDTH-180, itemImageView.frame.origin.y, 60, 30);
        
        
    }
    [self.view addSubview:rightBtn];
    
    [self initModuleView];
    [self initPollingView];

}

-(void)locationClicked:(id)sender
{
    [self.navigationController pushViewController:_locationVC animated:YES];
}
- (void)initModuleView {
       NSArray *nameArray = [NSArray arrayWithObjects:
                          @"选择POS机",
                          @" 开通认证",
                          @"终端管理",
                          @" 交易流水",
                          @"我要贷款",
                          @"我要理财",
                          @"系统公告",
                          @"联系我们",
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
            //选择POS机
            GoodListViewController *listC = [[GoodListViewController alloc] init];
            listC.hidesBottomBarWhenPushed =  YES ;
           [self.navigationController pushViewController:listC animated:YES];
        }
            break;
        case 1001: {
            //开通认证
            
        }
            break;
        case 1002: {
            //终端管理
           
        }
            break;
        case 1003: {
            //交易流水
           
        }
            break;
        case 1004: {
            //我要贷款
        }
            break;
        case 1005: {
            //我要理财
        }
            break;
        case 1006: {
            //系统公告
           
        }
            break;
        case 1007: {
            //联系我们
        
        }
            break;
        default:
            break;
    }
}
#pragma mark - 定位

- (void)getUserLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        //在ios 8.0下要授权
        if (kDeviceVersion >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.locality;
                [self getCurrentCityInfoWithCityName:cityName];
            }
        }
    }];
}

- (void)getCurrentCityInfoWithCityName:(NSString *)cityName {
    CityModel *currentCity = nil;
    for (CityModel *model in [CityHandle shareCityList]) {
        if ([cityName rangeOfString:model.cityName].length != 0) {
            currentCity = model;
            break;
        }
    }
    if (currentCity) {
        _locationBtn.nameLabel.text = currentCity.cityName;
    }
    else {
        _locationBtn.nameLabel.text = @"定位失败";
    }
}

- (void)getSelectedLocation:(CityModel *)selectedCity {
    if (selectedCity) {
        _locationBtn.nameLabel.text = selectedCity.cityName;
    }
    else {
        _locationBtn.nameLabel.text = @"定位失败";
    }
}

@end
