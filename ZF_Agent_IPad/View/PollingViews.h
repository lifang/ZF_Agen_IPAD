//
//  PollingViews.h
//  iPadff
//
//  Created by comdosoft on 15/3/28.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@interface PollingViews : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SMPageControl *pageControl;

@property (nonatomic, assign) NSInteger totalPage;

- (void)downloadImageWithURLs:(NSArray *)urlArray
                       target:(id)target
                       action:(SEL)action;

@end
