//
//  LoginViewController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"

@protocol LoginSuccessDelegate <NSObject>

@optional
-(void)LoginSuccess;

@end

@interface LoginViewController : CommonViewController

@property(nonatomic,weak)id LoginSuccessDelegate;


@end
