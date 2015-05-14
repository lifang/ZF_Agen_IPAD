//
//  TerminalViewCell.h
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/7.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalManagerModel.h"

@protocol terminalCellSendBtnClicked <NSObject>

@optional
-(void)terminalCellBtnClicked:(int) btnTag WithSelectedID:(NSString *)selectedID Withindex:(int)indexNum;

@end

@interface TerminalViewCell : UITableViewCell

/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** POS机 */
@property(nonatomic,strong)UILabel *posLabel;
/** 支付通道 */
@property(nonatomic,strong)UILabel *payRoad;
/** 开通状态 */
@property(nonatomic,strong)UILabel *dredgeStatus;

@property(nonatomic,strong)NSString *cellStates;

@property(nonatomic,strong)NSString *selectedID;

//@property(nonatomic,strong)NSString *videoVerify;//视频认证

@property(nonatomic,assign)int indexNum;

@property(nonatomic,weak)id<terminalCellSendBtnClicked> TerminalViewCellDelegate;



@end
