//
//  AddressSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AddressSelectViewController.h"
#import "NetworkInterface.h"


@interface AddressSelectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddressSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择地址";
    //[self initAndLayoutUI];
    _addressItems=[[NSMutableArray alloc] init];
    
    
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    //headerView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(60);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@40);
    }];
    
    UILabel *reciverLB = [[UILabel alloc] init];
    [reciverLB setBackgroundColor:[UIColor clearColor]];
    [reciverLB setFont:[UIFont systemFontOfSize:20]];
    reciverLB.textColor= [UIColor colorWithHexString:@"292929"];
    reciverLB.text=@"收件人";
    reciverLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:reciverLB];
    [reciverLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.left).offset(26);
        make.right.equalTo(headerView.centerX);
        //make.width.equalTo(@120);
        
    }];
    
    UILabel *addressLB = [[UILabel alloc] init];
    [addressLB setBackgroundColor:[UIColor clearColor]];
    [addressLB setFont:[UIFont systemFontOfSize:20]];
    addressLB.textColor= [UIColor colorWithHexString:@"292929"];
    addressLB.text=@"地址";
    addressLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:addressLB];
    [addressLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.centerX);
        make.right.equalTo(headerView.right).offset(26);
        //make.width.equalTo(@120);
        
    }];
    
    
    _tableView= [[UITableView alloc] init];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-60);
    }];
   // [self getAddressList];

    if ([_addressItems count] <= 0) {
       [self getAddressList];
    }
}


#pragma mark - Request

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
    [_addressItems removeAllObjects];
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [_addressItems addObject:model];
    }
    NSLog(@"addressItems:%@",_addressItems);
    [_tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //内容Cell
    static NSString *identifier = @"Address";
    AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
    AddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddressSelectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setAddressSelectModel:model andTarget:self];
    if ([model.addressID isEqualToString:_addressID]) {
        cell.selectedImageView.hidden = NO;
    }
    else {
        cell.selectedImageView.hidden = YES;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedAddress:)]) {
        [_delegate getSelectedAddress:model];
      [self.navigationController popViewControllerAnimated:YES];
    
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
