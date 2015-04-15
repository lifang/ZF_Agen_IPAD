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
        
        
        _terminalLB = [[UILabel alloc] init];
        [_terminalLB setBackgroundColor:[UIColor clearColor]];
        [_terminalLB setFont:[UIFont systemFontOfSize:21]];
        _terminalLB.textColor= [UIColor colorWithHexString:@"292929"];
        [_backView addSubview:_terminalLB];
        [_terminalLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_backView.left).offset(120);
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
        
       
    }
    
    return self;
}


-(void)setTerminalSelectModel:(TerminalSelectModel *)TerminalSelectModel andTarget:(id)target
{
    
    _TerminalSelectModel = TerminalSelectModel;
    _superTarget = target;
    [_terminalLB setText:TerminalSelectModel.serial_num];
    [_priceLB setText:TerminalSelectModel.retail_price];
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
