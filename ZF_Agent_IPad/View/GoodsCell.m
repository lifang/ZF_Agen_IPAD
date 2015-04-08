//
//  GoodsCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/29.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

- (void)initAndLayoutUI {
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 10.f;
    CGFloat topSpace = 10.f;
    
    CGFloat hSpace = 20.f;   //距图片水平间距
    CGFloat vSpace = 4.f;
    
    CGFloat pictureSize = 110.f;  //图片大小
    
    CGFloat attrViewWidth = 30.f;
    CGFloat attrViewHeight = 10.f;
    
    CGFloat priceWidth = 120.f;
    
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
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.f]];
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
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
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
                                                                  constant:-rightSpace]];
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
                                                                  constant:attrViewWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_attrView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:attrViewHeight]];
    //价格
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _priceLabel.textColor = kColor(255, 102, 36, 1);
    [self.contentView addSubview:_priceLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_attrView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:priceWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
    //销售量
    _salesVolumeLabel = [[UILabel alloc] init];
    _salesVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _salesVolumeLabel.backgroundColor = [UIColor clearColor];
    _salesVolumeLabel.font = [UIFont systemFontOfSize:12.f];
    _salesVolumeLabel.textColor = kColor(177, 176, 176, 1);
    [self.contentView addSubview:_salesVolumeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_attrView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_priceLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_salesVolumeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
    
    //品牌
    _brandLabel = [[UILabel alloc] init];
    _brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.font = [UIFont systemFontOfSize:11.f];
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
                                                                    toItem:_priceLabel
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
    _channelLabel.font = [UIFont systemFontOfSize:11.f];
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
    
}


//- (void)layoutSubviews {
////    if (self.isEditing) {
//        for (UIView *view in self.subviews) {
//            if ([view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
//                for (UIImageView *imageView in view.subviews) {
//                    
////                    if (self.isSelected) {
////                        imageView.image = kImageName(@"red.png");
////                    }
////                    else {
////                        imageView.image = kImageName(@"orange.png");
////                    }
//                }
//            }
//        }
////    }
//    [super layoutSubviews];
//}
//
//- (void)willTransitionToState:(UITableViewCellStateMask)state {
//    [super willTransitionToState:state];
//    NSLog(@"will");
//}
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//    NSLog(@"did");
//    [super didTransitionToState:state];
//}

@end
