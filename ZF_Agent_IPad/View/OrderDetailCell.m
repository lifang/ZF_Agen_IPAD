//
//  OrderDetailCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(SupplyGoodsType)supplyType {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _supplyType = supplyType;
        [self initAndLayoutUI];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)initAndLayoutUI {
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

    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 50.f;
    CGFloat labelHeight = 20.f;
    
    CGFloat imageSize = 100.f;
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    CGFloat primaryWidth = 100.f;
    if (_supplyType == SupplyGoodsProcurement) {
        primaryWidth = 0.f;
    }
    //商品名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-wide/2 - primaryWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    if (_supplyType == SupplyGoodsWholesale) {
        //原价
        _primaryPriceLabel = [[UILabel alloc] init];
       _primaryPriceLabel.textColor = [UIColor grayColor];

        _primaryPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _primaryPriceLabel.backgroundColor = [UIColor clearColor];
        _primaryPriceLabel.font = [UIFont systemFontOfSize:12.f];
        _primaryPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_primaryPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:topSpace]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-wide/2+50]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:primaryWidth]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryPriceLabel
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                      constant:14.f]];
    }
    //价格
    _actualPriceLabel = [[UILabel alloc] init];
    
    [self layoutGoodLabel:_actualPriceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight];
//    _actualPriceLabel.textColor = kColor(255, 102, 36, 1);
    _actualPriceLabel.font = [UIFont boldSystemFontOfSize:16.f];
    //数量
    _numberLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_numberLabel WithTopView:_actualPriceLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_numberLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:0.f alignment:NSTextAlignmentLeft];
}

- (void)layoutGoodLabel:(UILabel *)label
            WithTopView:(UIView *)topView
               topSpace:(CGFloat)space
              alignment:(NSTextAlignment)alignment {
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
    

    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 20.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = alignment;
    [self.contentView addSubview:label];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:space]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    
    if(label==_actualPriceLabel)
    {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-wide/2+50]];
    
    }
else
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-80]];
}
    
    
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

#pragma mark - Data

- (void)setContentsWithData:(OrderGoodModel *)data {
    self.nameLabel.text = data.goodName;
    if (_supplyType == SupplyGoodsWholesale) {
        NSString *primaryPrice =[NSString stringWithFormat:@"原价 ￥%.2f",data.goodPrimaryPrice];
        NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:primaryPrice];
        NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                                   [NSNumber numberWithInt:2],NSStrikethroughStyleAttributeName,
                                   nil];
        [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, [priceAttrString length])];
        self.primaryPriceLabel.attributedText = priceAttrString;
        
        self.primaryPriceLabel.textColor=[UIColor grayColor];
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.goodActualPirce];

        
    }
    else
    {
    
    
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.goodPrimaryPrice];

    
    }
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",data.goodCount];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",data.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",data.goodChannel];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:data.goodImagePath] placeholderImage:[UIImage imageNamed:@"test1" ]];
}

@end
