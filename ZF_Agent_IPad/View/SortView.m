//
//  SortView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SortView.h"


@interface SortButton : UIButton

@end

@implementation SortButton

- (void)setSelected:(BOOL)selected {
    if (!selected) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];

    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
    }
}

@end

@implementation SortView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(247, 250, 251, 1);
        
        
        if(iOS7)
        {
            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(180-SCREEN_HEIGHT/2, 0,SCREEN_HEIGHT, frame.size.height)];
            
            backView.image = kImageName(@"filterbackground.png");
            [self addSubview:backView];
        }else
        {
            
            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(180-SCREEN_WIDTH/2, 0,SCREEN_WIDTH, frame.size.height)];
            backView.image = kImageName(@"filterbackground.png");
            [self addSubview:backView];
        }

       
    }
    return self;
}

- (void)setItems:(NSArray *)itemNames {
    CGRect rect = self.bounds;
    CGFloat width = (rect.size.width - kLineHeight * 3) / [itemNames count];
    CGFloat originX = 0;
    for (int i = 0; i < [itemNames count]; i++)
    {
        SortButton *button = [SortButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, 0, width, rect.size.height);
        button.backgroundColor = [UIColor clearColor];
        button.tag = i + 1;
        button.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateHighlighted];
        [button setTitle:[itemNames objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        if (i == 2)
        {
            //价格按钮
            [button setImage:kImageName(@"down.png") forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            button.imageEdgeInsets = UIEdgeInsetsMake(1, width - 10, 0, 0);
        }
        originX += width + kLineHeight;
        if (i == 0)
        {
            button.selected = YES;
        }
        if (i < [itemNames count] - 1)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX - kLineHeight, 25, 1, rect.size.height - 50)];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
            [self addSubview:line];
        }
    }
}

- (void)clearState {
    for (SortButton *button in self.subviews) {
        if ([button isKindOfClass:[SortButton class]]) {
            button.selected = NO;
        }
    }
}

- (IBAction)selectedButton:(UIButton *)sender {
    if (_selectedIndex == sender.tag) {
        if (_selectedIndex == SortPriceDown) {
            [sender setTitle:@"价格升序" forState:UIControlStateNormal];
            [sender setImage:kImageName(@"up.png") forState:UIControlStateNormal];
            sender.tag = SortPriceUp;
        }
        else if (_selectedIndex == SortPriceUp) {
            [sender setTitle:@"价格降序" forState:UIControlStateNormal];
            [sender setImage:kImageName(@"down.png") forState:UIControlStateNormal];
            sender.tag = SortPriceDown;
        }
        else {
            return;
        }
    }
    [self clearState];
    _selectedIndex = sender.tag;
    sender.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(changeValueWithIndex:)]) {
        [_delegate changeValueWithIndex:sender.tag];
    }
}

@end
