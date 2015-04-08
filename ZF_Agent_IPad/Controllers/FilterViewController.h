//
//  FilterViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

//列表界面刷新数据
static NSString *UpdateGoodListNotification = @"UpdateGoodListNotification";

@interface FilterViewController : CommonViewController
{
    
    BOOL _flagArray[8];
    BOOL _allbool[8];

    NSArray*namekey;
    NSArray*nameking;
    NSMutableArray*_chagnearry;
    NSMutableArray*_chagnearry1;
    NSMutableArray*_chagnearry2;
    NSMutableArray*_chagnearry3;
    NSMutableArray*_chagnearry4;
    NSMutableArray*_chagnearry5;
    NSMutableArray*_chagnearry6;

    NSMutableArray*bigarry;
    BOOL rentbool;
    
       NSInteger boolcountA;
    
    
}
///保存用户选择的筛选条件
@property (nonatomic, strong) NSMutableDictionary *filterDict;

@end
