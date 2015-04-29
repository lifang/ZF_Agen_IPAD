//
//  TerminalViewCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalViewCell.h"

@implementation TerminalViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        
        CGFloat mainBtnW = 100.f;
        CGFloat mainBtnH = 40.f;
        CGFloat mainBtnX = (SCREEN_WIDTH - 160.f);
        if (iOS7) {
            mainBtnX = SCREEN_HEIGHT - 160.f;
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
        
        if ([reuseIdentifier isEqualToString:@"cell-1"]) {
             for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = 1000+i;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX-(i * 115) , mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                  if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                  }
                 if (i == 1) {
                     [button setTitle:@"视频认证" forState:UIControlStateNormal];
                 }

             }
            
                
            
        }
        if ([reuseIdentifier isEqualToString:@"cell-3"]) {
            for (int i = 0; i < 3; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 2000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
                if (i == 1) {
                    [button setTitle:@"申请开通" forState:UIControlStateNormal];
                }
                if (i == 2) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-2"]) {
            for (int i = 0; i < 4; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 3000;
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
                    [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                }
                if (i == 3) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-5"]) {
            //for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                button.layer.masksToBounds=YES;
                button.layer.borderWidth=1.0;
                button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                button.backgroundColor = [UIColor clearColor];
               // button.tag = i + 4000;
                button.tag = 4000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
               // button.frame = CGRectMake(mainBtnX - (i * 115), mainBtnY, mainBtnW, mainBtnH);
                button.frame = CGRectMake(mainBtnX , mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
              //  if (i == 0) {
              //      [button setTitle:@"更新资料" forState:UIControlStateNormal];
              //  }
               // if (i == 0) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
               // }
            //}
        }
        if ([reuseIdentifier isEqualToString:@"cell-4"]) {
            /*
            //            for (int i = 0; i < 1; i++) {
                           UIButton *button = [[UIButton alloc]init];
                            button.titleLabel.font = [UIFont systemFontOfSize:17];
                            [button setTitleColor:[UIColor colorWithHexString:@"006fd5"] forState:UIControlStateNormal];
                            button.layer.masksToBounds=YES;
                            button.layer.cornerRadius=2.0;
                            button.layer.borderWidth=1.0;
                            button.layer.borderColor=[UIColor colorWithHexString:@"006fd5"].CGColor;
                            button.backgroundColor = [UIColor clearColor];
                            button.tag = 5000;
                            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                            button.frame = CGRectMake(mainBtnX, mainBtnY, mainBtnW, mainBtnH);
                            [self addSubview:button];
            //                if (i == 0) {
                               [button setTitle:@"租凭退换" forState:UIControlStateNormal];
            //                }
            //            }
             */
        }
    }
    return self;
}



-(void)buttonClick:(UIButton *)button
{
    [self.TerminalViewCellDelegate terminalCellBtnClicked:button.tag WithSelectedID:_selectedID Withindex:_indexNum];
}


#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 30.f;
    
    _terminalLabel.frame = CGRectMake(0, mainY, mainWidth, mainheight);
    
   // _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 20, mainY, mainWidth * 0.5, mainheight);
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame)+10, mainY, mainWidth * 0.3, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 50, mainY, mainWidth * 0.5 + 30, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 20, mainY, mainWidth * 0.5, mainheight);
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
