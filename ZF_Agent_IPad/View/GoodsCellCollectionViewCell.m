
//
//  GoodsCellCollectionViewCell.m
//  ipad
//
//  Created by comdosoft on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GoodsCellCollectionViewCell.h"


@implementation GoodsCellCollectionViewCell

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
    CGFloat leftSpace = 50.f;
    CGFloat rightSpace = 10.f;
    CGFloat topSpace = 30.f;
    
    CGFloat hSpace = 20.f;   //距图片水平间距
    CGFloat vSpace = 4.f;
    
    CGFloat pictureSize = 110.f;  //图片大小
    
    CGFloat attrViewWidth = 30.f;
    CGFloat attrViewHeight = 13.f;
    
    CGFloat priceWidth = 120.f;
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }

    
    
    //图片框
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace+30]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
  
  
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-wide/2-60]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:40.f]];
    //图标
    _attrView = [[UIImageView alloc] init];
    _attrView.image = kImageName(@"good_rent.png");
    _attrView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_attrView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attrView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attrView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attrView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:50]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attrView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:17]];
    //价格
    if(iOS7)
    {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2, 40, 150, 30)];
        
        _newpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2, 70, 150, 30)];
        _lastnumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2, 110, 180, 30)];

        _salesVolumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-140, 60, 100, 30)];
        
        self.bigimages=[[UILabel alloc]initWithFrame:CGRectMake(_pictureView.frame.origin.x+80, 0, SCREEN_HEIGHT-_pictureView.frame.origin.x-120, 20)];
       

        self.pricelable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT/2, -5, 80, 30)];
        
        self.salemorelable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-170, -5, 80, 30)];
    }
    else
    {
    
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 40, 150, 30)];
        
        _newpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 70, 150, 30)];
        _lastnumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 110, 180, 30)];
        _salesVolumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 60, 100, 30)];
  self.bigimages=[[UILabel alloc]initWithFrame:CGRectMake(_pictureView.frame.origin.x+80, 0, SCREEN_WIDTH-_pictureView.frame.origin.x-120, 20)];
        
        self.pricelable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, -5, 80, 30)];
        
        self.salemorelable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, -5, 80, 30)];
    }
    
    
//    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _priceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_priceLabel];
    _lastnumber.backgroundColor = [UIColor clearColor];
    _lastnumber.font = [UIFont boldSystemFontOfSize:16.f];
    _lastnumber.textColor = [UIColor grayColor];
    [self.contentView addSubview:_lastnumber];
    _newpriceLabel.backgroundColor = [UIColor clearColor];
    _newpriceLabel.font = [UIFont boldSystemFontOfSize:20.f];
    _newpriceLabel.textColor = kColor(233, 91, 38, 1);
    [self.contentView addSubview:_newpriceLabel];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_pictureView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:hSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_attrView
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:vSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:priceWidth]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:20.f]];
    //销售量
//    _salesVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _salesVolumeLabel.backgroundColor = [UIColor clearColor];
    _salesVolumeLabel.font = [UIFont systemFontOfSize:16.f];
   _salesVolumeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_salesVolumeLabel];
    
    [self addSubview:self.bigimages];
    self.bigimages.hidden=YES;
    self.bigimages.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    
    
    
  
    
    

//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:-5.f]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_attrView
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:vSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_priceLabel
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:0.f]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:20.f]];
//    
    //品牌
    _brandLabel = [[UILabel alloc] init];
    _brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_brandLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_attrView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:15.f]];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    _channelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_channelLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:15.f]];
    
    
    self.bigtitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bigimages.frame.origin.x+140, 0, 100, 20)];
    [self addSubview:self.bigtitleLabel];
    self.bigtitleLabel.textAlignment=NSTextAlignmentCenter;
    self.bigtitleLabel.text=@"商品";
    self.bigtitleLabel.hidden=YES;
    self.bigtitleLabel.font = [UIFont boldSystemFontOfSize:16.f];

 

    [self addSubview:self.pricelable];
    self.pricelable.textAlignment=NSTextAlignmentCenter;
    self.pricelable.font = [UIFont boldSystemFontOfSize:16.f];
    self.pricelable.text=@"价格";
    self.pricelable.hidden=YES;
    
    
    [self addSubview:self.salemorelable];
    self.salemorelable.textAlignment=NSTextAlignmentCenter;
    self.salemorelable.font = [UIFont boldSystemFontOfSize:16.f];
    self.salemorelable.text=@"历史销量";
    self.salemorelable.hidden=YES;
    
    self.rootline=[[UILabel alloc]initWithFrame:CGRectMake(self.bigimages.frame.origin.x,165, self.bigimages.frame.size.width, 1)];
    self.rootline.backgroundColor=[UIColor grayColor];
    
    
    [self addSubview:self.rootline];

}


@end
