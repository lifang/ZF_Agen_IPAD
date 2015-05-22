//
//  CsDetailController.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "CommonViewController.h"
#import "RecordView.h"
#import "ResourceModel.h"
#import "CSDataHandle.h"

typedef enum {
    OperationBtnCancel = 1,
    OperationBtnSubmitLogist,
    OperationBtnSubmitCancel,
}OperationBtnType; //详情是什么Btn
typedef enum {
    AlertViewCancelTag = 1,
    AlertViewSubmitTag,
}AlertViewTag;
@interface CsDetailController : CommonViewController

@property (nonatomic, assign) CSType csType;

@property(nonatomic,assign)OperationBtnType operationBtnType;

@property (nonatomic, strong) NSString *csID;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *records; //保存追踪记录

@property (nonatomic, strong) NSMutableArray *resources; //保存资料

- (void)parseCSDetailDataWithDictionary:(NSDictionary *)dict;

- (void)layoutButton:(UIButton *)button
            position:(OperationBtnType)btnType;

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space;

//取消申请
- (void)cancelApply;

//重新提交注销申请
- (void)submitCanncelApply;

//提交物流信息
-(void)submitLogistApply;
//根据文字布局高度
- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
         WithStr:(NSString *)str;
@end
