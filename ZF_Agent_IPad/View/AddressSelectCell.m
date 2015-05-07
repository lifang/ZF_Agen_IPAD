//
//  AddressSelectCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AddressSelectCell.h"

@implementation AddressSelectCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:_backView];
        
        [_backView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        float wide=_backView.frame.size.width;
        //float hight=_backView.frame.size.height;
        
        
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _selectedImageView.image = kImageName(@"btn_select");
        [_backView addSubview:_selectedImageView];
        [_selectedImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_backView.left).offset(40);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _defaultLabel.backgroundColor = [UIColor clearColor];
        _defaultLabel.font = [UIFont systemFontOfSize:20];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.textColor = [UIColor colorWithHexString:@"005df6"];
        _defaultLabel.text = @"默认";
        [_backView addSubview:_defaultLabel];
        [_defaultLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_selectedImageView.right).offset(20);
            make.width.equalTo(@60);
            make.height.equalTo(@42);
        }];
        
        
        _reciverLB = [[UILabel alloc] init];
        [_reciverLB setBackgroundColor:[UIColor clearColor]];
        [_reciverLB setFont:[UIFont systemFontOfSize:21]];
        _reciverLB.textColor= [UIColor colorWithHexString:@"6c6c6c"];
        _reciverLB.textAlignment=NSTextAlignmentCenter;
        //_reciverLB.backgroundColor=[UIColor redColor];
        [_backView addSubview:_reciverLB];
        [_reciverLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
           // make.left.equalTo(_defaultLabel.right).offset(40);
            make.left.equalTo(self.left).offset(wide/4.0);
           // make.width.equalTo(@(wide/4.0));
            make.right.equalTo(self.centerX);
        }];
        
        
        _addressLB = [[UILabel alloc] init];
        [_addressLB  setBackgroundColor:[UIColor clearColor]];
        [_addressLB  setFont:[UIFont systemFontOfSize:21]];
        _addressLB .textColor= [UIColor colorWithHexString:@"6c6c6c"];
        _addressLB .textAlignment=NSTextAlignmentLeft;
        [_backView addSubview:_addressLB ];
        [_addressLB  makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(self.centerX);
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

        
    }
    
    return self;
}


-(void)setAddressSelectModel:(AddressModel *)AddressModel andTarget:(id)target
{
    if ([AddressModel.isDefault intValue] == AddressDefault) {
        _defaultLabel.hidden = NO;
    }
    else {
        _defaultLabel.hidden = YES;
    }
    
    _AddressModel = AddressModel;
    _superTarget = target;
    [_reciverLB setText:AddressModel.addressReceiver];
    [_addressLB setText:AddressModel.address];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
