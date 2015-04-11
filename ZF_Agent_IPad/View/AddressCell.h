//
//  AddressCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressCellDelegate <NSObject>

@optional

-(void)changeBtnClicked:(NSString *)selectedID WithIndex:(int)indexP;

@end

@interface AddressCell : UITableViewCell

@property(nonatomic,strong)UILabel *consigneeLabel;

@property(nonatomic,strong)UILabel *areaLabel;

@property(nonatomic,strong)UILabel *particularAddressLabel;

@property(nonatomic,strong)UILabel *postcodeLabel;

@property(nonatomic,strong)UILabel *telLabel;

@property(nonatomic,strong)UILabel *defaultLabel;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,strong)NSString *selectID;

@property(nonatomic,assign)int indexP;

@property(nonatomic,weak)id AddressCellDelegate;

@end
