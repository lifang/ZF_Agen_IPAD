//
//  ChooseView.h
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ChooseViewNone = 0,     //无
    ChooseViewMyOrder = 1,  //我的订单
    ChooseViewAfterSell = 2,//售后记录
    ChooseViewMyMessage = 3,//我得信息
    ChooseViewMyShop = 4,   //我得商户
    ChooseViewApplyplan = 5,//申请进度
}ChooseViewType;

@interface ChooseView : UIView

- (id)initWithFrame:(CGRect)frame With:(ChooseViewType)ChooseViewtype;

@property(nonatomic,assign)ChooseViewType chooseType;

@property(nonatomic,strong)UIButton *orderBtn;

@property(nonatomic,strong)UIButton *aftersellBtn;

@property(nonatomic,strong)UIButton *messageBtn;

@property(nonatomic,strong)UIButton *shopBtn;

@property(nonatomic,strong)UIButton *applyBtn;

@property(nonatomic,strong)UIImageView *imageView;


@end
