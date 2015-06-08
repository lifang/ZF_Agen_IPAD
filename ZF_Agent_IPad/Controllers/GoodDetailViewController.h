//
//  GoodDetailViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "NetworkInterface.h"

@interface GoodDetailViewController : CommonViewController

{    UIView *view;
    UIView *handleViewfrdef;
    UIImageView*bigsview;
    UIView*witeview;
    NSMutableArray*picturearry;
    UILabel *allTitleLabel ;
    UILabel *allmoneypeLabel;
}
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, assign) NSInteger  secletA;
@property (nonatomic, assign) SupplyGoodsType supplyType;

@end
