//
//  IdentificationViewCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "IdentificationViewCell.h"

@implementation IdentificationViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"dynamic";
    IdentificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IdentificationViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *mainFont = [UIFont systemFontOfSize:16];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        _dredgeStatus.textAlignment = NSTextAlignmentCenter;
        _dredgeStatus.font = mainFont;
        [self addSubview:_dredgeStatus];
        
        self.applicationBtn = [[UIButton alloc]init];
        [_applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        [_applicationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applicationBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
        [self addSubview:_applicationBtn];
        
        _vedioConfirmBtn = [[UIButton alloc]init];
        [_vedioConfirmBtn setTitle:@"视频认证" forState:UIControlStateNormal];
        [_vedioConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_vedioConfirmBtn setBackgroundColor:[UIColor colorWithHexString:@"006fd5"]];
        [self addSubview:_vedioConfirmBtn];
        
        UILabel * line1 = [[UILabel alloc] init];
        [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
        [self.contentView addSubview:line1];
        [line1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.bottom.equalTo(self.contentView.bottom);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 10.f;
   // CGFloat mainY = 60.f;
    
    _terminalLabel.frame = CGRectMake(45, mainY+40, mainWidth, mainheight);
    
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 50, mainY+40, mainWidth, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 60, mainY+40, mainWidth * 0.5, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 90, mainY+40, mainWidth * 0.5, mainheight);
    
    _applicationBtn.frame = CGRectMake(CGRectGetMaxX(_dredgeStatus.frame) + 100, mainY, mainWidth * 0.7, mainheight * 1.5);
    
   _vedioConfirmBtn.frame = CGRectMake(CGRectGetMaxX(_dredgeStatus.frame) + 100, mainY+50, mainWidth * 0.7, mainheight * 1.5);
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
