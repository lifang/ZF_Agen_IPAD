//
//  GoodsCell.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kGoodCellHeight  136.f

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface GoodsCell : UITableViewCell

//图片框
@property (nonatomic, strong) UIImageView *pictureView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//销售量
@property (nonatomic, strong) UILabel *salesVolumeLabel;
//品牌型号
@property (nonatomic, strong) UILabel *brandLabel;
//支付通道
@property (nonatomic, strong) UILabel *channelLabel;

//是否可租赁
@property (nonatomic, strong) UIImageView *attrView;

@end
