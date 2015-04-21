//
//  AddressSelectCell.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "NetworkInterface.h"

@interface AddressSelectCell : UITableViewCell

@property(strong,nonatomic) UIView * backView;

@property(strong,nonatomic) UILabel * reciverLB;

@property(strong,nonatomic) UILabel * addressLB;

@property (nonatomic, strong) UILabel *defaultLabel;

@property (nonatomic, strong) UIImageView *selectedImageView;


@property(strong,nonatomic) AddressModel * AddressModel;

@property(weak,nonatomic) id superTarget;

-(void)setAddressSelectModel:(AddressModel *)AddressModel andTarget:(id)target;


@end
