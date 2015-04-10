//
//  UserManagerCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "UserManagerCell.h"

@implementation UserManagerCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UserManagerCell";
    UserManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UserManagerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}

-(void)initAndLayoutUI
{
    _nameLabel = [[UILabel alloc]init];
    [self setLabel:_nameLabel withLeftView:self.contentView middleSpace:80.f labelTag:1];
    
    _phoneLabel = [[UILabel alloc]init];
    [self setLabel:_phoneLabel withLeftView:_nameLabel middleSpace:40.f labelTag:0];
    
    _emailLabel = [[UILabel alloc]init];
    [self setLabel:_emailLabel withLeftView:_phoneLabel middleSpace:40.f labelTag:0];
    
    _createAtLabel = [[UILabel alloc]init];
    [self setLabel:_createAtLabel withLeftView:_emailLabel middleSpace:30.f labelTag:0];
    
    _deleteBtn = [[UIButton alloc]init];
    _deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_deleteBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    CALayer *readBtnLayer = [_deleteBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:1.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kMainColor CGColor]];
    _deleteBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_deleteBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:15.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_createAtLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:40.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:110.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_deleteBtn
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:40.f]];
}

#pragma mark - Action
-(void)deleteBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(userManagerCellDeleteUserModel:)]) {
        [_delegate userManagerCellDeleteUserModel:_userManagerModel];
    }
}

//创建左边Label
//leftView-左边控件
//space-距左边间距
- (void)setLabel:(UILabel *)label
    withLeftView:(UIView *)leftView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat topSpace = 20.f;
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 160.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kColor(51, 51, 51, 51);
    [self.contentView addSubview:label];
    if (LabelTag == 1) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:leftView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:space]];
    }else{
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:leftView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:space]];
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:labelWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:labelHeight]];
    
}

#pragma mark - Data
-(void)setContentWithModel:(UserManagerModel *)model
{
    _userManagerModel = model;
    _nameLabel.text = model.name;
    _createAtLabel.text = model.createdAt;
    _phoneLabel.text = model.phone;
    _emailLabel.text = model.email;
}

@end
