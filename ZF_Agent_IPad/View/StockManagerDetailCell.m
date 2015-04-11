//
//  StockManagerDetailCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "StockManagerDetailCell.h"

@implementation StockManagerDetailCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"StockCellDetail";
    StockManagerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[StockManagerDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAndLayoutUI];
    }
    return self;
}

-(void)initAndLayoutUI
{
    _stockDetailNameLabel = [[UILabel alloc]init];
    [self setLabel:_stockDetailNameLabel withLeftView:self.contentView middleSpace:60.f labelTag:1];
    
    _stockDetailShopCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockDetailShopCountLabel withLeftView:_stockDetailNameLabel middleSpace:40.f labelTag:0];
    
    _stockDetailOpenCountLabel = [[UILabel alloc]init];
    [self setLabel:_stockDetailOpenCountLabel withLeftView:_stockDetailShopCountLabel middleSpace:10.f labelTag:0];
    
    _stockDetailShopDateLabel = [[UILabel alloc]init];
    [self setLabel:_stockDetailShopDateLabel withLeftView:_stockDetailOpenCountLabel middleSpace:10.f labelTag:0];
    
    _stockDetailOpenDateLabel = [[UILabel alloc]init];
    [self setLabel:_stockDetailOpenDateLabel withLeftView:_stockDetailShopDateLabel middleSpace:10.f labelTag:0];
}


//创建左边Label
//leftView-左边控件
//space-距左边间距
- (void)setLabel:(UILabel *)label
    withLeftView:(UIView *)leftView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat topSpace = 40.f;
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 160.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kColor(51, 51, 51, 51);
    [self.contentView addSubview:label];
    if (LabelTag == 1) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:leftView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:space]];
    }else{
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:leftView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:space]];
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
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


#pragma mark - Action
-(void)setContentWithData:(StockAgentModel *)model
{
    _agentModel = model;
    _stockDetailNameLabel.text = model.agentName;
    _stockDetailShopCountLabel.text = [NSString stringWithFormat:@"%d",model.totalCount];
    _stockDetailOpenCountLabel.text = [NSString stringWithFormat:@"%d",model.openCount];;
    _stockDetailShopDateLabel.text = model.prepareTime;
    _stockDetailOpenDateLabel.text = model.openTime;
}

@end
