//
//  SearchTermianlViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSearchBar.h"

@protocol SearchDelegate <NSObject>

- (void)getSearchKeyword:(NSString *)keyword;

@end

@interface SearchTermianlViewController : UIViewController

@property (nonatomic, assign) id<SearchDelegate>delegate;

@property (nonatomic, strong) NSString *keyword;

@end
