//
//  TerminalViewCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalViewCell.h"

@implementation TerminalViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithVedeos:(BOOL)ishaveVideo Appid:(NSString *)appid WithType:(NSString *)type WithOpenStatus:(NSString *)openstatus
{
    self.openStatus = openstatus;
    self.isHaveVideo = ishaveVideo;
    self.appID = appid;
    self.type = type;
    self = [super initWithStyle:style reuseIdentifier:@"TerminalViewCell"];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        
        CGFloat mainBtnW = 100.f;
        CGFloat mainBtnH = 40.f;
        CGFloat mainBtnX = (SCREEN_WIDTH - 130.f);
        if (iOS7) {
            mainBtnX = SCREEN_HEIGHT - 130.f;
        }
        CGFloat mainBtnY = 20.f;
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.font = mainFont;
        _terminalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_terminalLabel];
        
        self.posLabel = [[UILabel alloc]init];
        _posLabel.textAlignment = NSTextAlignmentCenter;
        _posLabel.font = mainFont;
        [self addSubview:_posLabel];
        
        self.payRoad = [[UILabel alloc]init];
        _payRoad.textAlignment = NSTextAlignmentCenter;
        _payRoad.font = mainFont;
        [self addSubview:_payRoad];
        
        self.dredgeStatus = [[UILabel alloc]init];
        _dredgeStatus.font = mainFont;
        _dredgeStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dredgeStatus];
    }
    return self;
}



-(void)buttonClick:(UIButton *)button
{
    [self.TerminalViewCellDelegate terminalCellBtnClicked:button.tag WithSelectedID:_selectedID Withindex:_indexNum WithOpenstatus:_openStatus WithAppid:_appID];
}


#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 30.f;
    
    _terminalLabel.frame = CGRectMake(0, mainY, mainWidth, mainheight);
    
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame)+ 10, mainY, mainWidth * 0.6, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 35, mainY, mainWidth * 0.5 + 30, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 45, mainY, mainWidth * 0.5, mainheight);
}

-(void)initButtonWithreuseIdentifier:(NSString *)reuseIdentifier WithVedeos:(BOOL)ishaveVideo Appid:(NSString *)appid WithType:(NSString *)type WithOpenStatus:(NSString *)openstatus{
    
    for (UIView *button in self.contentView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    
    CGFloat mainBtnW = 100.f;
    CGFloat mainBtnH = 40.f;
    CGFloat mainBtnX = (SCREEN_WIDTH - 130.f);
    if (iOS7) {
        mainBtnX = SCREEN_HEIGHT - 130.f;
    }
    CGFloat mainBtnY = 20.f;
    
    if ([reuseIdentifier isEqualToString:@"cell-1"]) {
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[kMainColor CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 1000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
            [self addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
            if (i == 2) {
                if ([appid isEqualToString:@""]) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
            if ([type isEqualToString:@"2"]) {
                button.hidden = YES;
            }
        }
        
    }
    if ([reuseIdentifier isEqualToString:@"cell-3"]) {
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[kMainColor CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 2000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!ishaveVideo) {
                button.frame = CGRectMake(mainBtnX - ((i - 1) * 115), mainBtnY, mainBtnW, mainBtnH);
            }else{
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
            }
            [self addSubview:button];
            if (i == 0) {
                if (!ishaveVideo) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
            }
            if (i == 1) {
                if ([appid isEqualToString:@""]) {
                    [button setTitle:@"申请开通" forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                }
            }
            if (i == 2) {
                if ([appid isEqualToString:@""]) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
            if ([type isEqualToString:@"2"]) {
                button.hidden = YES;
            }
        }
    }
    if ([reuseIdentifier isEqualToString:@"cell-2"]) {
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[kMainColor CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 3000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!ishaveVideo) {
                if (i >= 2) {
                    button.frame = CGRectMake(mainBtnX - ((i - 1) * 115), mainBtnY, mainBtnW, mainBtnH);
                }else{
                    button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                }
            }else{
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
            }
            [self addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            if (i == 1) {
                if (!ishaveVideo) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
            }
            if (i == 2) {
                if ([appid isEqualToString:@""]) {
                    [button setTitle:@"申请开通" forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                }
            }
            if (i == 3) {
                if ([appid isEqualToString:@""]) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
            if ([type isEqualToString:@"2"]) {
                button.hidden = YES;
            }
        }
    }
    if ([reuseIdentifier isEqualToString:@"cell-5"]) {
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[kMainColor CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 4000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
            [self addSubview:button];
            //                if (i == 0) {
            //                    [button setTitle:@"更新资料" forState:UIControlStateNormal];
            //                }
            //                if (i == 1) {
            //                    if ([appid isEqualToString:@""]) {
            //                        button.hidden = YES;
            //                    }else{
            //                        [button setTitle:@"同步" forState:UIControlStateNormal];
            //                    }
            //                }
            //                if ([type isEqualToString:@"2"]) {
            //                    button.hidden = YES;
            //                }
            button.hidden = YES;
        }
    }
    if ([reuseIdentifier isEqualToString:@"cell-4"]) {
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:kMainColor forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[kMainColor CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 5000;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!ishaveVideo) {
                button.frame = CGRectMake(mainBtnX - ((i - 1) * 115), mainBtnY, mainBtnW, mainBtnH);
            }else{
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
            }
            [self addSubview:button];
            if (i == 0) {
                if (!ishaveVideo) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
            }
            if (i == 1) {
                [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
            }
            if (i == 2) {
                if ([appid isEqualToString:@""]) {
                    button.hidden = YES;
                }else{
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
            if ([type isEqualToString:@"2"]) {
                button.hidden = YES;
            }
        }
    }
}

@end
