//
//  ChangeEmailController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeEmailSuccessDelegate <NSObject>

@optional
-(void)ChangeEmailSuccessWithEmail:(NSString *)newEmail;

@end

@interface ChangeEmailController : UIViewController

@property(nonatomic,strong)NSString *oldEmail;

@property(nonatomic,strong)NSString *oldAuthCode;

@property(nonatomic,weak)id ChangeEmailSuccessDelegate;
@end
