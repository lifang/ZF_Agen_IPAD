//
//  StaffManagerCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/15.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffManagerModel.h"

@protocol StaffManagerDeleteClickedDelegate <NSObject>

@optional

-(void)deleteClickedWithStaffManagerModel:(StaffManagerModel *)model;

@end

@interface StaffManagerCell : UITableViewCell

@property(nonatomic,weak)id <StaffManagerDeleteClickedDelegate> delegate;
//初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setContentWithModel:(StaffManagerModel *)model;

@property(nonatomic,strong)UILabel *userNameLabel;

@property(nonatomic,strong)UILabel *loginIDLabel;

@property(nonatomic,strong)UILabel *creatTimeLabel;

@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,strong)StaffManagerModel *staffModel;

@end
