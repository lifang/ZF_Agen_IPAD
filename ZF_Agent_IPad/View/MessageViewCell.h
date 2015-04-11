//
//  MessageViewCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

@protocol MessageCellClickedDelegate <NSObject>

@optional

-(void)messageCellClickedWithMessageID:(NSString *)messageID WithBtnStatus:(BOOL)btnStatus;

@end

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

@property(nonatomic,weak)id MessageCellClickedDelegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,assign)BOOL btnStatus;

@property(nonatomic,assign)BOOL isRead;

@property(nonatomic,strong)NSString *selectedID;

-(void)btnClicked;
@end
