//
//  POSAddressTableViewCell.m
//  iPadff
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "POSAddressTableViewCell.h"

@implementation POSAddressTableViewCell
@synthesize logoImageView;
@synthesize namelabel;
@synthesize addresslable;
@synthesize postlable;
@synthesize schedulebutton;
@synthesize logoabel;
@synthesize smalltView;
@synthesize citylable;
@synthesize linlable;

@synthesize phonelable;
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
        
        
        logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
        
        //        [logoImageView1 addTarget:self action:@selector(change) forControlEvents: UIControlEventTouchUpInside];
        //        logoImageView1.userInteractionEnabled=YES;
        
        [self addSubview:logoImageView];
        logoabel  = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 40, 30)];
        
        
        logoabel.textColor=kColor(3, 112, 214, 1);
        
        
        logoabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:logoabel];
        
        
        
        namelabel  = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 80, 30)];
        
        namelabel.numberOfLines=0;
        
        namelabel.backgroundColor=[UIColor clearColor];
        
        //        label.textAlignment = NSTextAlignmentCenter;
        
        namelabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:namelabel];
        
        // Initialization code
        citylable=[[UILabel alloc]initWithFrame:CGRectMake(210, 5, 100, 30)];
        citylable.numberOfLines=0;
        
        citylable.backgroundColor=[UIColor clearColor];
        
        
        
        //        label.textAlignment = NSTextAlignmentCenter;
        
        //        label.font=[UIFont systemFontOfSize:10];
        [self addSubview:citylable];
        //        simplenamelabel.textColor=[UIColor grayColor];
        
        addresslable=[[UILabel alloc]initWithFrame:CGRectMake(400, 5, 300, 30)];
        [self addSubview:addresslable];
        
        postlable  = [[UILabel alloc] initWithFrame:CGRectMake(wide-140-100, 5, 60, 30)];
        
        
        postlable.backgroundColor=[UIColor clearColor];
        postlable.textAlignment=NSTextAlignmentCenter;
        
        //        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:postlable];
        phonelable  = [[UILabel alloc] initWithFrame:CGRectMake(wide-140, 5, 100, 30)];
        
        
        phonelable.font=[UIFont systemFontOfSize:14];
        
        
        
        
        [self addSubview:phonelable];
        
        
        linlable  = [[UILabel alloc] initWithFrame:CGRectMake(20, 39, wide-40, 1)];
        
        
        linlable.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
        
        
        [self addSubview:linlable];
        
        
        
        
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
