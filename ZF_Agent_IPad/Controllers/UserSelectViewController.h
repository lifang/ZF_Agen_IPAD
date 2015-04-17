//
//  UserSelectViewController.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/16.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "RefreshViewController.h"
#import "UserModel.h"

@protocol SelectedUserDelegate <NSObject>

- (void)selectedUser:(UserModel *)model;

@end


@interface UserSelectViewController :  RefreshViewController

@property (nonatomic, assign) id<SelectedUserDelegate>delegate;

@end
