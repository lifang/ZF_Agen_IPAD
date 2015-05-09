//
//  MerchantSelectCell.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/5/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

@interface MerchantSelectCell : UITableViewCell


@property(strong,nonatomic) UIView * backView;

@property(strong,nonatomic) UILabel * merchantLB;


@property(strong,nonatomic) MerchantModel * MerchantModel;

@property(weak,nonatomic) id superTarget;

-(void)setMerchantSelectModel:(MerchantModel *)MerchantModel andTarget:(id)target;



@end
