//
//  FLViewController.h
//  SQLiteTest
//
//  Created by sp on 13-12-16.
//  Copyright (c) 2013年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FLViewController : UIViewController{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSString *displayMessage;
-(void)showLoding;
-(void)closeLoding;
- (void)showMessage:(NSString*)message viewHeight:(float)height;
-(void)showLodingWithFrame;
@end
