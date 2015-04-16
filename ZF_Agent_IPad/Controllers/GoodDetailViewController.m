//
//  GoodDetailViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "GoodDetialModel.h"
#import "GoodButton.h"
#import "UIImageView+WebCache.h"
#import "FormView.h"
//#import "BuyOrderViewController.h"
#import "PollingViews.h"
#import "ImageScrollView.h"
#import "InterestView.h"
#import "GoodDetaildetailViewController.h"
//#import "RentOrderViewController.h"
#import "FactoryDetailController.h"
#import "LoginViewController.h"
#import "AccountTool.h"
#import "ChannelWebsiteController.h"
//static CGFloat topImageHeight = 160.f;

@interface GoodDetailViewController ()<UIScrollViewDelegate,ImageScrollViewDelegate,LoginSuccessDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) PollingViews *topScorllView;

@property (nonatomic, strong) GoodDetialModel *detailModel;

@property (nonatomic, strong) UIView *footerView;

//控件
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) GoodButton *buyButton;
@property (nonatomic, strong) GoodButton *rentButton;

@property (nonatomic, strong) UIButton *shopcartButton;  //购物车按钮
@property (nonatomic, strong) UIButton *buyGoodButton;   //立刻购买
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *scrollPanel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UILabel *pageLabel;
@property(nonatomic,assign)BOOL isLogin;
@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.secletA=1024;
    self.isLogin = NO;
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    
    
    UIButton *shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(0, 0, 30, 30);
    [shoppingButton setBackgroundImage:[UIImage imageNamed:@"good_right1@2x"] forState:UIControlStateNormal];
    
    //    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(goShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem, shoppingItem,nil];
    
    
    
    
    UIImage *image=[UIImage imageNamed:@"back_btn_white"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 25, 40);
    
    [btn setImage :image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,backItem,spaceItem,nil];
    [self downloadGoodDetail];
}
-(void)popself

{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (IBAction)goShoppingCart:(id)sender {
//    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.tabBarViewController setSeletedIndex:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initAndLayoutUI {
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //    _mainScrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_mainScrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mainScrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    //image
    if(iOS7)
    {
        
        _topScorllView = [[PollingViews alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT/2, SCREEN_HEIGHT/2)];
        
        
    }
    else
    {
        _topScorllView = [[PollingViews alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenWidth/2)];
        
        
    }
 
//    _topScorllView.backgroundColor = [UIColor blackColor];
    [_mainScrollView addSubview:_topScorllView];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.backgroundColor = [UIColor clearColor];
    //    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    _buyButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_buyButton setButtonAttrWithTitle:@"代购买"];
    [_buyButton addTarget:self action:@selector(buyGood:) forControlEvents:UIControlEventTouchUpInside];
    _buyButton.selected = YES;
    _rentButton = [GoodButton buttonWithType:UIButtonTypeCustom];
    [_rentButton setButtonAttrWithTitle:@"代租赁"];
    [_rentButton addTarget:self action:@selector(rentGood:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initImageScanView];

    
    [self initSubViews];
}
- (void)initImageScanView {
    _scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
    _scrollPanel.backgroundColor = [UIColor clearColor];
    _scrollPanel.alpha = 0;
    [self.view addSubview:_scrollPanel];
    CGRect rect = _scrollPanel.bounds;
    rect.size.height += 64;
    _markView = [[UIView alloc] initWithFrame:rect];
    _markView.backgroundColor = [UIColor blackColor];
    _markView.alpha = 0.0;
    [_scrollPanel addSubview:_markView];
    
    _imagesScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollPanel addSubview:_imagesScrollView];
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.delegate = self;
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height - 40, rect.size.width, 20)];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont boldSystemFontOfSize:14];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollPanel addSubview:_pageLabel];
}
#pragma mark - 图片点击

- (IBAction)touchPicture:(UITapGestureRecognizer *)tap {
    [self.view bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    UIImageView *imageView = (UIImageView *)[tap view];
    self.currentIndex = imageView.tag;
    
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
    CGPoint contentOffset = self.imagesScrollView.contentOffset;
    contentOffset.x = (self.currentIndex - 1) * self.view.bounds.size.width;
    self.imagesScrollView.contentOffset = contentOffset;
    
    [self addImageScrollViewForController:self];
    
    ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){contentOffset,self.imagesScrollView.bounds.size}];
    [imagescroll setContentWithFrame:convertRect];
    [imagescroll setImage:imageView.image];
    [self.imagesScrollView addSubview:imagescroll];
    imagescroll.tapDelegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:imagescroll afterDelay:0.1f];
}

#pragma mark - 大图

- (void)addImageScrollViewForController:(UIViewController *)controller {
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 1; i <= self.totalPage; i++) {
        if (i == self.currentIndex) {
            continue;
        }
        UIImageView *imageView = (UIImageView *)[_topScorllView viewWithTag:i];
        CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
        ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:(CGRect){(i - 1) * self.imagesScrollView.bounds.size.width,0,self.imagesScrollView.bounds.size}];
        [imagescroll setContentWithFrame:convertRect];
        [imagescroll setImage:imageView.image];
        [self.imagesScrollView addSubview:imagescroll];
        imagescroll.tapDelegate = (id<ImageScrollViewDelegate>)controller;
        [imagescroll setAnimationRect];
    }
}

- (void)setOriginFrame:(ImageScrollView *)sender {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex,self.totalPage];
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
    }];
}

#pragma mark - ImageScrollViewDelegate

- (void)tapImageViewWithObject:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.markView.alpha = 0;
        [sender rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _imagesScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,_totalPage];
    }
}

- (void)initSubViews {
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat leftSpace ;  //左侧间距
    CGFloat  originXs;

    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }

    if(iOS7)
    {
        
        leftSpace = SCREEN_HEIGHT/2+20;  //左侧间距
        
        
    }
    else
    {
        leftSpace = SCREEN_WIDTH/2+20;  //左侧间距
        
        
    }
    
    CGFloat rightSpace = 25.f; //右侧间距
    CGFloat labelHeight = 20.f; //label 高度
    CGFloat firstSpace = 5.f;
    CGFloat vSpace = 12.f;  //label 垂直间距
    CGFloat hSpace = 10.f;
    CGFloat leftLabelWidth = 80.f;  //左侧标题label宽度
    CGFloat btnHeight = 40.f;  //支付通道 和 购买方式 按钮高度
    CGFloat btnWidth = (wide - leftSpace - rightSpace - leftLabelWidth - firstSpace - 2 * hSpace) / 3;
    CGFloat originY =vSpace;
    //商品名
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftSpace - rightSpace, labelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.text = _detailModel.goodName;
    [_mainScrollView addSubview:titleLabel];
    
    originY += vSpace + labelHeight;
    //商品简介
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftSpace- rightSpace, labelHeight)];
    summaryLabel.backgroundColor = [UIColor clearColor];
    summaryLabel.font = [UIFont systemFontOfSize:17.f];
    summaryLabel.textColor = [UIColor lightGrayColor];
    summaryLabel.text = _detailModel.detailName;
    [_mainScrollView addSubview:summaryLabel];
    
    originY += vSpace + labelHeight;
    //品牌
    UILabel *brandTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:brandTitleLabel withTitle:@"品牌型号" font:[UIFont systemFontOfSize:17.f]];
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 100, labelHeight)];
    
    NSString*stringlong=[NSString stringWithFormat:@"%@  %@",_detailModel.goodBrand,_detailModel.goodModel];
    
    [self setLabel:brandLabel withTitle:stringlong font:[UIFont boldSystemFontOfSize:17.f]];
    
    //厂家信息
    CGFloat originX = leftSpace + leftLabelWidth + firstSpace + 80;
    UILabel *factoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandLabel.frame.size.width+brandLabel.frame.origin.x+40, originY, 90.f, labelHeight)];
    factoryLabel.backgroundColor = [UIColor clearColor];
    factoryLabel.font = [UIFont systemFontOfSize:14.f];
    factoryLabel.text = @"查看厂家信息";
    [_mainScrollView addSubview:factoryLabel];
    
    //厂家按钮
    UIButton *factoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [factoryBtn setBackgroundImage :kImageName(@"info.png") forState:UIControlStateNormal];

    factoryBtn.frame = CGRectMake(factoryLabel.frame.origin.x + factoryLabel.frame.size.width + vSpace, originY, 20, 20);
//    factoryBtn.enabled = NO;
    [factoryBtn addTarget:self action:@selector(scanFactoryInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:factoryBtn];
    
//    originY += vSpace + labelHeight;
//    //型号
//    UILabel *modelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
//    [self setLabel:modelTitleLabel withTitle:@"" font:[UIFont systemFontOfSize:17.f]];
//    UILabel *modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, 80, labelHeight)];
//    [self setLabel:modelLabel withTitle: font:[UIFont boldSystemFontOfSize:17.f]];
//    
    //已售
    //    UILabel *saleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, kScreenWidth - originX, labelHeight)];
    //    saleNumberLabel.backgroundColor = [UIColor clearColor];
    //    saleNumberLabel.font = [UIFont systemFontOfSize:13.f];
    //    saleNumberLabel.textAlignment = NSTextAlignmentRight;
    //    saleNumberLabel.text = [NSString stringWithFormat:@"已售%d",[_detailModel.goodSaleNumber intValue]];
    //
    originY += vSpace + labelHeight;
    //终端类型
    UILabel *terTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, labelHeight)];
    [self setLabel:terTypeTitleLabel withTitle:@"终端类型" font:[UIFont systemFontOfSize:17.f]];
    UILabel *terTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, wide - leftSpace - rightSpace - leftLabelWidth, labelHeight)];
    [self setLabel:terTypeLabel withTitle:_detailModel.goodCategory font:[UIFont boldSystemFontOfSize:17.f]];
    
    //价格
    originY += vSpace + labelHeight;
    _priceLabel.frame = CGRectMake(leftSpace, originY, leftSpace- rightSpace, labelHeight);
    
    
    if (_buyButton.isSelected) {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.goodPrice + _detailModel.defaultChannel.openCost]];
    }
    else {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.deposit + _detailModel.defaultChannel.openCost]];
    }

    [_mainScrollView addSubview:_priceLabel];
    
    
    if (self.supplyType==2)
    {
        
    }
    else {
        
        UILabel *originalable = [[UILabel alloc] initWithFrame:CGRectMake(200+_priceLabel.frame.origin.x+20, originY, _priceLabel.frame.size.width, labelHeight)];
        NSString *primaryPrice = [NSString stringWithFormat:@"原价 ￥%.2f",_detailModel.originalprice];
        NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:primaryPrice];
        NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:15.f],NSFontAttributeName,
                                   [NSNumber numberWithInt:2],NSStrikethroughStyleAttributeName,
                                   nil];
        [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, [priceAttrString length])];
        originalable.attributedText = priceAttrString;
        
        [_mainScrollView addSubview:originalable];
        
    }

    //支付通道
    originY += labelHeight + 10.f;
    UILabel *channelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
    [self setLabel:channelTitleLabel withTitle:@"支付通道" font:[UIFont systemFontOfSize:17.f]];
    originXs = leftSpace + leftLabelWidth + firstSpace;
    CGFloat channelOriginY = originY;
    for (int i = 0; i < [_detailModel.channelItem count]; i++) {
        if (i % 3 == 0 && i != 0) {
            originXs = leftSpace + leftLabelWidth + firstSpace;
            channelOriginY += btnHeight + hSpace;
        }
        ChannelModel *model = [_detailModel.channelItem objectAtIndex:i];
        GoodButton *btn = [GoodButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(originXs, channelOriginY, btnWidth, btnHeight);
        btn.ID = model.channelID;
        [btn setButtonAttrWithTitle:model.channelName];
        if ([model.channelID isEqualToString:_detailModel.defaultChannel.channelID]) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:btn];
        originXs += btnWidth + hSpace;
    }
    
    originY += labelHeight + 10.f;
    UILabel *introducelable = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY+20, leftLabelWidth, btnHeight)];
    [self setLabel:introducelable withTitle:@"通道介绍" font:[UIFont systemFontOfSize:17.f]];
    //厂家图片
    originY += vSpace + 1;
    UIImageView *factoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace+introducelable.frame.size.width+10, originY+20, 60, labelHeight)];
    
    [factoryImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.factoryImagePath] placeholderImage:[UIImage imageNamed:@"test1" ]];
    
//    [factoryImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.factoryImagePath]];
    [_mainScrollView addSubview:factoryImageView];
    NSLog(@"%@",_detailModel.factoryWebsite);
    
    //厂家网址
    UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+introducelable.frame.size.width+10+80, originY+20, wide - leftLabelWidth - leftSpace-140, labelHeight)];
    [self setLabel:websiteLabel withTitle:_detailModel.defaultChannel.channelFactoryURL font:[UIFont systemFontOfSize:13.f]];
    websiteLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpForWebsite:)];
    [websiteLabel addGestureRecognizer:websiteTap];
    //厂家简介
    originY += vSpace + labelHeight+30;
    CGFloat summaryHeight = [self heightWithString:_detailModel.factorySummary
                                             width:wide - leftSpace - rightSpace
                                          fontSize:13.f];
    UILabel *factorySummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+80, originY, leftSpace - 40, summaryHeight)];
    [self setLabel:factorySummaryLabel withTitle:_detailModel.defaultChannel.channelFactoryDescription font:[UIFont systemFontOfSize:13.f]];

    
    int rows = (int)([_detailModel.channelItem count] - 1) / 3 + 1;
    originY += rows * (btnHeight + hSpace);
    
    //购买方式
    UILabel *buyTypeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, leftLabelWidth, btnHeight)];
    _buyButton.frame = CGRectMake(leftSpace + leftLabelWidth + firstSpace, originY, btnWidth, btnHeight);
    _rentButton.frame = CGRectMake(_buyButton.frame.origin.x + _buyButton.frame.size.width + hSpace, originY, btnWidth, btnHeight);
    [_mainScrollView addSubview:_rentButton];
    if (self.supplyType==2) {
        if(_detailModel.canRent)
        {
            _rentButton.hidden = NO;
            [self setLabel:buyTypeTitleLabel withTitle:@"购买方式" font:[UIFont systemFontOfSize:17.f]];
            [_mainScrollView addSubview:_buyButton];}
        else
        {
            _rentButton.hidden = YES;

        
        
        }
     

    }
    else {
        _rentButton.hidden = YES;
    }
    
    _shopcartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shopcartButton.frame = CGRectMake(buyTypeTitleLabel.frame.origin.x, _buyButton.frame.origin.y + _buyButton.frame.size.height+20, wide/4-80, 40);
    //    _shopcartButton.layer.cornerRadius = 4.f;
    _shopcartButton.layer.masksToBounds = YES;
    //    _shopcartButton.layer.borderWidth = 1.f;
    [_shopcartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shopcartButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    [_shopcartButton setBackgroundImage:kImageName(@"yellowback") forState:UIControlStateNormal];
    
    [_shopcartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    _shopcartButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_shopcartButton addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //立即购买
    _buyGoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyGoodButton.frame = CGRectMake(_shopcartButton.frame.origin.x+_shopcartButton.frame.size.width+20, _buyButton.frame.origin.y + _buyButton.frame.size.height+20, wide/4, 40);
    _buyGoodButton.center=CGPointMake(wide/4*3-20,  _buyButton.frame.origin.y + _buyButton.frame.size.height+60);
    
    
    //    _buyGoodButton.layer.cornerRadius = 4.f;
    _buyGoodButton.layer.masksToBounds = YES;
    [_buyGoodButton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    _buyGoodButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_buyGoodButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_buyGoodButton];
    if (self.supplyType==2) {
        [_buyGoodButton setTitle:@"代购" forState:UIControlStateNormal];

           }
    else {
        
        [_buyGoodButton setTitle:@"立即批购" forState:UIControlStateNormal];

    }

    UIView *handleView = [self handleViewWithOriginY:_topScorllView.frame.origin.y+_topScorllView.frame.size.height+60];
    [_mainScrollView addSubview:handleView];
    handleView.userInteractionEnabled=YES;
    
    //按钮view
//    originY += summaryHeight + 10;
////    UIView *handleView = [self handleViewWithOriginY:_topScorllView.frame.origin.y+_topScorllView.frame.size.height+60];
//    [_mainScrollView addSubview:handleView];
//    UIView *firstLine = [[UIView alloc] init];
//    
//    
//    if(iOS7)
//    {
//        firstLine.frame=CGRectMake(0, handleView.frame.origin.y, SCREEN_HEIGHT , 1);
//        
//    }else
//    {
//        firstLine.frame=CGRectMake(0, handleView.frame.origin.y, SCREEN_WIDTH , 1);
//        
//        
//    }
//    firstLine.backgroundColor = [UIColor grayColor];
//    [_mainScrollView addSubview:firstLine];
//    
//    originY += handleView.frame.size.height+handleView.frame.origin.y;
    
}
- (IBAction)jumpForWebsite:(id)sender {
    ChannelWebsiteController *websiteC = [[ChannelWebsiteController alloc] init];
    websiteC.hidesBottomBarWhenPushed=YES;
    
    websiteC.title = @"支付通道";
    websiteC.urlString = _detailModel.defaultChannel.channelFactoryURL;
    [self.navigationController pushViewController:websiteC animated:YES];
}
- (CGFloat)heightWithString:(NSString *)content
                      width:(CGFloat)width
                   fontSize:(CGFloat)fontSize {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:fontSize],NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height > 20.f ? rect.size.height : 20.f;
}

- (UIView *)handleViewWithOriginY:(CGFloat)originY {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    

    UIView *viewbutton = [[UIView alloc] init];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 1)];

    if(iOS7)
    {
        viewbutton.frame=CGRectMake(0, height-65-64, SCREEN_HEIGHT , 65 );
        
    }else
    {
        viewbutton.frame=CGRectMake(0, height-65-64, SCREEN_WIDTH , 65 );
        
        
        
    }
    [viewbutton addSubview:lineview];
    lineview.backgroundColor = [UIColor grayColor];
    viewbutton.backgroundColor = [UIColor whiteColor];
    if (self.supplyType==2)
    {
        
        if(_detailModel.canRent)
        {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"租赁说明",@"  交易费率", nil];
        
        
        for (int i = 0; i < 5; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rentButton.frame = CGRectMake(viewbutton.frame.size.width / 11*(2*i +1), 10, viewbutton.frame.size.width / 11, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            rentButton.tag=i+1024;
            
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewbutton addSubview:rentButton];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewbutton.frame.size.width / 5*(i+1), 20, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [viewbutton addSubview:line];
        }
        }
        
        else
            
        {
            NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
            
            NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"交易费率", nil];
            
            
            for (int i = 0; i < 4; i++ ) {
                
                UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
                rentButton.frame = CGRectMake(viewbutton.frame.size.width / 9*(2*i +1), 10, viewbutton.frame.size.width / 9, 45);
                [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
                rentButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
                rentButton.tag=i+1024;
                
                [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
                [viewbutton addSubview:rentButton];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewbutton.frame.size.width / 4*(i+1), 20, 1, 30)];
                line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                [viewbutton addSubview:line];
            }
            
            
            
            
        }

    }
    else
    
    {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"交易费率", nil];
        
        
        for (int i = 0; i < 4; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rentButton.frame = CGRectMake(viewbutton.frame.size.width / 9*(2*i +1), 10, viewbutton.frame.size.width / 9, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            rentButton.tag=i+1024;
            
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewbutton addSubview:rentButton];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewbutton.frame.size.width / 4*(i+1), 20, 1, 30)];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
            [viewbutton addSubview:line];
        }
        
        
        
        
    }
    
//     handleViewfrdef= [self  handleViewWithOriginYs: viewbutton.frame.size.height+viewbutton.frame.origin.y];
//    handleViewfrdef.userInteractionEnabled=YES;
//    _mainScrollView.userInteractionEnabled=YES;
//
//    
//    [_mainScrollView addSubview:handleViewfrdef];
    
    
    //竖线
    //    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 0.5f, 25)];
    //    firstLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:firstLine];
    //    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 55, 0.5f, 25)];
    //    secondLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:secondLine];
    return viewbutton;
}
- (IBAction)scanFactoryInfo:(id)sender {
    FactoryDetailController *factoryC = [[FactoryDetailController alloc] init];
    factoryC.hidesBottomBarWhenPushed = YES;

    factoryC.goodDetail = _detailModel;
    [self.navigationController pushViewController:factoryC animated:YES];
}

-(void)scanRent:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    GoodDetaildetailViewController*goodedetal=[[GoodDetaildetailViewController alloc]init];
    goodedetal.goodID = _detailModel.goodID;
    goodedetal.secletA=sender.tag;
    goodedetal.goodDetail=_detailModel;
    goodedetal.channelData = _detailModel.defaultChannel;
    goodedetal.supplyType=self.supplyType;
    
    goodedetal.tradeRateItem = _detailModel.defaultChannel.dateRateItem;

    goodedetal.hidesBottomBarWhenPushed =  YES ;

    [self.navigationController pushViewController:goodedetal animated:YES];
    
}


//POS信息

- (IBAction)selectedRelativeGood:(UITapGestureRecognizer *)sender {

    InterestView *viewhg= (InterestView *)[sender view];
    
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    detailC.goodID = viewhg.relativeGood.relativeID;
    detailC.hidesBottomBarWhenPushed =  YES ;

    [self.navigationController pushViewController:detailC animated:YES];
}
- (void)addLabelWithTitle:(NSString *)title
                  content:(NSString *)content
                  offsetY:(CGFloat)offsetY {
    CGFloat leftSpace = 20.f;
    CGFloat titleLabelWidth = 100.f;
    CGFloat labelHeight = 20.f;
    CGFloat middleLeftSpace = leftSpace + titleLabelWidth + 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, offsetY, titleLabelWidth, labelHeight)];
    [self setLabels :titleLabel withTitle:title font:[UIFont systemFontOfSize:14.f]];
    [view addSubview:titleLabel];
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftSpace, offsetY, wide - middleLeftSpace, labelHeight)];
    [self setLabels:contentLabel withTitle:content font:[UIFont systemFontOfSize:14.f]];
    
}
- (void)setLabels:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
    [view addSubview:label];
}
- (void)setLabel:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
    [_mainScrollView addSubview:label];
}

- (void)setPriceWithString:(NSString *)price {
    NSString *priceString ;
    
    
    
    if (self.supplyType==2) {
        
        if(_buyButton.selected)
        {
            priceString = [NSString stringWithFormat:@"代购价格   ￥%@",price];

        }else
        {
            priceString = [NSString stringWithFormat:@"租赁价格   ￥%@",price];

        
        }
        

    }
    else {
       priceString = [NSString stringWithFormat:@"批购价格   ￥%@",price];

        
    }

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSDictionary *normalAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:17.f],NSFontAttributeName,
                                [UIColor blackColor],NSForegroundColorAttributeName,
                                nil];
    NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont boldSystemFontOfSize:17.f],NSFontAttributeName,
                               kColor(255, 102, 36, 1),NSForegroundColorAttributeName,
                               nil];
    [attrString addAttributes:normalAttr range:NSMakeRange(0, 4)];
    [attrString addAttributes:priceAttr range:NSMakeRange(5, [attrString length] - 5)];
    _priceLabel.attributedText = attrString;
}


#pragma mark - Request

- (void)downloadGoodDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    
    
    [NetworkInterface getGoodDetailWithCityID:delegate.cityID agentID:delegate.agentID goodID:_goodID supplyType:self.supplyType finished:^(BOOL success, NSData *response) {
  
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseGoodDetailDateWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseGoodDetailDateWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *detailDict = [dict objectForKey:@"result"];
    _detailModel = [[GoodDetialModel alloc] initWithParseDictionary:detailDict];
    [self initAndLayoutUI];
    [_topScorllView downloadImageWithURLs:_detailModel.goodImageList target:self action:@selector(touchPicture:)];
    self.totalPage = [_detailModel.goodImageList count];
    self.imagesScrollView.contentSize = CGSizeMake(self.totalPage * self.view.bounds.size.width, self.view.bounds.size.height);
}
//解析支付通道
- (void)parseChannelDetailWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *channelDict = [dict objectForKey:@"result"];
    ChannelModel *newChannel = [[ChannelModel alloc] initWithParseDictionary:channelDict];
    newChannel.isAlreadyLoad = YES;
    NSInteger oldIndex = -1;
    for (ChannelModel *model in _detailModel.channelItem) {
        oldIndex++;
        if ([model.channelID isEqualToString:newChannel.channelID]) {
            break;
        }
    }
    [_detailModel.channelItem replaceObjectAtIndex:oldIndex withObject:newChannel];
    [self changeDefaultChannelWithChannel:newChannel];
}

//更换新的支付通道信息
- (void)changeDefaultChannelWithChannel:(ChannelModel *)newChannel {
    _detailModel.defaultChannel = newChannel;
    for (UIView *viewff in _mainScrollView.subviews) {
        if (![viewff isEqual:_topScorllView]) {
            [viewff removeFromSuperview];
        }
    }
    [self initSubViews];
}

#pragma mark - Action

- (IBAction)selectedChannel:(id)sender {
    GoodButton *btn = (GoodButton *)sender;
    btn.selected = YES;
    if ([_detailModel.defaultChannel.channelID isEqualToString:btn.ID]) {
        NSLog(@"!");
    }
    else {
        NSLog(@"~~~");
        ChannelModel *newModel = nil;
        for (ChannelModel *model in _detailModel.channelItem) {
            if ([model.channelID isEqualToString:btn.ID]) {
                newModel = model;
                break;
            }
        }
        if (newModel.isAlreadyLoad) {
            [self changeDefaultChannelWithChannel:newModel];
        }
        else {
            [self getChannelDetailWithChannelID:btn.ID];
        }
    }
}
- (void)getChannelDetailWithChannelID:(NSString *)channelID {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"加载中...";
//    [NetworkInterface getChannelDetailWithChannleID:channelID finished:^(BOOL success, NSData *response) {
//        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:0.5f];
//        if (success) {
//            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
//            if ([object isKindOfClass:[NSDictionary class]]) {
//                NSString *errorCode = [object objectForKey:@"code"];
//                if ([errorCode intValue] == RequestFail) {
//                    //返回错误代码
//                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
//                }
//                else if ([errorCode intValue] == RequestSuccess) {
//                    [hud hide:YES];
//                    [self parseChannelDetailWithDictionary:object];
//                }
//            }
//            else {
//                //返回错误数据
//                hud.labelText = kServiceReturnWrong;
//            }
//        }
//        else {
//            hud.labelText = kNetworkFailed;
//        }
//    }];
}
- (IBAction)buyGood:(id)sender {
    NSLog(@"buy ");
    _buyButton.selected = YES;
    _rentButton.selected = NO;
   // _shopcartButton.hidden=NO;

    _shopcartButton.enabled = YES;
    [_buyGoodButton setTitle:@"代购" forState:UIControlStateNormal];
    if (_buyButton.isSelected) {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.goodPrice + _detailModel.defaultChannel.openCost]];
    }
    else {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.deposit + _detailModel.defaultChannel.openCost]];
    }

}

#pragma mark - LoginSuccess
-(void)LoginSuccess
{
    NSLog(@"登录成功！");
    _isLogin = YES;
}


- (IBAction)rentGood:(id)sender {
    NSLog(@"rent");
    _buyButton.selected = NO;
    _rentButton.selected = YES;
   //_shopcartButton.hidden=YES;
    
    _shopcartButton.enabled = NO;
    [_buyGoodButton setTitle:@"代租赁" forState:UIControlStateNormal];
    if (_buyButton.isSelected) {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.goodPrice + _detailModel.defaultChannel.openCost]];
    }
    else {
        [self setPriceWithString:[NSString stringWithFormat:@"%.2f",_detailModel.deposit + _detailModel.defaultChannel.openCost]];
    }
}



- (IBAction)scanComment:(id)sender {
    
}

- (IBAction)scanRate:(id)sender {
    
}

- (IBAction)scanOpenInfo:(id)sender {
    
}


//加入购物车
- (IBAction)addShoppingCart:(id)sender {
        if (!_detailModel.goodID) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"未获取到此商品信息";
            return;
        }
        [self addGoodIntoShoppingCart];
    }

- (void)addGoodIntoShoppingCart {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"加载中...";
//    AppDelegate *delegate = [AppDelegate shareAppDelegate];
//    [NetworkInterface addShoppingCartWithToken:delegate.token userID:delegate.userID goodID:_detailModel.goodID channelID:_detailModel.defaultChannel.channelID finished:^(BOOL success, NSData *response) {
//        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:0.5f];
//        if (success) {
//            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
//            if ([object isKindOfClass:[NSDictionary class]]) {
//                NSString *errorCode = [object objectForKey:@"code"];
//                if ([errorCode intValue] == RequestFail) {
//                    //返回错误代码
//                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
//                }
//                else if ([errorCode intValue] == RequestSuccess) {
//                    hud.labelText = @"添加到购物车成功";
//                }
//            }
//            else {
//                //返回错误数据
//                hud.labelText = kServiceReturnWrong;
//            }
//        }
//        else {
//            hud.labelText = kNetworkFailed;
//        }
//    }];
}



//立即购买
- (IBAction)buyNow:(id)sender {
    if (_isLogin) {
        if ([_buyGoodButton.titleLabel.text isEqualToString:@"立即批购"]) {
//            BuyOrderViewController *buyC = [[BuyOrderViewController alloc] init];
//            buyC.goodDetail = _detailModel;
//            buyC.hidesBottomBarWhenPushed =  YES ;
//            
//            [self.navigationController pushViewController:buyC animated:YES];
        }
        else {
//            RentOrderViewController *rentC = [[RentOrderViewController alloc] init];
//            rentC.goodDetail = _detailModel;
//            rentC.hidesBottomBarWhenPushed =  YES ;
//            
//            [self.navigationController pushViewController:rentC animated:YES];
            
        }
    }
}

@end
