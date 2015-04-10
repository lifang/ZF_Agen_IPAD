//
//  RecordView.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"


@interface RecordView : UIView

@property (nonatomic, strong) NSArray *recordItems;

@property (nonatomic, assign) CGFloat width;

- (id)initWithRecords:(NSArray *)records
                width:(CGFloat)width;

- (CGFloat)getHeight;

- (void)initAndLayoutUI;


@end
