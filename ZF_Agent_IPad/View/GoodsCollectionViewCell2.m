//
//  GoodsCollectionViewCell2.m
//  iPadff
//
//  Created by comdosoft on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GoodsCollectionViewCell2.h"

@implementation GoodsCollectionViewCell2
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        
    {
        [self initAndLayoutUI];
        
    }
    return self;
}

- (void)initAndLayoutUI {
    
    //图片框
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 220, 220)];
    [self.contentView addSubview:_pictureView];
        //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pictureView.frame.origin.x, _pictureView.frame.origin.y+_pictureView.frame.size.height, _pictureView.frame.size.width, 25)];

    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
   
    //图标
//    _attrView = [[UIImageView alloc] initWithFrame:CGRectMake(_pictureView.frame.origin.x, _pictureView.frame.origin.y, _pictureView.frame.size.width, 30)];
//    _attrView.image = kImageName(@"good_rent.png");
//    [self.contentView addSubview:_attrView];
        //价格
    
    //销售量
    
    //品牌
//    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _pictureView.frame.size.width, 30)];
//    _brandLabel.backgroundColor = [UIColor clearColor];
//    _brandLabel.font = [UIFont systemFontOfSize:11.f];
//    [self.contentView addSubview:_brandLabel];
    
    //支付通道
    _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _pictureView.frame.size.width, 25)];
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.textColor=[UIColor grayColor];
    
    _channelLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_channelLabel];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_channelLabel.frame.origin.x, _channelLabel.frame.origin.y+_channelLabel.frame.size.height, _channelLabel.frame.size.width, 25)];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _priceLabel.textColor = kColor(255, 102, 36, 1);
    [self.contentView addSubview:_priceLabel];

    _salesVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x+_channelLabel.frame.size.width-110, _channelLabel.frame.origin.y+_priceLabel.frame.size.height, 80, 25)];
    _salesVolumeLabel.textAlignment=NSTextAlignmentRight;
    
    _salesVolumeLabel.backgroundColor = [UIColor clearColor];
    _salesVolumeLabel.font = [UIFont systemFontOfSize:14.f];
    _salesVolumeLabel.textColor = kColor(177, 176, 176, 1);
    [self.contentView addSubview:_salesVolumeLabel];
    

}

@end
