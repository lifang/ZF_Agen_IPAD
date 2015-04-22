//
//  SearchTermianlViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "SearchTermianlViewController.h"
#import "ZFSearchBar.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "BasicNagigationController.h"
#import "TerminalSelectModel.h"

@interface SearchTermianlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyItems;



@end

@implementation SearchTermianlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

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
 
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,5,wide-300,30)];

    _searchBar.backgroundColor =kColor(3, 112, 214, 1);
//    [_searchBar setBarTintColor:[UIColor clearColor]];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,wide-200,44)];
    //_searchBar.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [_searchBar setBarTintColor:[UIColor colorWithHexString:@"006fd5"]];
    _searchBar.delegate = self;
    _searchBar.text = _keyword;
    [_searchBar setPlaceholder:@"搜索终端"];
    
    for (UIView *subview in _searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;  
        }
        // for later iOS7.0(include)
        if ([subview isKindOfClass:NSClassFromString(@"UIView")] && subview.subviews.count > 0) {
            [[subview.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
 
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wide-300, 44)];
    //searchView.backgroundColor = [UIColor colorWithHexString:@"006fd5"];
//    searchView.backgroundColor = kColor(3, 112, 214, 1);
    searchView.backgroundColor = [UIColor colorWithHexString:@"006fd5"];
    //searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    [_searchBar becomeFirstResponder];
    
}

/*
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tintColor = [UIColor whiteColor];
    }
}
*/


- (void)setFooterView {
    if ([_historyItems count] > 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanButton.frame = CGRectMake((kScreenWidth - 120) / 2, 10, 120, 28);
        cleanButton.layer.cornerRadius = 4;
        cleanButton.layer.masksToBounds = YES;
        cleanButton.layer.borderWidth = 1.f;
        cleanButton.layer.borderColor = kMainColor.CGColor;
        [cleanButton setTitleColor:kMainColor forState:UIControlStateNormal];
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [cleanButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [cleanButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
        [cleanButton addTarget:self action:@selector(clearSearchHistoy:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:cleanButton];
        _tableView.tableFooterView = footerView;
    }
    else {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerView;
    }
}





#pragma mark - 数据

- (void)getSearchHistory {
   
    [self getTerminalsHistory];
    [self setFooterView];
    [_tableView reloadData];

   
}


- (void)clearSearchHistoy:(id)sender {
    [_historyItems removeAllObjects];
    [self removeTerminalsHistory];
    [self setFooterView];
    [_tableView reloadData];
}

 

- (void)saveSearchHistory {
    if (![_historyItems containsObject:self.searchBar.text]) {
        [_historyItems addObject:self.searchBar.text];
        //保存搜索历史到本地
        [self saveTerminalsHistory:_historyItems];
        
    }
}



#pragma mark - SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
   
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    [self saveSearchHistory];
    [self searchRequest];
   
}


-(void)searchRequest
{
    _keyword=_searchBar.text ;
   // if (_delegate && [_delegate respondsToSelector:@selector(getSearchKeyword:)]) {
        [_delegate getSearchKeyword:_keyword];
   // }
    [self.navigationController popViewControllerAnimated:YES];

}



#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"batchTerminal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=[_historyItems objectAtIndex:indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _searchBar.text = [_historyItems objectAtIndex:indexPath.row];
    [self searchRequest];
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




-(void)searchHistoyDirectory {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *historyDirectory = [document stringByAppendingPathComponent:kHistory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyDirectory]) {
        [fileManager createDirectoryAtPath:historyDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(void)getTerminalsHistory {
  
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *historyDirectory = [document stringByAppendingPathComponent:kHistory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyDirectory]) {
        [fileManager createDirectoryAtPath:historyDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *path = [historyDirectory stringByAppendingPathComponent:kHistoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _historyItems = [unarchiver decodeObjectForKey:kKey];
    }
}

-(void)saveTerminalsHistory:(NSMutableArray *)terminalsHistory {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *historyDirectory = [document stringByAppendingPathComponent:kHistory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyDirectory]) {
        [fileManager createDirectoryAtPath:historyDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *path = [historyDirectory stringByAppendingPathComponent:kHistoryPath];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:terminalsHistory forKey:kKey];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

-(void)removeTerminalsHistory {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *historyDirectory = [document stringByAppendingPathComponent:kHistory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:historyDirectory]) {
        [fileManager createDirectoryAtPath:historyDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *path = [historyDirectory stringByAppendingPathComponent:kHistoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}



@end
