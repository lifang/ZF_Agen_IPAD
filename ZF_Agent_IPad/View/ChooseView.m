//
//  ChooseView.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChooseView.h"

@interface ChooseView ()

@end

@implementation ChooseView

//创建UI
-(void)initUI
{
    self.backgroundColor = kColor(81, 83, 87, 1.0);
    
    UIButton *orderBtn = [[UIButton alloc]init];
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [orderBtn setTitle:@"我的信息" forState:UIControlStateNormal];
    [orderBtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
    self.orderBtn = orderBtn;
    [self addSubview:orderBtn];
    
    UIButton *aftersellBtn = [[UIButton alloc]init];
    aftersellBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [aftersellBtn setTitle:@"下级代理商管理" forState:UIControlStateNormal];
    [aftersellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.aftersellBtn = aftersellBtn;
    [self addSubview:aftersellBtn];
    
    UIButton *messageBtn = [[UIButton alloc]init];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [messageBtn setTitle:@"配货" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.messageBtn = messageBtn;
    [self addSubview:messageBtn];
    
    UIButton *shopBtn = [[UIButton alloc]init];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [shopBtn setTitle:@"调货" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shopBtn = shopBtn;
    [self addSubview:shopBtn];
    
    UIButton *applyBtn = [[UIButton alloc]init];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [applyBtn setTitle:@"员工管理" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.applyBtn = applyBtn;
    [self addSubview:applyBtn];
    UIButton *exitBtn = [[UIButton alloc]init];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.exitbtn = exitBtn;
    [self addSubview:exitBtn];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = kImageName(@"sanjiaoxing");
    [self addSubview:imageView];
    self.imageView = imageView;
    
    NSLog(@"~~~~~~~~~®%d",_chooseType);
    [self layoutIfNeeded];
    
}

//初始化方法
- (id)initWithFrame:(CGRect)frame With:(ChooseViewType)ChooseViewtype;
{
    if (self = [super initWithFrame:frame]) {
        self.chooseType = ChooseViewtype;
        [self initUI];
    }
    return self;
}



//重新布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainX = 40.f;
    CGFloat margin = 40.f;
    CGFloat BtnWidth = 80.f;
    CGFloat BtnHeight = 20.f;
    
    _orderBtn.frame = CGRectMake(mainX, margin * 1.4, BtnWidth, BtnHeight);
    
    _aftersellBtn.frame = CGRectMake(mainX - 25, CGRectGetMaxY(_orderBtn.frame) + margin, BtnWidth + 50, BtnHeight);
    
    _messageBtn.frame = CGRectMake(mainX, CGRectGetMaxY(_aftersellBtn.frame) + margin, BtnWidth, BtnHeight);
    
    _shopBtn.frame = CGRectMake(mainX, CGRectGetMaxY(_messageBtn.frame) + margin, BtnWidth, BtnHeight);
    
    _applyBtn.frame = CGRectMake(mainX - 40.f, CGRectGetMaxY(_shopBtn.frame) + margin, BtnWidth * 2, BtnHeight);
    _exitbtn.frame = CGRectMake(mainX - 40.f, CGRectGetMaxY(_applyBtn.frame) + margin, BtnWidth * 2, BtnHeight);

    for (int i = 0; i < 5; i ++) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kColor(98, 98, 98, 1.0);
        line.frame = CGRectMake(4, 90 + i * BtnHeight * 3, BtnWidth * 2 - 10, 1);
        [self addSubview:line];
    }
    
    switch (_chooseType) {
        case ChooseViewMyOrder:
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _orderBtn.frame.origin.y - 2, 10, 20);
            break;
        case ChooseViewAfterSell:
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_aftersellBtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _aftersellBtn.frame.origin.y - 2, 10, 20);
            break;
        case ChooseViewMyMessage:
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_messageBtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _messageBtn.frame.origin.y - 2, 10, 20);
            break;
        case ChooseViewMyShop:
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_shopBtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _shopBtn.frame.origin.y - 2, 10, 20);
            break;
        case ChooseViewApplyplan:
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_applyBtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _applyBtn.frame.origin.y - 2, 10, 20);
            break;
            
        case ChooseViewexit:
            [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_exitbtn setTitleColor:kColor(103, 167, 236, 1.0) forState:UIControlStateNormal];
            _imageView.frame = CGRectMake(self.frame.size.width - 10, _exitbtn.frame.origin.y - 2, 10, 20);
            break;
        default:
            break;
    }
}

@end
