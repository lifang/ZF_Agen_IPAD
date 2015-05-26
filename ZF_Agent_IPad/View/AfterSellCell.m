//
//  AfterSellCell.m
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/13.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "AfterSellCell.h"
#import "NetworkInterface.h"

@interface AfterSellCell()

@property(nonatomic,assign)AfterSellType afterType;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *submitLogisticsBtn;

@property(nonatomic,strong)UIButton *submitCancelBtn;

@property(nonatomic,strong)NSString *identifier;

@end

@implementation AfterSellCell

+(instancetype)cellWithTableView:(UITableView *)tableView WithAfterSellType:(AfterSellType)type WithCsModel:(CSModel *)model
{
    NSString *ID = nil;
    switch (type) {
        case AfterSellTypeSell:
            ID = [model getCellIdentifier];
            break;
        case AfterSellTypeCancel:
            ID = [model getCellIdentifier1];
            break;
        case AfterSellTypeUpdate:
            ID = [model getCellIdentifier2];
            break;
        default:
            break;
    }
    AfterSellCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AfterSellCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID WithModel:model WithcsType:type];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithModel:(CSModel *)model WithcsType:(AfterSellType)afterType
{
    self.identifier = reuseIdentifier;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.afterType = afterType;
        [self initAndLayoutUIWithModel:model];
    }
    return self;
}

#pragma mark - UI

-(void)initAndLayoutUIWithModel:(CSModel *)model
{
    _afterNum = [[UILabel alloc]init];
    [self setLabel:_afterNum withLeftView:self.contentView middleSpace:80.f labelTag:1];
    
    _terminalNum = [[UILabel alloc]init];
    [self setLabel:_terminalNum withLeftView:_afterNum middleSpace:50.f labelTag:0];
    
    _dateLable = [[UILabel alloc]init];
    [self setLabel:_dateLable withLeftView:_terminalNum middleSpace:20.f labelTag:0];
    
    _afterStatus = [[UILabel alloc]init];
    [self setLabel:_afterStatus withLeftView:_dateLable middleSpace:10.f labelTag:0];
    
    NSLog(@"~~~~~~~%d",_afterType);
    [self setContentForReuseIdentifier];
    
}


-(void)setContentForReuseIdentifier
{
    switch (_afterType) {
        case AfterSellTypeSell:{
            //售后单记录
            if ([_identifier isEqualToString:thirdStatusIdentifier] ||
                [_identifier isEqualToString:forthStatusIdentifier] ||
                [_identifier isEqualToString:fifthStatusIdentifier]) {
                //处理中、处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:secondStatusIdentifier])
            {
                [self setsubmitButton];
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier]) {
                //待处理 取消申请
                [self setCancelButton];
            }
        }
            break;
        case AfterSellTypeUpdate: {
            
            //更新资料记录
            if ([_identifier isEqualToString:secondStatusIdentifier2] ||
                [_identifier isEqualToString:forthStatusIdentifier2] ||
                [_identifier isEqualToString:fifthStatusIdentifier2] ||
                [_identifier isEqualToString:thirdStatusIdentifier2]) {
                //处理中、处理完成、已取消无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier2]) {
                //待处理
                [self setCancelButton];
            }
        }
            break;
        case AfterSellTypeCancel: {
            //注销记录
            if ([_identifier isEqualToString:secondStatusIdentifier1] ||
                [_identifier isEqualToString:forthStatusIdentifier1] ||
                [_identifier isEqualToString:thirdStatusIdentifier1]) {
                //处理中、处理完成无操作
                return;
            }
            else if ([_identifier isEqualToString:firstStatusIdentifier1]) {
                //待处理
                [self setCancelButton];
            }
            else if ([_identifier isEqualToString:fifthStatusIdentifier1]) {
                [self setSubmitCancelBtn];
            }
        }
            break;
        default:
            break;
    }

}

-(void)setCancelButton
{
    _cancelBtn = [[UIButton alloc]init];
    _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"取消申请" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_cancelBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    CALayer *readBtnLayer = [_cancelBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kMainColor CGColor]];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_cancelBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_afterStatus
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:120.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_cancelBtn
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:40.f]];
}

-(void)setsubmitButton
{
    _submitLogisticsBtn = [[UIButton alloc]init];
    _submitLogisticsBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_submitLogisticsBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [_submitLogisticsBtn setTitle:@"提交物流信息" forState:UIControlStateNormal];
    _submitLogisticsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_submitLogisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CALayer *readBtnLayer1 = [_submitLogisticsBtn layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kMainColor CGColor]];
    _submitLogisticsBtn.backgroundColor = kMainColor;
    [self.contentView addSubview:_submitLogisticsBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitLogisticsBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_afterStatus
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitLogisticsBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitLogisticsBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:120.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitLogisticsBtn
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:40.f]];
}

-(void)setSubmitCancelBtn
{
    _submitCancelBtn = [[UIButton alloc]init];
    _submitCancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_submitCancelBtn addTarget:self action:@selector(submitCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [_submitCancelBtn setTitle:@"重新提交注销" forState:UIControlStateNormal];
    _submitCancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_submitCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CALayer *readBtnLayer1 = [_submitCancelBtn layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kMainColor CGColor]];
    _submitCancelBtn.backgroundColor = kMainColor;
    [self.contentView addSubview:_submitCancelBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitCancelBtn
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_afterStatus
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitCancelBtn
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitCancelBtn
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:120.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_submitCancelBtn
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:40.f]];

}

-(void)setContentWithData:(CSModel *)model WithAfterType:(AfterSellType)afterType
{
    _afterNum.text = model.applyNum;
    _terminalNum.text = model.terminalNum;
    _dateLable.text = model.createTime;
    _afterStatus.text = [[self class] getStatusStringWithCSType:afterType status:model.status];
}

//创建Label
//leftView-左边控件
//space-距左边间距
- (void)setLabel:(UILabel *)label
    withLeftView:(UIView *)leftView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat topSpace = 30.f;
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

-(void)typeWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:@"afterCell1"]) {
        self.afterType = AfterSellTypeSell;
    }
    if ([reuseIdentifier isEqualToString:@"afterCell2"]) {
        self.afterType = AfterSellTypeCancel;
    }
    if ([reuseIdentifier isEqualToString:@"afterCell3"]) {
        self.afterType = AfterSellTypeUpdate;
    }
}

+ (NSString *)getStatusStringWithCSType:(AfterSellType)afterType
                                 status:(int)status {
    NSString *statuString = nil;
    switch (afterType) {
        case AfterSellTypeSell:
            statuString = [[self class] aftersaleStatusStringWithStatus:status];
            break;
        case AfterSellTypeUpdate:
            statuString = [[self class] updateStatusStringWithStatus:status];
            break;
        case AfterSellTypeCancel:
            statuString = [[self class] cancelStatusStringWithStauts:status];
            break;
        default:
            break;
    }
    return statuString;
}



+ (NSString *)aftersaleStatusStringWithStatus:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            statusString = @"处理完成";
            break;
        case CSStatusForth:
            statusString = @"已取消";
            break;
        case CSStatusFifth:
            break;
        default:
            break;
    }
    return statusString;
}

+ (NSString *)updateStatusStringWithStatus:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            statusString = @"处理完成";
            break;
        case CSStatusFifth:
            statusString = @"已取消";
            break;
        default:
            break;
    }
    return statusString;
}

+ (NSString *)cancelStatusStringWithStauts:(int)status {
    NSString *statusString = nil;
    switch (status) {
        case CSStatusAll:
            statusString = @"全部";
            break;
        case CSStatusFirst:
            statusString = @"待处理";
            break;
        case CSStatusSecond:
            statusString = @"处理中";
            break;
        case CSStatusThird:
            break;
        case CSStatusForth:
            statusString = @"处理完成";
            break;
        case CSStatusFifth:
            statusString = @"已取消";
            break;
        default:
            break;
    }
    return statusString;
}

#pragma mark - Action
//取消申请
-(void)cancelClicked
{
    NSLog(@"取消申请！");
    if (_delegate && [_delegate respondsToSelector:@selector(cancelClickedWithCSModel:)]) {
        [_delegate cancelClickedWithCSModel:_csModel];
    }
}
//提交物流信息
-(void)submitClicked
{
    NSLog(@"提交物流信息");
    if (_delegate && [_delegate respondsToSelector:@selector(submitLogisticsClickedWithCSModel:)]) {
        [_delegate submitLogisticsClickedWithCSModel:_csModel];
    }
}
//重新提交注销
-(void)submitCancelClicked
{
    NSLog(@"重新提交注销");
    if (_delegate && [_delegate respondsToSelector:@selector(submitCancelClickedWithCSModel:)]) {
        [_delegate submitCancelClickedWithCSModel:_csModel];
    }
}
@end
