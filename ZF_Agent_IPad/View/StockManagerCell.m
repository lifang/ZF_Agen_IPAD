//
//  StockManagerCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StockManagerCell.h"

@implementation StockManagerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI
-(void)initAndLayoutUI
{
    CGFloat leftSpace = 20.f;
    CGFloat topSpace = 20.f;
    CGFloat mainLabelHeight = 30.f;
    UIColor *mainTextColor = kColor(51, 51, 51, 51);
    UIFont *mainFont = [UIFont systemFontOfSize:17];
    CGFloat pictureSize = 100.f;
    CGFloat mainMargin = 10.f;
    
    _stockPictureView = [[UIImageView alloc]init];
    _stockPictureView.translatesAutoresizingMaskIntoConstraints = NO;
    _stockPictureView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_stockPictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    
    _stockPosNameLabel = [[UILabel alloc]init];
    _stockPosNameLabel.text = @"泰山POS旗舰机器全集";
    _stockPosNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stockPosNameLabel.backgroundColor = [UIColor clearColor];
    _stockPosNameLabel.textAlignment = NSTextAlignmentLeft;
    _stockPosNameLabel.font = mainFont;
    _stockPosNameLabel.textColor = mainTextColor;
    [self.contentView addSubview:_stockPosNameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:mainMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:230.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:mainLabelHeight]];
    
    _brandGrayLabel = [[UILabel alloc]init];
    _brandGrayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _brandGrayLabel.text = @"品牌型号";
    _brandGrayLabel.textColor = kColor(77, 76, 76, 1.0);
    _brandGrayLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_brandGrayLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:mainMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:100.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:mainLabelHeight]];
    
    _channelGrayLabel = [[UILabel alloc]init];
    _channelGrayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _channelGrayLabel.text = @"支付通道";
    _channelGrayLabel.textColor = kColor(77, 76, 76, 1.0);
    _channelGrayLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_channelGrayLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelGrayLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockPictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:mainMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelGrayLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:- 7.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelGrayLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:100.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelGrayLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:mainLabelHeight]];
    
    _stockBrandLabel = [[UILabel alloc]init];
    _stockBrandLabel.textAlignment = NSTextAlignmentLeft;
    _stockBrandLabel.backgroundColor = [UIColor clearColor];
    _stockBrandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stockBrandLabel.text = @"泰山TS900";
    _stockBrandLabel.textColor = mainTextColor;
    _stockBrandLabel.font = mainFont;
    [self.contentView addSubview:_stockBrandLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockBrandLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant: - mainMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockBrandLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockPosNameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockBrandLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:140.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockBrandLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:mainLabelHeight]];
    
    _stockChannelLabel = [[UILabel alloc]init];
    _stockChannelLabel.textAlignment = NSTextAlignmentLeft;
    _stockChannelLabel.backgroundColor = [UIColor clearColor];
    _stockChannelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _stockChannelLabel.text = @"某某通道";
    _stockChannelLabel.textColor = mainTextColor;
    _stockChannelLabel.font = mainFont;
    [self.contentView addSubview:_stockChannelLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChannelLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_brandGrayLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant: - mainMargin]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChannelLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockBrandLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-7.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChannelLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:140.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChannelLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:mainLabelHeight]];
    
    //创建中间有规律的内容Cell
    _stockHistoryCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockHistoryCountLabel withLeftView:_stockBrandLabel middleSpace:-5.f labelTag:0];
    
    _stockOpenCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockOpenCountLabel withLeftView:_stockHistoryCountLabel middleSpace:15.f labelTag:0];
    
    _stockAgentCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockAgentCountLabel withLeftView:_stockOpenCountLabel middleSpace:15.f labelTag:0];
    
    _stockTotalCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockTotalCountLabel withLeftView:_stockAgentCountLabel middleSpace:15.f labelTag:0];
    
    _stockChangeBtn = [[UIButton alloc]init];
    _stockChangeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_stockChangeBtn setTitle:@"商品更名" forState:UIControlStateNormal];
    [_stockChangeBtn addTarget:self action:@selector(changeBrandName) forControlEvents:UIControlEventTouchUpInside];
    _stockChangeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_stockChangeBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    CALayer *readBtnLayer = [_stockChangeBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:1.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kMainColor CGColor]];
    _stockChangeBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_stockChangeBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChangeBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:50.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChangeBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_stockTotalCountLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:15.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChangeBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:110.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_stockChangeBtn
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:40.f]];

}
//创建左边Label
//leftView-左边控件
//space-距左边间距
- (void)setLabel:(UILabel *)label
     withLeftView:(UIView *)leftView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat topSpace = 55.f;
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 120.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = kColor(51, 51, 51, 51);
    [self.contentView addSubview:label];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:leftView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:space]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
}

#pragma mark - SetData
-(void)setContentWithData:(StockListModel *)model
{
    _stockModel = model;
    _stockPosNameLabel.text = model.stockTitle;
    _stockBrandLabel.text = [NSString stringWithFormat:@"%@%@",model.stockGoodBrand,model.stockGoodModel];
    _stockChannelLabel.text = model.stockChannel;
    _stockHistoryCountLabel.text = [NSString stringWithFormat:@"%d件",model.historyCount];
    _stockOpenCountLabel.text = [NSString stringWithFormat:@"%d件",model.openCount];
    _stockAgentCountLabel.text = [NSString stringWithFormat:@"%d件",model.agentCount];
    _stockTotalCountLabel.text = [NSString stringWithFormat:@"%d件",model.totalCount];
    [_stockPictureView sd_setImageWithURL:[NSURL URLWithString:model.stockImagePath]];
}

#pragma mark - Action
-(void)changeBrandName
{
    if (_delegate && [_delegate respondsToSelector:@selector(stockCellRenameForGood:)]) {
        [_delegate stockCellRenameForGood:_stockModel];
    }
}

@end
