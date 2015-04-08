//
//  SearchViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ZFSearchBar.h"

@protocol SearchDelegate <NSObject>

- (void)getSearchKeyword:(NSString *)keyword;

@end

@interface SearchViewController : CommonViewController

@property (nonatomic, assign) id<SearchDelegate>delegate;

@property (nonatomic, strong) NSString *keyword;

@end
