//
//  TopDealRoadCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TopDealRoadCell.h"

@interface TopDealRoadCell ()

@property(nonatomic,strong)UIView *contentViews;
@property(nonatomic,strong)NSString *reuseIdentifierID;

@end

@implementation TopDealRoadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"创建的标示%@",reuseIdentifier);
        self.reuseIdentifierID = reuseIdentifier;
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = kColor(212, 212, 212, 1.0);
        topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.7);
        if (iOS7) {
            topView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 0.7);
        }
        [self addSubview:topView];
        
        UILabel *dealLabel = [[UILabel alloc]init];
        dealLabel.text = @"交易流水:";
        dealLabel.textColor = kColor(114, 114, 114, 1.0);
        dealLabel.font = [UIFont systemFontOfSize:15];
        dealLabel.frame = CGRectMake(40, CGRectGetMaxY(topView.frame) + 15, 80, 20);
        [self addSubview:dealLabel];
        
        UIView *contentView = [[UIView alloc]init];
        self.contentViews = contentView;
        [self setupContentView];
        contentView.backgroundColor = kColor(228, 228, 228, 1.0);
        contentView.frame = CGRectMake(0, CGRectGetMaxY(dealLabel.frame) + 17, SCREEN_WIDTH,50 -  CGRectGetMaxY(dealLabel.frame) + 15);
        if (iOS7) {
            contentView.frame = CGRectMake(0, CGRectGetMaxY(dealLabel.frame) + 17, SCREEN_HEIGHT,50 -  CGRectGetMaxY(dealLabel.frame) + 15);
        }
        [self addSubview:contentView];
        
    }
    return self;
}

-(void)setupContentView
{
    //消费
    if ([_reuseIdentifierID isEqualToString:@"cell1"]) {
        
        CGFloat mainMargin = 70.f;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"交易时间";
        label1.frame = CGRectMake(90, 5, 100, 20);
        label1.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"手续费";
        label2.frame = CGRectMake(CGRectGetMaxX(label1.frame) + mainMargin + 50, 5, 100, 20);
        label2.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label2];
        
        UILabel *label4 = [[UILabel alloc]init];
        label4.text = @"终端号";
        label4.frame = CGRectMake(CGRectGetMaxX(label2.frame) + mainMargin + 50, 5, 100, 20);
        label4.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"交易金额";
        label5.frame = CGRectMake(CGRectGetMaxX(label4.frame) + mainMargin + 30 , 5, 100, 20);
        label5.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"交易状态";
        label6.frame = CGRectMake(CGRectGetMaxX(label5.frame) + mainMargin , 5, 100, 20);
        label6.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label6];
        
    }
    //转账
    if ([_reuseIdentifierID isEqualToString:@"cell2"]) {
        NSLog(@"创建第一个按钮的头Cell！");
        CGFloat mainMargin = 70.f;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"交易时间";
        label1.frame = CGRectMake(90, 5, 100, 20);
        label1.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"付款账号";
        label2.frame = CGRectMake(CGRectGetMaxX(label1.frame) + mainMargin, 5, 100, 20);
        label2.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc]init];
        label3.text = @"收款账号";
        label3.frame = CGRectMake(CGRectGetMaxX(label2.frame) + mainMargin, 5, 100, 20);
        label3.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc]init];
        label4.text = @"终端号";
        label4.frame = CGRectMake(CGRectGetMaxX(label3.frame) + mainMargin, 5, 100, 20);
        label4.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"交易金额";
        label5.frame = CGRectMake(CGRectGetMaxX(label4.frame) + mainMargin - 20, 5, 100, 20);
        label5.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"交易状态";
        label6.frame = CGRectMake(CGRectGetMaxX(label5.frame) + mainMargin - 20, 5, 100, 20);
        label6.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label6];
        
    }
    //还款
    if ([_reuseIdentifierID isEqualToString:@"cell3"]) {
        
        CGFloat mainMargin = 70.f;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"交易时间";
        label1.frame = CGRectMake(90, 5, 100, 20);
        label1.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"付款账号";
        label2.frame = CGRectMake(CGRectGetMaxX(label1.frame) + mainMargin, 5, 100, 20);
        label2.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc]init];
        label3.text = @"转入账号";
        label3.frame = CGRectMake(CGRectGetMaxX(label2.frame) + mainMargin, 5, 100, 20);
        label3.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc]init];
        label4.text = @"终端号";
        label4.frame = CGRectMake(CGRectGetMaxX(label3.frame) + mainMargin, 5, 100, 20);
        label4.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"交易金额";
        label5.frame = CGRectMake(CGRectGetMaxX(label4.frame) + mainMargin - 20, 5, 100, 20);
        label5.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"交易状态";
        label6.frame = CGRectMake(CGRectGetMaxX(label5.frame) + mainMargin - 20, 5, 100, 20);
        label6.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label6];
    }
    //生活充值
    if ([_reuseIdentifierID isEqualToString:@"cell4"]) {
        
        CGFloat mainMargin = 70.f;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"交易时间";
        label1.frame = CGRectMake(90, 5, 100, 20);
        label1.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"账户名";
        label2.frame = CGRectMake(CGRectGetMaxX(label1.frame) + mainMargin, 5, 100, 20);
        label2.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc]init];
        label3.text = @"账户号码";
        label3.frame = CGRectMake(CGRectGetMaxX(label2.frame) + mainMargin, 5, 100, 20);
        label3.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc]init];
        label4.text = @"终端号";
        label4.frame = CGRectMake(CGRectGetMaxX(label3.frame) + mainMargin, 5, 100, 20);
        label4.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"交易金额";
        label5.frame = CGRectMake(CGRectGetMaxX(label4.frame) + mainMargin - 20, 5, 100, 20);
        label5.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"交易状态";
        label6.frame = CGRectMake(CGRectGetMaxX(label5.frame) + mainMargin - 20, 5, 100, 20);
        label6.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label6];
    }
    //话费充值
    if ([_reuseIdentifierID isEqualToString:@"cell5"]) {
        
        CGFloat mainMargin = 70.f;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"交易时间";
        label1.frame = CGRectMake(90, 5, 100, 20);
        label1.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"手机号码";
        label2.frame = CGRectMake(CGRectGetMaxX(label1.frame) + mainMargin + 50, 5, 100, 20);
        label2.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label2];
        
        UILabel *label4 = [[UILabel alloc]init];
        label4.text = @"终端号";
        label4.frame = CGRectMake(CGRectGetMaxX(label2.frame) + mainMargin + 50, 5, 100, 20);
        label4.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label4];
        
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"交易金额";
        label5.frame = CGRectMake(CGRectGetMaxX(label4.frame) + mainMargin + 30 , 5, 100, 20);
        label5.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label5];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"交易状态";
        label6.frame = CGRectMake(CGRectGetMaxX(label5.frame) + mainMargin , 5, 100, 20);
        label6.font = [UIFont systemFontOfSize:14];
        [_contentViews addSubview:label6];
    }
    
}

@end
