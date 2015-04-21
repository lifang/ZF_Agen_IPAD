//
//  SearchTermianlViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "SearchTermianlViewController.h"
//#import "SearchHistoryHelper.h"
#import "ZFSearchBar.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "BasicNagigationController.h"
#import "TerminalSelectModel.h"

@interface SearchTermianlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyItems;
@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, strong) NSMutableArray *dataItemid;

@property (nonatomic, strong) NSMutableArray *terminalList;


@end

@implementation SearchTermianlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataItem = [[NSMutableArray alloc] initWithCapacity:0];
    _dataItemid = [[NSMutableArray alloc] initWithCapacity:0];
    _terminalList = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor=[UIColor whiteColor];
    //
    
    
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
    
       [self initAndLayoutUI];

}
#pragma mark - UI

- (void)initAndLayoutUI {
    [self initSearchBar];
   
    
   // _historyItems = [[NSMutableArray alloc] init];
    //[self getSearchHistory];
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
 
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,wide-300,44)];
    _searchBar.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [_searchBar setBarTintColor:[UIColor colorWithHexString:@"006fd5"]];
    _searchBar.delegate = self;
    _searchBar.text = _keyword;
    [_searchBar setPlaceholder:@"搜索"];
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wide-300, 44)];
    //searchView.backgroundColor = [UIColor colorWithHexString:@"006fd5"];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    [_searchBar becomeFirstResponder];
    
}





//搜索终端
- (void)searchTerminal {
    NSMutableArray *terminals = [[NSMutableArray alloc] init];
    if (_keyword && ![_keyword isEqualToString:@""]) {
        [terminals addObject:_keyword];
    }
    NSLog(@"terminals:%@",terminals);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface batchTerminalNumWithtoken:delegate.token serialNum:terminals finished:^(BOOL success, NSData *response) {
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
                    [self parseSearchListWithData:object];
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


- (void)parseSearchListWithData:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_terminalList removeAllObjects];
    NSArray *serialList = [dict objectForKey:@"result"];
    for (int i = 0; i < [serialList count]; i++) {
        id serialDict = [serialList objectAtIndex:i];
        if ([serialDict isKindOfClass:[NSDictionary class]]) {
            TerminalSelectModel *model = [[TerminalSelectModel alloc] initWithParseDictionary:serialDict];
            [_terminalList addObject:model];
        }
        NSLog(@"terminalList:%@",_terminalList);
    }
    [_tableView reloadData];
    //[self refreshSelectedInfo];
}




-(void)lastebuttonclick:(UIButton*)send
{
    
    self.searchBar.text = [_historyItems objectAtIndex:send.tag];
    [self searchWithString:self.searchBar.text];
    
    
}
#pragma mark - Action

- (void)dismiss:(id)sender {
    [self searchWithString:nil];
    [self popoverPresentationController];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"showbar" object:self userInfo:nil];
    
   // [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 数据
/*
- (void)getSearchHistory {
    NSMutableArray *searchArray = [SearchHistoryHelper getGoodsHistory];
    if (searchArray) {
        self.historyItems = searchArray;
    }
    [_tableView reloadData];
}

- (void)clearSearchHistoy:(id)sender {
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
*/

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
   // [self saveSearchHistory];
   // [self searchWithString:_searchBar.text];
   // _keyword = keyword;
   // _searchBar.text = _keyword;
     _keyword=_searchBar.text ;
     [self searchTerminal];
}




#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"batchTerminal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    TerminalSelectModel *model = [_terminalList objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=model.retail_price;
    cell.detailTextLabel.text=model.serial_num;
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //self.searchBar.text = [_historyItems objectAtIndex:indexPath.row];
    //[self searchWithString:self.searchBar.text];
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


- (void)getSearchKeyword:(NSString *)keyword {
    _keyword = keyword;
    _searchBar.text = _keyword;
    [self searchTerminal];
}

@end
