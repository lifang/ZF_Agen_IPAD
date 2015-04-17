//
//  PayWayViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PayWayViewController.h"

@interface PayWayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"选择支付方式";
    NSLog(@"!!!!!!!!!!%@~~~~~~~~~~~~~%f",_orderID,_totalPrice);
    
   [self setHeaderAndFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    CGFloat hearderHeight = 160.f;
    CGFloat blackViewHeight = 130.f;
    UIView *headerView = [[UIView alloc] init];
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
    


      headerView.frame=CGRectMake(0, 0, wide, hearderHeight+20);
        
    

//    headerView.backgroundColor = kColor(244, 243, 243, 1);
    [self.view addSubview:headerView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, blackViewHeight+20)];
    blackView.backgroundColor = kColor(33, 32, 42, 1);
    [headerView addSubview:blackView];
    
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, topSpace, wide - leftSpace - rightSpace, 20.f)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = @"付款金额";
    [blackView addSubview:infoLabel];
    //金额
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 60, wide - leftSpace - rightSpace, 60.f)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont boldSystemFontOfSize:48.f];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice/100];
    [blackView addSubview:priceLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, hearderHeight +40, wide - leftSpace - rightSpace, 20.f)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = kColor(150, 150, 150, 1);
    typeLabel.font = [UIFont systemFontOfSize:14.f];
    typeLabel.text = @"选择支付方式";
    [self.view addSubview:typeLabel];
    
    
    
    UIButton *zhifubao = [[UIButton alloc]init];
   
    [zhifubao addTarget:self action:@selector(zhifubaoclick) forControlEvents:UIControlEventTouchUpInside];
    zhifubao.backgroundColor = [UIColor clearColor];
    [zhifubao setBackgroundImage:[UIImage imageNamed:@"zhifubao"] forState:UIControlStateNormal];
       zhifubao.frame = CGRectMake(0,0,200,62);
    zhifubao.center=CGPointMake(wide/4, hearderHeight +40+80);
    
    [headerView addSubview:zhifubao];
    UIButton *yinlianbutton = [[UIButton alloc]init];
    
    [yinlianbutton addTarget:self action:@selector(yinlianclick) forControlEvents:UIControlEventTouchUpInside];
    yinlianbutton.backgroundColor = [UIColor clearColor];
    [yinlianbutton setBackgroundImage:[UIImage imageNamed:@"yinlian"] forState:UIControlStateNormal];
    yinlianbutton.frame = CGRectMake(0,0,200,62);
    yinlianbutton.center=CGPointMake(wide/4*3, hearderHeight +40+80);
    
    [headerView addSubview:yinlianbutton];

}
-(void)zhifubaoclick
{


}
-(void)yinlianclick
{
    
    
}
//- (void)initAndLauoutUI {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.backgroundColor = kColor(244, 243, 243, 1);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self setHeaderAndFooterView];
//    [self.view addSubview:_tableView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//}
//
//#pragma mark - UITableView
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    NSString *title = nil;
//    switch (indexPath.section) {
//        case 0:
//            title = @"支付宝";
//            break;
//        case 1:
//            title = @"银联";
//            break;
//        default:
//            break;
//    }
//    cell.textLabel.text = title;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5.f;
//}

@end
