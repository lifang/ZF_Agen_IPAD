//
//  TerminalSelectCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalSelectCell.h"

@implementation TerminalSelectCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:_backView];
        
        [_backView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        
        _selectedIMV = [[UIImageView alloc] init];
        _selectedIMV.clipsToBounds = YES;
       //_selectedIMV.layer.cornerRadius = 3.0f;
       //_selectedIMV.backgroundColor=[UIColor grayColor];
        [_selectedIMV setImage:[UIImage imageNamed:@"btn_noselect"]];
        [_backView  addSubview:_selectedIMV];
        [_selectedIMV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.left).offset(120);
            make.centerY.equalTo(_backView.centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@(30));
        }];

        
        _terminalLB = [[UILabel alloc] init];
        [_terminalLB setBackgroundColor:[UIColor clearColor]];
        [_terminalLB setFont:[UIFont systemFontOfSize:21]];
        _terminalLB.textColor= [UIColor colorWithHexString:@"292929"];
        [_backView addSubview:_terminalLB];
        [_terminalLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_selectedIMV.right).offset(120);
            make.right.equalTo(self.centerX);
        }];
        
        
        _priceLB = [[UILabel alloc] init];
        [_priceLB  setBackgroundColor:[UIColor clearColor]];
        [_priceLB  setFont:[UIFont systemFontOfSize:21]];
        _priceLB .textColor= [UIColor colorWithHexString:@"292929"];
        [_backView addSubview:_priceLB ];
        [_priceLB  makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(self.centerX).offset(120);
            make.right.equalTo(self.right).offset(80);
        }];
        
        
        UILabel * line1 = [[UILabel alloc] init];
        [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
        [self.contentView addSubview:line1];
        [line1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left);
            make.right.equalTo(self.contentView.right);
            make.bottom.equalTo(self.contentView.bottom);
            make.height.equalTo(@1);
        }];

        
        _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
        [_backView setUserInteractionEnabled:YES];
        [_backView addGestureRecognizer:_TAP];

       
    }
    
    return self;
}


-(void)setTerminalSelectModel:(TerminalSelectModel *)TerminalSelectModel andTarget:(id)target
{
    
    _TerminalSelectModel = TerminalSelectModel;
    _superTarget = target;
    if (_TerminalSelectModel.isSelected) {
        [_selectedIMV setImage:[UIImage imageNamed:@"btn_select"]];
    }
    else
    {
        [_selectedIMV setImage:[UIImage imageNamed:@"btn_noselect"]];
    }
    [_terminalLB setText:TerminalSelectModel.serial_num];
    [_priceLB setText:TerminalSelectModel.retail_price];
    
}

-(void) touchPressed:(TerminalSelectModel *)Terminalmodel
{
   // CGPoint point  = [t locationInView:_backView];
    _TerminalSelectModel.isSelected = !_TerminalSelectModel.isSelected;
    if (_TerminalSelectModel.isSelected) {
        [_selectedIMV setImage:[UIImage imageNamed:@"btn_select"]];
    }
    else
    {
      [_selectedIMV setImage:[UIImage imageNamed:@"btn_noselect"]];
    }
    if(_superTarget && [_superTarget respondsToSelector:@selector(select:)])
    {
        [_superTarget performSelector:@selector(select:) withObject:Terminalmodel];
    }
    
    
}


/*
-(void)select:(TerminalSelectModel *)Terminalmodel
{
    
    _TerminalSelectModel = Terminalmodel;
    _TerminalSelectModel.isSelected = !_TerminalSelectModel.isSelected;
    if(_superTarget && [_superTarget respondsToSelector:@selector(select:)])
    {
        [_superTarget performSelector:@selector(select:) withObject:Terminalmodel];
    }
    
}
*/



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
