//
//  ChangePhoneController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"

@protocol ChangePhoneSuccessDelegate <NSObject>

@optional
-(void)ChangePhoneNumSuccessWithNewPhoneNum:(NSString *)newPhoneNum;

@end

@interface ChangePhoneController : CommonViewController

@property(nonatomic,strong)NSString *oldPhoneNum;

@property(nonatomic,strong)NSString *oldAuthCode;

@property(nonatomic,weak)id ChangePhoneSuccessDelegate;

@end
