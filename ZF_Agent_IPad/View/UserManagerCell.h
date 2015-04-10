//
//  UserManagerCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/9.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManagerModel.h"

@protocol userManagerCellDelegate <NSObject>

- (void)userManagerCellDeleteUserModel:(UserManagerModel *)model;

@end

#define hUserModelCellHeight 70.f

@interface UserManagerCell : UITableViewCell

@property(nonatomic,weak)id <userManagerCellDelegate> delegate;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *phoneLabel;

@property(nonatomic,strong)UILabel *emailLabel;

@property(nonatomic,strong)UILabel *createAtLabel;

@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,strong)UserManagerModel *userManagerModel;

-(void)setContentWithModel:(UserManagerModel *)model;

//初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
