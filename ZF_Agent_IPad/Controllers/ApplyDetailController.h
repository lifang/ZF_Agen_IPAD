//
//  ApplyDetailController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ScanImageViewController.h"
static NSString *key_selected = @"key_selected";
static NSString *key_name = @"key_name";
static NSString *key_merchantName = @"key_merchantName";
static NSString *key_sex = @"key_sex";
static NSString *key_birth = @"key_birth";
static NSString *key_cardID = @"key_cardID";
static NSString *key_phone = @"key_phone";
static NSString *key_email = @"key_email";
static NSString *key_location = @"key_location";
static NSString *key_bank = @"key_bank";
static NSString *key_bankID = @"key_bankID";
static NSString *key_bankAccount = @"key_bankAccount";
static NSString *key_taxID = @"key_taxID";
static NSString *key_organID = @"key_organID";
static NSString *key_channel = @"key_channel";

typedef enum {
    OpenStatusNew = 1,  //开通
    OpenStatusReopen,   //重新开通
}OpenStatus;

@interface ApplyDetailController : ScanImageViewController
{ UIButton* accountnamebutton;
    NSInteger sexint;
    UIButton* _cityField ;
    UIButton* birthdaybutton;
    UIDatePicker *datePicker;
    UIButton *makeSureBtn;
    UIButton* locationbutton;
    NSArray*keynamesarry;
    NSInteger pickint;
    UIButton* bankbutton ;
    UIButton* zhifubutton;
    
    
}

@property (nonatomic, strong) NSString *terminalID;
@property (nonatomic, assign) OpenStatus openStatus;
@end
