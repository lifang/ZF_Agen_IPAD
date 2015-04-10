//
//  AddressCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell()

@property(nonatomic,strong)NSString *reuseIdentifiers;

@property(nonatomic,strong)UIView *lineView;

@end

@implementation AddressCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.reuseIdentifiers = reuseIdentifier;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        UIColor *mainColor = kColor(67, 67, 67, 1.0);
        
        _consigneeLabel = [[UILabel alloc]init];
        _consigneeLabel.font = mainFont;
        _consigneeLabel.textColor = mainColor;
        _consigneeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_consigneeLabel];
        
        _areaLabel = [[UILabel alloc]init];
        _areaLabel.font = mainFont;
        _areaLabel.textColor = mainColor;
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_areaLabel];
        
        _particularAddressLabel = [[UILabel alloc]init];
        _particularAddressLabel.textAlignment = NSTextAlignmentCenter;
        _particularAddressLabel.font = mainFont;
        _particularAddressLabel.textColor = mainColor;
        [self addSubview:_particularAddressLabel];
        
        _postcodeLabel = [[UILabel alloc]init];
        _postcodeLabel.textAlignment = NSTextAlignmentCenter;
        _postcodeLabel.font = mainFont;
        _postcodeLabel.textColor = mainColor;
        [self addSubview:_postcodeLabel];
        
        _telLabel = [[UILabel alloc]init];
        _telLabel.textAlignment = NSTextAlignmentCenter;
        _telLabel.font = mainFont;
        _telLabel.textColor = mainColor;
        [self addSubview:_telLabel];
        
        _defaultLabel = [[UILabel alloc]init];
        _defaultLabel.text = @"默认";
        _defaultLabel.font = mainFont;
        _defaultLabel.textColor = kColor(147,190, 243, 1.0);
        [self addSubview:_defaultLabel];
        
        _changeBtn = [[UIButton alloc]init];
        [_changeBtn addTarget:self action:@selector(changeClicked) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = mainFont;
        [self addSubview:_changeBtn];
        
//        _lineView = [[UIView alloc]init];
//        _lineView.backgroundColor = kColor(239, 239, 239, 1.0);
//        [self addSubview:_lineView];
//        
//        if ([_reuseIdentifiers isEqualToString:@"AddressCell2"]) {
//            _lineView.frame = CGRectMake(0, 50, self.frame.size.width, 1);
//        }
        
        if ([reuseIdentifier isEqualToString:@"AddressCell1"]) {
            self.backgroundColor = kColor(228, 228, 228, 1.0);
            _consigneeLabel.text = @"收货人";
            _areaLabel.text = @"所在地区";
            _particularAddressLabel.text = @"详细地址";
            _postcodeLabel.text = @"邮编";
            _telLabel.text = @"电话";
        }
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat mainY = - 2.f;
    CGFloat mainHeight = 30.f;
    if ([_reuseIdentifiers isEqualToString:@"AddressCell2"]) {
        mainY = 10.f;
    }
    _consigneeLabel.frame = CGRectMake(20, mainY, 120, 30);
    
    _areaLabel.frame = CGRectMake(CGRectGetMaxX(_consigneeLabel.frame) + 10, mainY, 100, mainHeight);
    
    _particularAddressLabel.frame = CGRectMake(CGRectGetMaxX(_areaLabel.frame), mainY, 200, mainHeight);
    
    _postcodeLabel.frame = CGRectMake(CGRectGetMaxX(_particularAddressLabel.frame) - 30, mainY, 100, mainHeight);
    
    _telLabel.frame = CGRectMake(CGRectGetMaxX(_postcodeLabel.frame), mainY, 140, mainHeight);
    
    _defaultLabel.frame = CGRectMake(CGRectGetMaxX(_telLabel.frame) , mainY, 40, mainHeight);
    
    _changeBtn.frame = CGRectMake(CGRectGetMaxX(_defaultLabel.frame) + 10, mainY, 40, mainHeight);
    
}

-(void)changeClicked
{
    [self.AddressCellDelegate changeBtnClicked:_selectID WithIndex:_indexP];
}

@end
