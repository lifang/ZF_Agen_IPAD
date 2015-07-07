//
//  CommentCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/13.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithContent:(NSString *)content
      reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _content = content;
        [self initAndLayoutUI];
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

#pragma mark - UI

- (void)initAndLayoutUI {
//    CGFloat topSpace = 10.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
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

          //划线
    UIImageView *firstLine = [[UIImageView alloc] init];
//    firstLine.image = kImageName(@"gray.png");
    [self.contentView addSubview:firstLine];
    
    firstLine.frame=CGRectMake(0, 20, wide, 1);
    
    
    
       //内容
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_contentLabel];
     CGFloat newHeight = [self heightForComment:_content];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:firstLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:20]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-rightSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_contentLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:newHeight]];
   
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_nameLabel];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-7.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:20]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:0.0
                                                                multiplier:1.0
                                                                  constant:wide-40]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:20.f]];
//    //时间
//    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    _timeLabel.backgroundColor = [UIColor clearColor];
//    _timeLabel.textColor=[UIColor grayColor];
//    
//    _timeLabel.font = [UIFont systemFontOfSize:14.f];
//    [self.contentView addSubview:_timeLabel];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:-5.f]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_nameLabel
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                multiplier:1.0
//                                                                  constant:100]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:100]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:20.f]];
//
    

    
    for (int i = 0; i < 5; i++) {
        [self addStarViewWithTag:i + 1];
    }
}

- (void)addStarViewWithTag:(NSInteger)tag {
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
    

    CGFloat starSize = 18.f;
    CGFloat middleSpace = 4.f;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = kImageName(@"star_gray.png");
    imageView.tag = tag;
    [self.contentView addSubview:imageView];
    CGFloat rightSpace =  tag* (starSize + middleSpace);
   

    imageView.frame=CGRectMake(rightSpace,12 , 18, 18);
    




}

#pragma mark - Data

- (CGFloat)heightForComment:(NSString *)content {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                          nil];
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

    CGRect rect = [content boundingRectWithSize:CGSizeMake(wide - 40, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 > 20.f ? rect.size.height + 1 : 20.f;
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)setCommentData:(CommentModel *)model {
//    _nameLabel.text =[NSString stringWithFormat:@"%@    %@",model.name,model.createTime] ;
    if([self isBlankString:model.name])
    {
    model.name=@"";
        
    }
    if([self isBlankString:model.createTime])
    {
        model.createTime=@"";
        
    }
    
    
    NSString *priceString = [NSString stringWithFormat:@"%@    %@",model.name,model.createTime];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:16.f],NSFontAttributeName,
                                [UIColor blackColor],NSForegroundColorAttributeName,
                                nil];
    NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont boldSystemFontOfSize:15.f],NSFontAttributeName,
                               [UIColor grayColor],NSForegroundColorAttributeName,
                               nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, [model.name length])];
    [attrString addAttributes:priceAttr range:NSMakeRange([model.name length], [attrString length] - [model.name length])];
    _nameLabel.attributedText = attrString;

    
    
    if([self isBlankString:model.content])
    {
        model.content=@"";
        
    }
    
//    _timeLabel.text = model.createTime;
    _contentLabel.text = model.content;
    NSLog(@"%f",model.score);

    NSInteger score;
    score=model.score/10;
    
    for (UIImageView *starView in self.contentView.subviews) {
        if (starView.tag >= 1 && starView.tag <= 5) {
            if (starView.tag <=score)
            {
                starView.image = kImageName(@"star_light.png");
            }
            
            else
            {
                starView.image = kImageName(@"star_gray.png");
            }
        }
    }
}

@end
