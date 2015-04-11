//
//  StockManagerCell.h
//  ZF_Agent_IPad
//
//  Created by 黄含章 on 15/4/8.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "StockListModel.h"

@protocol StockCellDelegate <NSObject>

- (void)stockCellRenameForGood:(StockListModel *)model;

@end

#define hStockCellHeight 140.f

@interface StockManagerCell : UITableViewCell

@property(nonatomic,weak) id<StockCellDelegate> delegate;

@property(nonatomic,strong)UILabel *brandGrayLabel;
@property(nonatomic,strong)UILabel *channelGrayLabel;

/** POS名字 */
@property(nonatomic,strong)UILabel *stockPosNameLabel;
/** POS品牌型号 */
@property(nonatomic,strong)UILabel *stockBrandLabel;
/** 支付通道 */
@property(nonatomic,strong)UILabel *stockChannelLabel;
/** POS图片 */
@property(nonatomic,strong)UIImageView *stockPictureView;
/** 历史进货数量 */
@property(nonatomic,strong)UILabel *stockHistoryCountLabel;
/** 已开通数量 */
@property(nonatomic,strong)UILabel *stockOpenCountLabel;
/** 代理商库存 */
@property(nonatomic,strong)UILabel *stockAgentCountLabel;
/** 总库存 */
@property(nonatomic,strong)UILabel *stockTotalCountLabel;
/** 商品更名Btn */
@property(nonatomic,strong)UIButton *stockChangeBtn;
/** 库存管理List模型 */
@property(nonatomic,strong) StockListModel *stockModel;

-(void)setContentWithData:(StockListModel *)model;

@end
