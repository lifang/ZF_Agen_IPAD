//
//  PrepareGoodCell.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PrepareGoodCell.h"

@implementation PrepareGoodCell

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
    CGFloat topSpace = 15;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    CGFloat labelHeight = 30;
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

    _agentLabel = [[UILabel alloc] init];
//    _agentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _agentLabel.backgroundColor = [UIColor clearColor];
    _agentLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [self.contentView addSubview:_agentLabel];
    _agentLabel.frame=CGRectMake(60, 15, wide/2-240, 30);
    
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_agentLabel
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeTop
//                                                                multiplier:1.0
//                                                                  constant:topSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_agentLabel
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                multiplier:1.0
//                                                                  constant:80]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_agentLabel
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:-rightSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_agentLabel
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:labelHeight]];
//
 
    
 
       //日期
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.frame=CGRectMake(wide/2-160, 15, 180, 30);

    [self.contentView addSubview:_timeLabel];
  
    //数量
    _countLabel = [[UILabel alloc] init];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont systemFontOfSize:16];
    _countLabel.frame=CGRectMake(wide-160-80-100, 15, 80, 30);
    
    [self.contentView addSubview:_countLabel];
   
}

#pragma mark - Data
- (void)setContentWithDatas:(TransferGoodModel *)model {
    _agentLabel.text = [NSString stringWithFormat:@"%@ > %@     ",model.fromAgentName,model.toAgentName];
    _timeLabel.text = model.createTime;
    _countLabel.text = [NSString stringWithFormat:@"%d",model.count];
}

- (void)setContentWithData:(PrepareGoodModel *)model {
    _agentLabel.text = [NSString stringWithFormat:@"    %@",model.agentName];
    
    _timeLabel.text = model.createTime;
    _countLabel.text = [NSString stringWithFormat:@"%d",model.count];
}


@end
