//
//  FLViewController.m
//  SQLiteTest
//
//  Created by sp on 13-12-16.
//  Copyright (c) 2013年 sp. All rights reserved.
//

#import "FLViewController.h"
#import "MBProgressHUD.h"

@interface FLViewController ()

@end

@implementation FLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMessage:(NSString*)message viewHeight:(float)height;
{
    if(self)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        //        hud.dimBackground = YES;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.yOffset = height;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}

-(void)showLoding{
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    //    HUD.dimBackground = YES;
	[self.view addSubview:HUD];
    if (self.displayMessage == nil)
    {
        HUD.labelText = @"正在加载...";
    }
    else
    {
        HUD.labelText = self.displayMessage;
    }
    [HUD show:YES];
}
-(void)showLodingWithFrame{
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    }
    //    HUD.dimBackground = YES;
    [self.view addSubview:HUD];
    if (self.displayMessage == nil)
    {
        HUD.labelText = @"正在加载...";
    }
    else
    {
        HUD.labelText = self.displayMessage;
    }
    [HUD show:YES];
}


-(void)closeLoding{
    if (HUD) {
        [HUD removeFromSuperview];
    }
}


- (void)setDisplayMessage:(NSString *)displayMessage
{
    _displayMessage = displayMessage;
    if (HUD)
    {
        HUD.labelText = displayMessage;
    }
}
@end
