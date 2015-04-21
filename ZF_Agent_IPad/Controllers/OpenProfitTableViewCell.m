//
//  OpenProfitTableViewCell.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "OpenProfitTableViewCell.h"

@implementation OpenProfitTableViewCell
@synthesize deletebutton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat wide;
        CGFloat height;
        if(iOS7)
        {
            wide=SCREEN_HEIGHT;
            height=SCREEN_WIDTH;
            
        }
        else
        {  wide=SCREEN_WIDTH;
            height=SCREEN_HEIGHT;
            
        }

        
        deletebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        deletebutton.frame=CGRectMake(wide/2-80, 5, 60, 30);
        [deletebutton setTitle:@"删除" forState:UIControlStateNormal];
        [deletebutton setBackgroundColor:[UIColor clearColor]];
        
        [deletebutton  setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        
        
        [self addSubview:deletebutton];

        
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
