//
//  GoodButton.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodButton.h"

@implementation GoodButton

- (void)setButtonAttrWithTitle:(NSString *)title {
    self.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self setTitleColor:kColor(84, 83, 83, 1) forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = kColor(154, 153, 153, 1).CGColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        
      self.layer.borderColor =kColor(3, 112, 214, 1).CGColor;
        [self setBackgroundColor:kColor(3, 112, 214, 1)];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:kColor(84, 83, 83, 1) forState:UIControlStateNormal];
        self.layer.borderColor = kColor(154, 153, 153, 1).CGColor;
        [self setBackgroundColor:[UIColor whiteColor]];

    }
}

//- (void)setHighlighted:(BOOL)highlighted {
////    [super setHighlighted:highlighted];
//    if (highlighted) {
//        self.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
//        [self setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
//    }
//    else if (!self.selected) {
//        [self setTitleColor:kColor(84, 83, 83, 1) forState:UIControlStateNormal];
//        self.layer.borderColor = kColor(154, 153, 153, 1).CGColor;
//    }
//}

@end
