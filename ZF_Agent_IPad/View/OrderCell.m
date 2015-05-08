//
//  OrderCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderCell.h"

//按钮样式
static NSString *orderBtnStyleFirst = @"orderBtnStyleFirst";
static NSString *orderBtnStyleSecond = @"orderBtnStyleSecond";

typedef enum {
    BtnPositionLeft = 1,
    BtnPositionMiddle,
    BtnPositionRight,
}BtnPosition; //按钮位置

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(SupplyGoodsType)supplyType {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _identifier = reuseIdentifier;
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
    CGFloat topSpace = 5.f;
    CGFloat leftSpace = 60.f;
    CGFloat labelHeight = 25.f;
    
    CGFloat imageSize = 105.f;
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

    //订单编号
    _orderNoLabel = [[UILabel alloc] init];
    _orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _orderNoLabel.backgroundColor = [UIColor clearColor];
    _orderNoLabel.textColor = kColor(117, 117, 117, 1);
    _orderNoLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_orderNoLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.45
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = kColor(117, 117, 117, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.35
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = kColor(117, 117, 117, 1);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_statusLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_timeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //划线
    UIImageView *firstLine = [[UIImageView alloc] init];
    firstLine.image = kImageName(@"gray.png");
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:firstLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:60.f]];
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
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:5.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
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
                                                                  constant:20.f]];
    if (_supplyType == SupplyGoodsWholesale) {
        //原价
        _primaryPriceLabel = [[UILabel alloc] init];
//        _primaryPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _primaryPriceLabel.backgroundColor = [UIColor clearColor];
        _primaryPriceLabel.font = [UIFont systemFontOfSize:12.f];
        _primaryPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_primaryPriceLabel];
        [self layoutGoodLabel:_primaryPriceLabel WithTopView:firstLine topSpace:0.f alignment:NSTextAlignmentRight];

    }

    //价格
    _actualPriceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_actualPriceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //数量
    _numberLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_numberLabel WithTopView:_actualPriceLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_numberLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    
    //划线
    UIImageView *secondLine = [[UIImageView alloc] init];
    secondLine.image = kImageName(@"gray.png");
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:secondLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    //下面第一列
    _firstLabel = [[UILabel alloc] init];
    _firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _firstLabel.backgroundColor = [UIColor clearColor];
    _firstLabel.font = [UIFont systemFontOfSize:12.f];
    _firstLabel.textColor = kColor(117, 117, 117, 1);
    [self.contentView addSubview:_firstLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.2
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_firstLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //第三列
    _thirdLabel = [[UILabel alloc] init];
    _thirdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _thirdLabel.backgroundColor = [UIColor clearColor];
    _thirdLabel.font = [UIFont systemFontOfSize:12.f];
    _thirdLabel.textColor = kColor(117, 117, 117, 1);
    _thirdLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_thirdLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_firstLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.4
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //第二列
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _secondLabel.backgroundColor = [UIColor clearColor];
    _secondLabel.font = [UIFont systemFontOfSize:12.f];
    _secondLabel.textColor = kColor(117, 117, 117, 1);
    [self.contentView addSubview:_secondLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_thirdLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
   
    //合计
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _totalLabel.textColor = kColor(117, 117, 117, 1);
    _totalLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_totalLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_firstLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-topSpace-20]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.4
                                                                  constant:-leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];

    [self setContentForReuseIdentifier];
}

- (void)setContentForReuseIdentifier {
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

    
    if ([_identifier isEqualToString:wholesaleCancelIdentifier] ||
        [_identifier isEqualToString:procurementThirdIdentifier]) {
        return;
    }
    
    else if ([_identifier isEqualToString:wholesaleUnpaidIdentifier]) {
        //批购未付款
        UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesalOrder:) style:orderBtnStyleFirst];
        [self.contentView addSubview:cancelBtn];
        cancelBtn.frame=CGRectMake(wide-60-100, 30, 100, 35);
        
        UIButton *payBtn = [self buttonWithTitle:@"支付定金" action:@selector(payDeposit:) style:orderBtnStyleSecond];
        [self.contentView addSubview:payBtn];
        payBtn.frame=CGRectMake(wide-60-100, 75, 100, 35);
    }
    else if ([_identifier isEqualToString:wholesaleDepositIdentifier]) {
        //批购已付定金
        UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelWholesalOrder:) style:orderBtnStyleFirst];
        [self.contentView addSubview:cancelBtn];
        cancelBtn.frame=CGRectMake(wide-60-100, 30, 100, 35);
        
        UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payWholesaleOrder:) style:orderBtnStyleSecond];
        [self.contentView addSubview:payBtn];
        payBtn.frame=CGRectMake(wide-60-100, 75, 100, 35);
        cancelBtn.userInteractionEnabled=YES;
        
    }
    else if ([_identifier isEqualToString:wholesaleFinishIdentifier]) {
        //批购已完成
        UIButton *repeatBtn = [self buttonWithTitle:@"再次批购" action:@selector(repeatWholesale:) style:orderBtnStyleSecond];
        [self.contentView addSubview:repeatBtn];
        repeatBtn.frame=CGRectMake(wide-60-100, 75, 100, 35);
    }
    else if ([_identifier isEqualToString:procurementFirstIdentifier]) {
        //代购未付款
        UIButton *cancelBtn = [self buttonWithTitle:@"取消订单" action:@selector(cancelProcurementOrder:) style:orderBtnStyleFirst];
        [self.contentView addSubview:cancelBtn];
        cancelBtn.frame=CGRectMake(wide-60-100, 30, 100, 35);
        cancelBtn.userInteractionEnabled=YES;

        UIButton *payBtn = [self buttonWithTitle:@"付款" action:@selector(payProcurementOrder:) style:orderBtnStyleSecond];
        [self.contentView addSubview:payBtn];
        payBtn.frame=CGRectMake(wide-60-100, 75, 100, 35);
    }
    else if ([_identifier isEqualToString:procurementSecondIdentifier]) {
        //代购 已发货 已取消 交易关闭
        UIButton *repeatBtn = [self buttonWithTitle:@"再次代购" action:@selector(repeatProcurement:) style:orderBtnStyleSecond];
        [self.contentView addSubview:repeatBtn];
        repeatBtn.frame=CGRectMake(wide-60-100, 75, 100, 35);
    }
}

- (void)layoutButton:(UIButton *)button location:(BtnPosition)position {
    UIView *topView = _firstLabel;
    if (_supplyType == SupplyGoodsWholesale) {
        topView = _totalLabel;
    }
    CGFloat middleSpace = 5.f;
    CGFloat btnWidth = 80;
    CGFloat btnHeight = 36.f;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:middleSpace + 1]];
    switch (position) {
        case BtnPositionLeft: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:middleSpace * 2]];
        }
            break;
        case BtnPositionRight: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:-middleSpace * 2]];
        }
            break;
        case BtnPositionMiddle: {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.f]];
        }
            break;
        default:
            break;
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnHeight]];
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
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-wide/2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(NSString *)style{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.translatesAutoresizingMaskIntoConstraints = NO;
    if ([style isEqualToString:orderBtnStyleFirst]) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kMainColor.CGColor;
        [button setTitleColor:kMainColor forState:UIControlStateNormal];
        [button setTitleColor:kColor(0, 59, 113, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"blue.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addLine {
    UIView *topView = _firstLabel;
    if (_supplyType == SupplyGoodsWholesale) {
        topView = _totalLabel;
    }
    UIImageView *line = [[UIImageView alloc] init];
    line.image = kImageName(@"gray.png");
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:line];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:60.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-60.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
}

#pragma mark - Data

- (void)setContentsWithData:(OrderModel *)data {
    _cellData = data;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_cellData.orderNumber];
    self.timeLabel.text = _cellData.orderTime;
    self.statusLabel.text = [_cellData getStatusStringWithSupplyType:_supplyType];
    self.nameLabel.text = _cellData.orderGood.goodName;
    if (_supplyType == SupplyGoodsWholesale) {
        
        
        
        NSString *primaryPrice = [NSString stringWithFormat:@"原价 ￥%.2f",_cellData.orderGood.goodPrimaryPrice];
        NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:primaryPrice];
        NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                                   [NSNumber numberWithInt:2],NSStrikethroughStyleAttributeName,
                                   nil];
        [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, [priceAttrString length])];
       self.primaryPriceLabel.attributedText = priceAttrString;
        
        self.primaryPriceLabel.textColor=[UIColor grayColor];
        
        
        
        
        
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_cellData.orderGood.goodActualPirce];

        self.firstLabel.text = [NSString stringWithFormat:@"已付定金:￥%.2f",_cellData.orderDeposit];
        self.secondLabel.text = [NSString stringWithFormat:@"已发货数量:%d",_cellData.shipmentCount];
        self.thirdLabel.text = [NSString stringWithFormat:@"剩余金额:￥%.2f",_cellData.remainingMoney];
        self.totalLabel.text = [NSString stringWithFormat:@"合计:￥%.2f",_cellData.totalMoney];
    }
    else {
        self.firstLabel.text = [NSString stringWithFormat:@"归属用户:%@",_cellData.belongUser];
        self.secondLabel.text = [NSString stringWithFormat:@"配送费:￥%.2f",_cellData.deliveryMoney];
        self.totalLabel.text = [NSString stringWithFormat:@"实付:￥%.2f",_cellData.actualMoney];
        self.actualPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_cellData.orderGood.goodPrimaryPrice];

    }
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",_cellData.orderGood.goodCount];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",_cellData.orderGood.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",_cellData.orderGood.goodChannel];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:_cellData.orderGood.goodImagePath] placeholderImage:nil];
}


#pragma mark - Action

//批购
- (IBAction)cancelWholesalOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCancelWholesaleOrder:)]) {
        [_delegate orderCellCancelWholesaleOrder:_cellData];
    }
}

//支付定金
- (IBAction)payDeposit:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellPayDepositOrder:)]) {
        [_delegate orderCellPayDepositOrder:_cellData];
    }
}

//付款
- (IBAction)payWholesaleOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellPayWholesaleOrder:)]) {
        [_delegate orderCellPayWholesaleOrder:_cellData];
    }
}

//再次批购
- (IBAction)repeatWholesale:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellWholesaleRepeat:)]) {
        [_delegate orderCellWholesaleRepeat:_cellData];
    }
}

//代购
- (IBAction)cancelProcurementOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCancelProcurementOrder:)]) {
        [_delegate orderCellCancelProcurementOrder:_cellData];
    }
}

//付款
- (IBAction)payProcurementOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellPayProcurementOrder:)]) {
        [_delegate orderCellPayProcurementOrder:_cellData];
    }
}

//再次代购
- (IBAction)repeatProcurement:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellProcurementRepeat:)]) {
        [_delegate orderCellProcurementRepeat:_cellData];
    }
}
@end
