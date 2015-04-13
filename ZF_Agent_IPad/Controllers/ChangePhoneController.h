//
//  ChangePhoneController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePhoneSuccessDelegate <NSObject>

@optional
-(void)ChangePhoneNumSuccessWithNewPhoneNum:(NSString *)newPhoneNum;

@end

@interface ChangePhoneController : UIViewController

@property(nonatomic,strong)NSString *oldPhoneNum;

@property(nonatomic,weak)id ChangePhoneSuccessDelegate;

@end
