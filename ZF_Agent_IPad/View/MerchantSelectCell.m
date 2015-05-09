//
//  MerchantSelectCell.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/5/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "MerchantSelectCell.h"

@implementation MerchantSelectCell

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
        
        
      
        _merchantLB = [[UILabel alloc] init];
        [ _merchantLB setBackgroundColor:[UIColor clearColor]];
        [ _merchantLB setFont:[UIFont systemFontOfSize:21]];
         _merchantLB.textColor= [UIColor colorWithHexString:@"6c6c6c"];
         _merchantLB.textAlignment=NSTextAlignmentLeft;
        //_reciverLB.backgroundColor=[UIColor redColor];
        [_backView addSubview: _merchantLB];
        [_merchantLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(self.left).offset(wide/4.0);
            make.right.equalTo(self.centerX);
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


-(void)setMerchantSelectModel:(MerchantModel *)MerchantModel andTarget:(id)target
{
    
    _MerchantModel = MerchantModel;
    _superTarget = target;
    [_merchantLB setText:MerchantModel.merchantTitle];
   
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
