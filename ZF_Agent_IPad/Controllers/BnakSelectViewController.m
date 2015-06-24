//
//  BnakSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "BnakSelectViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "MJRefresh.h"


@interface BnakSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *bankField;

@property (nonatomic, strong) UIButton *searchBtn;

//@property (nonatomic, strong) NSMutableArray *searchItem; //搜索结果

@property (nonatomic, assign) int page;


@end

@implementation BnakSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择银行";
    self.view.backgroundColor=[UIColor whiteColor];
    shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(0, 0, 30, 30);
    [shoppingButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    //    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    
    
    
    //设置间距
    shoppingButtons = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButtons.frame = CGRectMake(0, 0, 110, 30);
    [shoppingButtons setTitle:@"使用我的输入" forState:UIControlStateNormal];
    shoppingButtons.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight ;//设置文字位置，现设为居左，默认的是居中
    
    //    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    shoppingButtons.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [shoppingButtons addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];

    
    UIBarButtonItem*shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingButton];
    UIBarButtonItem *shoppingItems= [[UIBarButtonItem alloc] initWithCustomView:shoppingButtons];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shoppingItem,shoppingItems,nil];
    //if (!_bankItems) {
    _bankItems = [[NSMutableArray alloc] init];
        //[self getBankList];
   // }
    
   // _searchItem = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)goShoppingCart
{
    if ([self isBlankString:_bankField.text])
        
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入银行名称";
        return;
    }

    BankModel *model=[[BankModel alloc]init];
    model.isSelected = YES;
    model.bankName=_bankField.text;
    model.bankCode=@"";

    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedBank:)])
    {
        [_delegate getSelectedBank:model];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
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
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 84)];
    _headerView.backgroundColor = [UIColor clearColor];
   // _tableView.tableHeaderView = headerView;
    [self.view addSubview:_headerView];
    
    CGFloat backHeight = 44.f;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, wide, backHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:backView];
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, kLineHeight)];
    firstLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:firstLine];
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, backHeight - kLineHeight, wide, kLineHeight)];
    secondLine.backgroundColor = kColor(200, 199, 204, 1);
    [backView addSubview:secondLine];
    
    _bankField = [[UITextField alloc] init];
    _bankField.frame = CGRectMake(20, 0, wide - 100, backHeight);
    _bankField.font = [UIFont systemFontOfSize:15.f];
    _bankField.placeholder = @"请输入银行名称";
    _bankField.delegate = self;
    _bankField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:_bankField];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(wide - 40, 10, 24, 24);
    [_searchBtn setBackgroundImage:kImageName(@"search.png") forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchBank:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_searchBtn];
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];

    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [_tableView addHeaderWithTarget:self action:@selector(firstLoadData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
 
    
}



-(void)loadMoreData
{
 [self getBankListWithPage:_page isMore:YES];

}

#pragma mark - Request

- (void)firstLoadData {
    
    _page = 1;
   [self getBankListWithPage:_page isMore:NO];
    
}


- (void)getBankListWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    [NetworkInterface chooseBankWithToken:delegate.token keyword:_bankField.text page:1 pageSize:15 terminalId:_terminalID finished:^(BOOL success, NSData *response) {

        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_bankItems removeAllObjects];
                    }
                    
                    id list = nil;
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        list = [[object objectForKey:@"result"] objectForKey:@"content"];
                    }
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        _page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseBankListWithDictionary:object];
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

- (void)parseBankListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *bankList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [bankList count]; i++) {
        id bankDict = [bankList objectAtIndex:i];
        if ([bankDict isKindOfClass:[NSDictionary class]]) {
            BankModel *model = [[BankModel alloc] initWithParseDictionary:bankDict];
            [_bankItems addObject:model];
            }
    }
    NSLog(@"bankItems:%@",_bankItems);
    [_tableView reloadData];

}

/*
- (void)clearStatus {
    for (BankModel *model in _searchItem) {
        model.isSelected = NO;
    }
}
*/

#pragma mark - Action

- (void)searchBank:(id)sender {
    [_bankField resignFirstResponder];
    if (!_bankField.text || [_bankField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入银行名";
        return;
    }

    /*
    [_searchItem removeAllObjects];
    for (BankModel *model in _bankItems) {
        if ([model.bankName rangeOfString:_bankField.text].length != 0) {
            [_searchItem addObject:model];
        }
    }
    [_tableView reloadData];
     */
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bankItems count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Terminal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BankModel *model = [_bankItems objectAtIndex:indexPath.row];
    cell.textLabel.text = model.bankName;
    cell.imageView.image = kImageName(@"btn_selected");
    if (model.isSelected) {
        cell.imageView.hidden = NO;
    }
    else {
        cell.imageView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self clearStatus];
   
    BankModel *model = [_bankItems objectAtIndex:indexPath.row];
    model.isSelected = YES;
    [_tableView reloadData];
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedBank:)]) {
     [_delegate getSelectedBank:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([_bankItems count] <= 0) {
            return nil;
        }
        else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 30)];
            view.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenHeight - 20, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = @"搜索结果";
            [view addSubview:label];
            return view;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchBank:nil];
    return YES;
}



-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"terminaliD:%@",_terminalID);

}

@end
