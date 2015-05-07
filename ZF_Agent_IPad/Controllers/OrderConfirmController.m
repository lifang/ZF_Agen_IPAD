//
//  OrderConfirmController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "KxMenu.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
//#import "ZYCustomTabBarViewController.h"

@interface OrderConfirmController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderConfirmController
- (void)viewWillAppear:(BOOL)animated
{
    
   
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    ZYCustomTabBarViewController *tarbar=[[ZYCustomTabBarViewController alloc] init];
    tarbar.tabBarController.tabBar.hidden=YES;
   

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"订单确认";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    addressarry=[[NSMutableArray alloc]initWithCapacity:0];
    [self getAddressList];
    _billType = BillTypeCompany;
//    [self getAddressList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAddressList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseAddressListDataWithDict:object];
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

- (void)parseAddressListDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        
        
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [addressarry addObject:model];
        
    }
    [self initAndLauoutUI];

}
#pragma mark - UI


- (void)initAndLauoutUI {
    
    
    
    CGFloat footerHeight = 60.f;
    _detailFooterView = [[UIView alloc] init];
    _detailFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    _detailFooterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailFooterView];
    
   
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_detailFooterView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self  footerViewAddSubview];
    
    
 
}

- (void)footerViewAddSubview {
  
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-64;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-64;
        height=SCREEN_HEIGHT;
        
    }

    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide+64, 1)];
    firstLine.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:firstLine];
    CGFloat space = 10.f;
    CGFloat btnWidth = 100.f;
    CGFloat btnHeight = 36.f;
    
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 10, wide - space * 3 - btnWidth-40, 20)];
    _payLabel.backgroundColor = [UIColor clearColor];
    _payLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _payLabel.textAlignment = NSTextAlignmentRight;
    [_detailFooterView addSubview:_payLabel];
    
    _deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 30, wide - space * 3 - btnWidth-40, 20)];
    _deliveryLabel.backgroundColor = [UIColor clearColor];
    _deliveryLabel.font = [UIFont systemFontOfSize:14.f];
    _deliveryLabel.textAlignment = NSTextAlignmentRight;
    [_detailFooterView addSubview:_deliveryLabel];
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(wide - space - btnWidth-40, 12, btnWidth, btnHeight);
//    ensureButton.layer.cornerRadius = 4.f;
    ensureButton.layer.masksToBounds = YES;
    [ensureButton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    [ensureButton setTitle:@"结算" forState:UIControlStateNormal];
    ensureButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [ensureButton addTarget:self action:@selector(ensureOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_detailFooterView addSubview:ensureButton];
}




#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (IBAction)ensureOrder:(id)sender {
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

//监听事件  子类重写
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification {
    
}

- (void)handleKeyboardDidHidden {
    
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
