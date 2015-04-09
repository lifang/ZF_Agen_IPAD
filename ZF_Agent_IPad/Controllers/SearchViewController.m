//
//  SearchViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryHelper.h"
#import "ZFSearchBar.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "GoodListModel.h"
#import "GoodDetailViewController.h"
#import "BasicNagigationController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyItems;
@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, strong) NSMutableArray *dataItemid;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataItem = [[NSMutableArray alloc] initWithCapacity:0];
    _dataItemid = [[NSMutableArray alloc] initWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self gethotname];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];

    
    // Do any additional setup after loading the view.
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;


    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(dismiss:)];
    UIBarButtonItem *rightItems = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,rightItem, spaceItem,nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,spaceItem, rightItems,nil];

    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    [self initSearchBar];
    [self initContentView];
    
    _historyItems = [[NSMutableArray alloc] init];
    [self getSearchHistory];
}

- (void)initSearchBar {
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
     
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, wide, 30)];
    _searchBar.delegate = self;
    _searchBar.text = _keyword;
    self.navigationItem.titleView = _searchBar;
    [_searchBar becomeFirstResponder];
}

- (void)initContentView {
    
    
   }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UIView*bigview=[[UIView alloc]init];
    
    NSInteger A=self.historyItems.count;
    
    NSInteger B=_dataItem.count;
    
    
    
    
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
    
    if(A>B)
    {
        
        
        bigview.frame=CGRectMake(0, 0, wide, A/2*60+80);
        
    }
    else
    {
        bigview.frame=CGRectMake(0, 0, wide, B/2*60+80);
        
        
    }

  
    UILabel*latestlable=[[UILabel alloc]initWithFrame:CGRectMake(40, 49,100, 30)];
    [bigview addSubview:latestlable];
    
    latestlable.text=@"最近搜索";
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(40, 80, wide/2-80, 1)];
    witeview.backgroundColor=[UIColor grayColor];
    
    [bigview addSubview:witeview];
    
    
    
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanButton.frame = CGRectMake(wide/2-40-40, 49, 40, 30);
    
    [cleanButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cleanButton setTitle:@"清空" forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(clearSearchHistoy:) forControlEvents:UIControlEventTouchUpInside];
    [bigview addSubview:cleanButton];
    
    
    
    for(int i=0;i<_historyItems.count;i++)
    {
        NSInteger samallwide;
        
        
        samallwide=wide/4-40;
        UIButton *latesuibutton = [UIButton buttonWithType:UIButtonTypeCustom];
        latesuibutton.frame = CGRectMake(40+i%2*samallwide, 90+i/2*40, samallwide, 30);
        latesuibutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        latesuibutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
         [latesuibutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        latesuibutton.tag=i;
        
        [latesuibutton setTitle:[_historyItems objectAtIndex:i] forState:UIControlStateNormal];
        [latesuibutton addTarget:self action:@selector(lastebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [bigview addSubview:latesuibutton];
    
    }
    
    

    
    UILabel*hotlable=[[UILabel alloc]initWithFrame:CGRectMake(40+wide/2, 49,100, 30)];
    [bigview addSubview:hotlable];
    
    hotlable.text=@"热门推荐";
    
    UIView*hotline=[[UIView alloc]initWithFrame:CGRectMake(40+wide/2, 80, wide/2-80, 1)];
    hotline.backgroundColor=[UIColor grayColor];
    
    [bigview addSubview:hotline];
    
    
    
    
    
    
    for(int i=0;i<_dataItem.count;i++)
    {
        NSInteger samallwide;
        
        
        samallwide=wide/4-40;
        UIButton *hotbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        hotbutton.frame = CGRectMake(40+wide/2+i%2*samallwide, 90+i/2*40, samallwide, 30);
        hotbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        hotbutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [hotbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        hotbutton.tag=i+502;

        [hotbutton setTitle:[_dataItem objectAtIndex:i] forState:UIControlStateNormal];
        [hotbutton addTarget:self action:@selector(hotdetalbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [bigview addSubview:hotbutton];
        
    }
    

    
    
    

    
    return bigview;
    
    
    
    
}
-(void)hotdetalbuttonclick:(UIButton*)send
{
     
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    
   detailC.hidesBottomBarWhenPushed =  YES ;
    
    detailC.goodID =[_dataItemid objectAtIndex:send.tag-502];
    [self.navigationController pushViewController:detailC animated:YES];

}

//发送邮箱
-(void)gethotname
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface hotget: nil finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    [self parseDataWithDictionary:object];

                
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else
            {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
    
}
- (void)parseDataWithDictionary:(NSDictionary *)dict {

    if (![dict objectForKey:@"result"] ) {
        return;
    }
    
    NSArray *goodList = [dict objectForKey:@"result"];
    
    
    for (int i = 0; i < [goodList count]; i++)
    
    {
        [_dataItem addObject:[[goodList objectAtIndex:i] objectForKey:@"title"]];
        [_dataItemid addObject:[[goodList objectAtIndex:i] objectForKey:@"id"]];

    }
    
    [_tableView reloadData];
}

-(void)lastebuttonclick:(UIButton*)send
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showbar" object:self userInfo:nil];


    self.searchBar.text = [_historyItems objectAtIndex:send.tag];
    [self searchWithString:self.searchBar.text];


}
//- (void)setHeaderAndFooterView {
//    if ([_historyItems count] > 0) {
//        CGFloat wide;
//        CGFloat height;
//        if(iOS7)
//        {
//            wide=SCREEN_HEIGHT;
//            height=SCREEN_WIDTH;
//            
//            
//        }
//        else
//        {  wide=SCREEN_WIDTH;
//            height=SCREEN_HEIGHT;
//            
//        }
//
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 60)];
//        footerView.backgroundColor = [UIColor clearColor];
//        UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cleanButton.frame = CGRectMake((wide - 120) / 2, 10, 120, 28);
//        cleanButton.layer.cornerRadius = 4;
//        cleanButton.layer.masksToBounds = YES;
//        cleanButton.layer.borderWidth = 1.f;
//        cleanButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
//        [cleanButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
//        cleanButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [cleanButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
//        [cleanButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
//        [cleanButton addTarget:self action:@selector(clearSearchHistoy:) forControlEvents:UIControlEventTouchUpInside];
//        [footerView addSubview:cleanButton];
//        _tableView.tableFooterView = footerView;
//    }
//    else {
//        UIView *footerView = [[UIView alloc] init];
//        footerView.backgroundColor = [UIColor clearColor];
//        _tableView.tableFooterView = footerView;
//    }
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSInteger A=self.historyItems.count;
    
    NSInteger B=_dataItem.count;
    CGFloat height;
    if(iOS7)
    {
        height=SCREEN_WIDTH;
        
        
    }
    else
    {
        height=SCREEN_HEIGHT;
        
    }


    if(A>B)
    {
    
        if(A/2*60+80>height)
        {
        
            return    A/2*60+80;

        }
        else
        {
            return   height;
            
        
        }
    

    }
    else
    {
        if(B/2*60+80>height)
        {
            
            return    B/2*60+80;
            
        }
        else
        {
            return   height;
            
            
        }

    
    }
    

}
#pragma mark - Action

- (IBAction)dismiss:(id)sender {
    [self searchWithString:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showbar" object:self userInfo:nil];

    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 数据

- (void)getSearchHistory {
    NSMutableArray *searchArray = [SearchHistoryHelper getGoodsHistory];
    if (searchArray) {
        self.historyItems = searchArray;
    }
    [_tableView reloadData];
}

- (IBAction)clearSearchHistoy:(id)sender {
    [self.historyItems removeAllObjects];
    [SearchHistoryHelper removeGoodsHistory];
    [_tableView reloadData];
}

- (void)saveSearchHistory {
    if (![self.historyItems containsObject:self.searchBar.text]) {
        [self.historyItems addObject:self.searchBar.text];
        //保存搜索历史到本地
        [SearchHistoryHelper saveGoodsHistory:self.historyItems];
        [_tableView reloadData];
    }
}

- (void)searchWithString:(NSString *)string {
    if (_delegate && [_delegate respondsToSelector:@selector(getSearchKeyword:)]) {
        [_delegate getSearchKeyword:string];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"search");
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"!!");
    [self saveSearchHistory];
    [self searchWithString:self.searchBar.text];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"History";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = [_historyItems objectAtIndex:indexPath.row];
    [self searchWithString:self.searchBar.text];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView && _searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

@end
