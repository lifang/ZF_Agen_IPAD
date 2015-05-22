//
//  AddressSelectViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "AddressSelectCell.h"

@protocol SelectedAddressDelegate <NSObject>

- (void)getSelectedAddress:(AddressModel *)addressModel;

@end

@interface AddressSelectViewController : CommonViewController

@property (nonatomic, assign) id<SelectedAddressDelegate>delegate;

@property (nonatomic, strong) NSString *addressID; //当前选择的地址id

@property (nonatomic, strong) NSMutableArray *addressItems;


@end
