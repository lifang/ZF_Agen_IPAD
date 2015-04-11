//
//  ScanImageViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/20.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"

@interface ScanImageViewController : CommonViewController

- (void)showDetailImageWithURL:(NSString *)urlString imageRect:(CGRect)rect WithIdentifier:(NSString *)Identifier;

- (void)showDetailImageWithImg:(UIImage *)imageV imageRect:(CGRect)rect;

@end
