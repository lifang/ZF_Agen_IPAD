//
//  SwitchView.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SwitchView.h"

@interface SwitchView()

@property(nonatomic,strong)NSArray *btnArray;

@property(nonatomic,assign)BOOL isChecked;

@property(nonatomic,strong)NSMutableArray *btnsArray;

@end

@implementation SwitchView

-(NSMutableArray *)btnsArray
{
    if (!_btnsArray) {
        _btnsArray = [[NSMutableArray alloc]init];
    }
    return _btnsArray;
}


- (id)initWithFrame:(CGRect)frame With:(NSArray *)btnArray
{
    if (self = [super initWithFrame:frame]) {
        self.btnArray = btnArray;
        self.isChecked = YES;
        [self initUIWithTag:0];
    }
    return self;
}

-(void)initUIWithTag:(int)tag
{
    if (tag == 0) {
        self.backgroundColor = kColor(228, 226, 226, 1.0);
        for (int i = 0; i < _btnsArray.count; i++) {
            [[_btnsArray objectAtIndex:i] removeFromSuperview];
        }
        for (int i = 0; i < _btnArray.count; i++) {
            CGFloat btnWidth = 110.f;
            CGFloat btnLittleWith = 90.f;
            CGFloat btnHeight = 40.f;
            CGFloat btnLittleHeight = 36.f;
            CGFloat mainBtnY = self.frame.size.height * 0.5;
            UIButton *btn = [[UIButton alloc]init];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:kColor(46, 46, 46, 1.0) forState:UIControlStateNormal];
            [btn setTitle:[_btnArray objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i + 444;
            btn.frame = CGRectMake(50 + i * btnLittleWith, mainBtnY + 5, btnLittleWith, btnLittleHeight);
            if (btn.tag == 444) {
                btn.frame = CGRectMake(30 + i * btnWidth, mainBtnY, btnWidth, btnHeight);
                [btn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
            }
            [self addSubview:btn];
            [self.btnsArray addObject:btn];
        }
        
    }else{
    switch (tag) {
        case 445:
            self.backgroundColor = kColor(228, 226, 226, 1.0);
            for (int i = 0; i < _btnsArray.count; i++) {
                [[_btnsArray objectAtIndex:i] removeFromSuperview];
            }
            for (int i = 0; i < _btnArray.count; i++) {
                CGFloat btnWidth = 110.f;
                CGFloat btnLittleWith = 90.f;
                CGFloat btnHeight = 40.f;
                CGFloat btnLittleHeight = 36.f;
                CGFloat mainBtnY = self.frame.size.height * 0.5;
                UIButton *btn = [[UIButton alloc]init];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:kColor(46, 46, 46, 1.0) forState:UIControlStateNormal];
                [btn setTitle:[_btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:18];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = i + 444;
                btn.frame = CGRectMake(50 + i * btnLittleWith, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                if (btn.tag == 444) {
                    btn.frame = CGRectMake(30 + i * btnWidth, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                    btn.titleLabel.font = [UIFont systemFontOfSize:18];
                }
                if (btn.tag == 445) {
                    btn.frame = CGRectMake(20 + i * btnWidth - 10, mainBtnY, btnWidth, btnHeight);
                    [btn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20];
                }
                [self addSubview:btn];
                _isChecked = NO;
                [self.btnsArray addObject:btn];
            }
            break;
        case 446:
            self.backgroundColor = kColor(228, 226, 226, 1.0);
            for (int i = 0; i < _btnsArray.count; i++) {
                [[_btnsArray objectAtIndex:i] removeFromSuperview];
            }
            for (int i = 0; i < _btnArray.count; i++) {
                CGFloat btnWidth = 110.f;
                CGFloat btnLittleWith = 90.f;
                CGFloat btnHeight = 40.f;
                CGFloat btnLittleHeight = 36.f;
                CGFloat mainBtnY = self.frame.size.height * 0.5;
                UIButton *btn = [[UIButton alloc]init];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:kColor(46, 46, 46, 1.0) forState:UIControlStateNormal];
                [btn setTitle:[_btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:18];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = i + 444;
                btn.frame = CGRectMake(50 + i * btnLittleWith, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                if (btn.tag == 445) {
                    btn.frame = CGRectMake(30 + i * btnWidth, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                    btn.titleLabel.font = [UIFont systemFontOfSize:18];
                }
                if (btn.tag == 446) {
                    btn.frame = CGRectMake(20 + i * btnWidth - 15, mainBtnY, btnWidth, btnHeight);
                    [btn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20];
                }
                [self addSubview:btn];
                _isChecked = NO;
                [self.btnsArray addObject:btn];
            }
            break;
        case 447:
            self.backgroundColor = kColor(228, 226, 226, 1.0);
            for (int i = 0; i < _btnsArray.count; i++) {
                [[_btnsArray objectAtIndex:i] removeFromSuperview];
            }
            for (int i = 0; i < _btnArray.count; i++) {
                CGFloat btnWidth = 110.f;
                CGFloat btnLittleWith = 90.f;
                CGFloat btnHeight = 40.f;
                CGFloat btnLittleHeight = 36.f;
                CGFloat mainBtnY = self.frame.size.height * 0.5;
                UIButton *btn = [[UIButton alloc]init];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:kColor(46, 46, 46, 1.0) forState:UIControlStateNormal];
                [btn setTitle:[_btnArray objectAtIndex:i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:18];
                btn.backgroundColor = [UIColor clearColor];
                btn.tag = i + 444;
                btn.frame = CGRectMake(50 + i * btnLittleWith, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                if (btn.tag == 446) {
                    btn.frame = CGRectMake(10 + i * btnWidth, mainBtnY + 5, btnLittleWith, btnLittleHeight);
                    btn.titleLabel.font = [UIFont systemFontOfSize:18];
                }
                if (btn.tag == 447) {
                    btn.frame = CGRectMake(10 + i * btnWidth - 15, mainBtnY, btnWidth, btnHeight);
                    [btn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20];
                }
                [self addSubview:btn];
                _isChecked = NO;
                [self.btnsArray addObject:btn];
            }
            break;
                default:
            break;
    }
    }
}

-(void)btnClick:(UIButton *)button
{
    [self.SwitchViewClickedDelegate SwitchViewClickedAtIndex:button.tag - 443];
    switch (button.tag) {
        case 444:
            if (_isChecked) {
                
            }else{
                _isChecked = YES;
                [self initUIWithTag:0];
            }
            break;
        case 445:
            [self initUIWithTag:button.tag];
            break;
        case 446:
            [self initUIWithTag:button.tag];
        case 447:
            [self initUIWithTag:button.tag];
        default:
            break;
    }
    
}

-(void)setSelectedBtnAtIndex:(int)Index
{
    switch (Index) {
        case 1:
            [self initUIWithTag:0];
            break;
        case 2:
            [self initUIWithTag:445];
            break;
        case 3:
            [self initUIWithTag:446];
            break;
        case 4:
            [self initUIWithTag:447];
            break;
            
        default:
            break;
    }
}

@end
