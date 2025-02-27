//
//  SubAgentCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentCell.h"

@implementation SubAgentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
        wide=SCREEN_HEIGHT-220;
        height=SCREEN_WIDTH;
        
    }
    else
    {  wide=SCREEN_WIDTH-220;
        height=SCREEN_HEIGHT;
        
    }

    //类型
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.frame=CGRectMake(120, 15, 60, 30);
    
    
    _typeLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_typeLabel];//    //售出数量
//    _saleCountLabel = [[UILabel alloc] init];
//    [self layoutLabel:_saleCountLabel topView:nil isLeft:NO];
    //代理商名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame=CGRectMake(wide/2-40, 15, 120, 30);
    
    
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];//    //库存
//    _stockCountLabel = [[UILabel alloc] init];
//    [self layoutLabel:_stockCountLabel topView:_typeLabel isLeft:NO];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame=CGRectMake(wide-160, 15, 100, 30);
    
    
    _timeLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_timeLabel];
    //    //开通量
//    _openCountLabel = [[UILabel alloc] init];
//    [self layoutLabel:_openCountLabel topView:_nameLabel isLeft:NO];
}

- (void)layoutLabel:(UILabel *)label topView:(UIView *)topView isLeft:(BOOL)isLeft {
    CGFloat leftSpace = 10.f;
    CGFloat rightSpace = 0.f;
    CGFloat topSpace = 10.f;
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:label];
    if (!topView) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:topSpace]];

    }
    else {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:topView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.f]];

    }
    if (isLeft) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:leftSpace]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.5
                                                                      constant:10.f]];


    }
    else {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-rightSpace]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.5
                                                                      constant:-rightSpace - leftSpace - 10.f]];


    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:20.f]];

    
}

#pragma mark - Data

- (void)setContentWithData:(SubAgentModel *)model {
    NSString *typeString = nil;
    if (model.agentType == AgentTypeCompany) {
        typeString = @"公司";
    }
    else {
        typeString = @"个人";
    }
    NSString *timeString = model.createTime;
    if ([model.createTime length] > 10) {
        timeString = [model.createTime substringToIndex:10];
    }
    _typeLabel.text = [NSString stringWithFormat:@"%@",typeString];
//    _saleCountLabel.text = [NSString stringWithFormat:@"已售出：%d件",model.saleCount];
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.agentName];
//    _stockCountLabel.text = [NSString stringWithFormat:@"剩余库存：%d件",model.stockCount];
    _timeLabel.text = [NSString stringWithFormat:@"%@",timeString];
//    _openCountLabel.text = [NSString stringWithFormat:@"终端开通量：%d件",model.openCount];
}

@end
