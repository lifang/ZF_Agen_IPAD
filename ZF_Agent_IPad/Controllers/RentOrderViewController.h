//
//  RentOrderViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderConfirmController.h"
#import "GoodDetialModel.h"
#import "UserModel.h"

@interface RentOrderViewController : OrderConfirmController

{
    UIButton *locationBtn;
    
    NSString*namestring;
    
    UIButton *defaultbutton;
    BOOL defaultbool;
    UIButton*_cityField;
    NSInteger B;
    BOOL isneedpp;
    UIButton*blankbutton;
    NSInteger changeB;
    BOOL changeagent;
    NSInteger cityint;
    NSInteger Okcityint;
     NSString *agentUserIDs;  //代理商对应的用户id
    NSString*textnsstring;
    NSString*billnsstring;
    UIImageView*bigsview;
}
//若从购物车跳转过来 保存选中的数据
@property (nonatomic, strong) NSArray *shoppingCartItem;
@property (nonatomic, strong) UIView *addressView;   //地址view
@property (nonatomic, strong) UserModel *defaultUser;

@property (nonatomic, strong) UILabel *nameLabel;  //收件人

@property (nonatomic, strong) UILabel *phoneLabel;  //手机

@property (nonatomic, strong) UILabel *addressLabel;  //地址

@property (nonatomic, strong) UIButton *billBtn;   //是否需要发票按钮

@property (nonatomic, strong) UITextField *billField;  //发票抬头

@property (nonatomic, assign) BillType billType;
@property (nonatomic, strong) UITextField *reviewField;  //留言

@property (nonatomic, assign) PushWay pushWay;

//@property (nonatomic, strong) AddressModel *defaultAddress;


@property (nonatomic, strong) GoodDetialModel *goodDetail;

@end