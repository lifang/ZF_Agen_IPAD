//
//  GoodDetaildetailViewController.m
//  iPadff
//
//  Created by comdosoft on 15/3/18.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GoodDetaildetailViewController.h"

#import "RefreshView.h"
#import "NetworkInterface.h"
#import "CommentCell.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "CommentCell.h"
#import "AppDelegate.h"
#import "GoodDetialModel.h"
#import "GoodButton.h"
#import "UIImageView+WebCache.h"
#import "FormView.h"
#import "InterestView.h"
#import "GoodDetailViewController.h"
@interface GoodDetaildetailViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
@property (nonatomic, strong) GoodDetialModel *detailModel;
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollViewrent;
@property (nonatomic, strong) UIScrollView *scrollViewmaterial;

@property (nonatomic, assign) CGFloat viewHeightmatel;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//评论
@property (nonatomic, strong) NSMutableArray *reviewItem;
@end

@implementation GoodDetaildetailViewController
- (void)viewWillAppear:(BOOL)animated
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _reviewItem = [[NSMutableArray alloc] init];
    [self downloadGoodDetail];

    [self initAndLayoutUIpp];
    [self initAndLayoutUIfl];
    [self initAndLayoutUIrent];
    [self initAndLayoutUImaterial];

    [self firstLoadData];

    self.title=@"商品详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    
    
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
    
    // Do any additional setup after loading the view.
}
-(void)popself

{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (IBAction)goShoppingCart:(id)sender
{
//    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.tabBarViewController setSeletedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initAndLayoutUI {
    if(iOS7)
    {
        
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_HEIGHT, SCREEN_WIDTH)];
        
        
    }
    else
    {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        
    }
    
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_mainScrollView];
    [self  handleViewWithOriginYs:64];
    
    
    [self   handleViewWithOriginY:0];
    
    
    
    
}
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
}
- ( void)handleViewWithOriginYs:(CGFloat)originY1
{
    
    CGFloat   leftSpace = 40;  //左侧间距
    
    
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
    
    
    
    
    CGFloat rightSpace = 25.f; //右侧间距
    CGFloat labelHeight = 20.f; //label 高度
    CGFloat firstSpace = 5.f;
    CGFloat vSpace = 12.f;  //label 垂直间距
    CGFloat hSpace = 10.f;
    CGFloat leftLabelWidth = 60.f;  //左侧标题label宽度
    //    CGFloat btnHeight = 20.f;  //支付通道 和 购买方式 按钮高度
    //    CGFloat btnWidth = (kScreenWidth - leftSpace - rightSpace - leftLabelWidth - firstSpace - 2 * hSpace) / 3;
    CGFloat originY =10;
    
    //pos信息
    originY +=  10;
    UILabel *posTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, labelHeight)];
    
    [self setLabels:posTitleLabel withTitle:@"POS信息" font:[UIFont systemFontOfSize:14.f]];
    [_mainScrollView addSubview:posTitleLabel];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(40, originY,wide-80, 1)];
    secondLine.backgroundColor = kColor(3, 112, 214, 1);
    [_mainScrollView addSubview:secondLine];
    
    //品牌型号
    originY += vSpace + 1;
    NSString *brandModel = [NSString stringWithFormat:@"%@%@",_detailModel.goodBrand,_detailModel.goodModel];
    [self addLabelWithTitle:@"品   牌    型    号" content:brandModel offsetY:originY];
    
    //外壳
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"外   壳    类    型" content:_detailModel.goodMaterial offsetY:originY];
    //电池
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"电   池    信    息" content:_detailModel.goodBattery offsetY:originY];
    //签购单
    originY += vSpace +labelHeight;
    [self addLabelWithTitle:@"签购单打印方式" content:_detailModel.goodSignWay offsetY:originY];
    //加密卡
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"加  密  卡  方 式" content:_detailModel.goodEncryptWay offsetY:originY];
    
    //支付通道信息
    originY += labelHeight + 10;
    UILabel *cTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, labelHeight)];
    [self setLabels:cTitleLabel withTitle:@"支 付 通 道 信息" font:[UIFont systemFontOfSize:16.f]];
    [_mainScrollView addSubview:cTitleLabel];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(40, originY, wide-80, 1)];
    thirdLine.backgroundColor = kColor(3, 112, 214, 1);
    [_mainScrollView addSubview:thirdLine];
    
    //支持区域
    originY += vSpace + 1;
    NSString *area = [_detailModel.defaultChannel.supportAreaItem componentsJoinedByString:@" "];
    [self addLabelWithTitle:@"支持支付区域" content:area offsetY:originY];
    //注销
    originY += vSpace +labelHeight;
    NSString *cancelString = nil;
    if (_detailModel.defaultChannel.canCanceled) {
        cancelString = @"支持";
    }
    else {
        cancelString = @"不支持";
    }
    [self addLabelWithTitle:@"是否支持注销" content:cancelString offsetY:originY];
    
    //标准手续费
    originY += labelHeight + 20;
    CGFloat standFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.standRateItem count]
                                                  hasTitle:YES];
    FormView *standForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, wide, standFormHeight)];
    [standForm setGoodDetailDataWithFormTitle:@"刷卡交易标准手续费"
                                      content:_detailModel.defaultChannel.standRateItem
                                   titleArray:[NSArray arrayWithObjects:@"商户类",@"费率",@"说明",nil]];
    [_mainScrollView addSubview:standForm];
    
    //资金服务费
    originY += standFormHeight + 10;
    CGFloat dateFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.dateRateItem count]
                                                 hasTitle:YES];
    FormView *dateForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, wide, dateFormHeight)];
    [dateForm setGoodDetailDataWithFormTitle:@"资金服务费"
                                     content:_detailModel.defaultChannel.dateRateItem
                                  titleArray:[NSArray arrayWithObjects:@"结算周",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:dateForm];
    
    //其它交易费率
    originY += dateFormHeight + 10;
    CGFloat otherFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.otherRateItem count]
                                                  hasTitle:YES];
    FormView *otherForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, wide-0, otherFormHeight)];
    [otherForm setGoodDetailDataWithFormTitle:@"其它交易费率"
                                      content:_detailModel.defaultChannel.otherRateItem
                                   titleArray:[NSArray arrayWithObjects:@"交易类",@"费率",@"说明", nil]];
    [_mainScrollView addSubview:otherForm];
    
    //申请开通条件
    originY += otherFormHeight + 10;
    UILabel *openTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, labelHeight)];
    [self setLabels:openTitleLabel withTitle:@"申请开通条件" font:[UIFont systemFontOfSize:16.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(40, originY, wide - 80, 1)];
    forthLine.backgroundColor =kColor(3, 112, 214, 1);
    [_mainScrollView addSubview:forthLine];
    
    //申请开通条件内容
    originY += vSpace + 1;
    CGFloat openHeight = [self heightWithString:_detailModel.defaultChannel.openRequirement
                                          width:wide - leftSpace - rightSpace
                                       fontSize:16.f];
    openHeight = openHeight < labelHeight ? labelHeight : openHeight;
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, openHeight)];
    openLabel.numberOfLines = 0;
    [self setLabels:openLabel withTitle:_detailModel.defaultChannel.openRequirement font:[UIFont systemFontOfSize:16.f]];
    
    //商品详细说明
    originY += openHeight + 20;
    UILabel *descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, labelHeight)];
    [self setLabels:descriptionTitleLabel withTitle:@"商品详细说明" font:[UIFont systemFontOfSize:16.f]];
    
    //划线
    originY += labelHeight + vSpace;
    UIView *fifthLine = [[UIView alloc] initWithFrame:CGRectMake(40, originY, wide - 80, 1)];
    fifthLine.backgroundColor =kColor(3, 112, 214, 1);
    [_mainScrollView addSubview:fifthLine];
    
    //说明
    originY += vSpace + 1;
    CGFloat descriptionHeight = [self heightWithString:_detailModel.goodDescription
                                                 width:wide - leftSpace - rightSpace
                                              fontSize:16.f];
    descriptionHeight = descriptionHeight < labelHeight ? labelHeight : descriptionHeight;
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, wide - leftSpace - rightSpace, descriptionHeight)];
    descriptionLabel.numberOfLines = 0;
    [self setLabels:descriptionLabel withTitle:_detailModel.goodDescription font:[UIFont systemFontOfSize:13.f]];
    
    //感兴趣的
    originY += descriptionHeight + 20;
    UIView *sixthLine = [[UIView alloc] initWithFrame:CGRectMake(40, originY, wide-80, 1)];
    sixthLine.backgroundColor = kColor(200, 198, 199, 1);
    [_mainScrollView addSubview:sixthLine];
    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectMake((wide - 80) / 2, originY - 10, 80, labelHeight)];
    [self setLabels:interestLabel withTitle:@"您感兴趣的" font:[UIFont systemFontOfSize:14.f]];
    interestLabel.textAlignment = NSTextAlignmentCenter;
    interestLabel.backgroundColor = kColor(244, 243, 243, 1);
    
    originY += 20;
    CGFloat middleSpace = 20.f;
    CGFloat relateViewWidth = (wide -100) / 4;
    CGFloat relateViewHeight = relateViewWidth + 40 + 20 + 10;
    CGRect rect = CGRectMake(leftSpace, originY, relateViewWidth, relateViewHeight);
    for (int i = 0; i < [_detailModel.relativeItem count]; i++) {
        if (i % 4 == 0 && i != 0) {
            rect.origin.x = leftSpace;
            rect.origin.y += relateViewHeight + middleSpace;
        }
        InterestView *interestView = [[InterestView alloc] initWithFrame:rect];
        RelativeGood *relativeGood = [_detailModel.relativeItem objectAtIndex:i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedRelativeGood:)];
        [interestView setRelationData:relativeGood];
        [_mainScrollView addSubview:interestView];
        [interestView addGestureRecognizer:tap];
        interestView.userInteractionEnabled=YES;
        
        rect.origin.x += relateViewWidth + middleSpace;
    }
    
    int relateRow = (int)([_detailModel.relativeItem count] - 1) / 4 + 1;
    originY += relateRow * (relateViewHeight + middleSpace);
    
    _mainScrollView.userInteractionEnabled=YES;
    
    _mainScrollView.contentSize = CGSizeMake(wide, originY+130);
    //    [self setSeletedIndex:self.secletA];
}
- (IBAction)selectedRelativeGood:(UITapGestureRecognizer *)sender {
    InterestView *viewkk = (InterestView *)[sender view];
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    detailC.goodID = viewkk.relativeGood.relativeID;
    detailC.hidesBottomBarWhenPushed =  YES ;
    
    [self.navigationController pushViewController:detailC animated:YES];
}
#pragma mark - 评论
#pragma mark - UI

- (void)setHeaderAndFooterView {
    
}

- (void)initAndLayoutUIpp {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
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

    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, wide, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, wide, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getCommentListWithToken:delegate.token goodID:_goodID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_reviewItem removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseCommentDataWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

#pragma mark - Data

- (void)parseCommentDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *commentList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [commentList count]; i++) {
        NSDictionary *dict = [commentList objectAtIndex:i];
        CommentModel *model = [[CommentModel alloc] initWithParseDictionary:dict];
        [_reviewItem addObject:model];
    }
    [_tableView reloadData];
}

- (CGFloat)heightForComment:(NSString *)content {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                          nil];
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

    CGRect rect = [content boundingRectWithSize:CGSizeMake(wide - 40, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 > 20.f ? rect.size.height + 1 : 20.f;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_reviewItem count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *commentIdentifier = @"commentIdentifier";
    CommentModel *model = [_reviewItem objectAtIndex:indexPath.section];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithContent:model.content reuseIdentifier:commentIdentifier];
    }
    [cell setCommentData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = [_reviewItem objectAtIndex:indexPath.section];
    CGFloat commentHeight = [self heightForComment:model.content];
    return commentHeight + kNormalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}
#pragma mark - 租赁说明


- (void)initAndLayoutUIrent{
    _scrollViewrent = [[UIScrollView alloc] init];
    _scrollViewrent.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollViewrent.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollViewrent];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewrent
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewrent
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewrent
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewrent
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initSubViewrent];
}

- (void)initSubViewrent {
    UIView *topView = nil;
    NSString *minDate = [NSString stringWithFormat:@"%@个月",_goodDetail.minTime];
    NSString *maxDate = [NSString stringWithFormat:@"%@个月",_goodDetail.maxTime];
    topView = [self addRowsWithTitle:@"最短租赁时间" content:minDate topView:topView];
    topView = [self addRowsWithTitle:@"最长租赁时间" content:maxDate topView:topView];
    topView = [self addRowsWithTitle:@"每月租金" content:[NSString stringWithFormat:@"￥%.2f",_goodDetail.leasePrice] topView:topView];
    topView = [self addRowsWithTitle:@"说明" content:_goodDetail.leaseDescription topView:topView];
    topView = [self addRowsWithTitle:@"租赁协议" content:_goodDetail.leaseProtocol topView:topView];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _viewHeight);
}

- (UIView *)addRowsWithTitle:(NSString *)title
                     content:(NSString *)content
                     topView:(UIView *)topView {
    CGFloat topSpace = 44.f;
    CGFloat leftSpace = 40.f;
    CGFloat titleLabelHeight = 30.f;
    CGFloat middleSpace = 5.f;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = title;
    [_scrollViewrent addSubview:titleLabel];
    if (!topView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollViewrent
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor =kColor(3, 112, 214, 1);
    [_scrollViewrent addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:kLineHeight]];
    //内容
    UIFont *font = [UIFont systemFontOfSize:16.f];
    CGFloat contentHeight = [self heightForContent:content
                                          withFont:font
                                             width:kScreenWidth - 2 * leftSpace];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = font;
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    [_scrollViewrent addSubview:contentLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:contentHeight]];
    _viewHeight += topSpace + titleLabelHeight + middleSpace * 2 + kLineHeight + contentHeight;
    return contentLabel;
}

#pragma mark - Data

- (CGFloat)heightForContent:(NSString *)content
                   withFont:(UIFont *)font
                      width:(CGFloat)width {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          font,NSFontAttributeName,
                          nil];
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil];
    return rect.size.height + 1 > 20.f ? rect.size.height + 1 : 20.f;
}

#pragma mark - 申请开通所需材料


#pragma mark - UI

- (void)initAndLayoutUImaterial {
    _scrollViewmaterial = [[UIScrollView alloc] init];
    _scrollViewmaterial.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollViewmaterial.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollViewmaterial];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewmaterial
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewmaterial
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewmaterial
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollViewmaterial
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initSubViewmaterial];
}

- (void)initSubViewmaterial {
    UIView *topView = nil;
    topView = [self addRowsWithTitlematel:@"对个人开通" content:_channelData.privateInfo topView:topView];
    topView = [self addRowsWithTitlematel:@"对公开通" content:_channelData.publicInfo topView:topView];
    
    _scrollViewmaterial.contentSize = CGSizeMake(kScreenWidth, _viewHeightmatel);
}

- (UIView *)addRowsWithTitlematel:(NSString *)title
                     content:(NSString *)content
                     topView:(UIView *)topView {
    CGFloat topSpace = 30.f;
    CGFloat leftSpace = 40.f;
    CGFloat titleLabelHeight = 30.f;
    CGFloat middleSpace = 10.f;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.text = title;
    [_scrollViewmaterial addSubview:titleLabel];
    if (!topView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_scrollViewmaterial
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    else {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:topSpace]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor =kColor(3, 112, 214, 1);
    [_scrollViewmaterial addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:kLineHeight]];
    //内容
    UIFont *font = [UIFont systemFontOfSize:16.f];
    CGFloat contentHeight = [self heightForContent:content
                                          withFont:font
                                             width:kScreenWidth - 2 * leftSpace];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = font;
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    [_scrollViewmaterial addSubview:contentLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:middleSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:contentHeight]];
    _viewHeightmatel += topSpace + titleLabelHeight + middleSpace * 2 + kLineHeight + contentHeight;
    return contentLabel;
}

#pragma mark - Data









#pragma mark - 交易费率
- (void)initAndLayoutUIfl {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:64]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initSubView];
    
}

- (void)initSubView {
    CGFloat titleHeight = 36.f;
    CGFloat contentHeight = 50.f;
    
    UILabel *dateTitleLabel = [[UILabel alloc] init];
    dateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateTitleLabel.backgroundColor = [UIColor clearColor];
    dateTitleLabel.font = [UIFont systemFontOfSize:15.f];
    dateTitleLabel.textAlignment = NSTextAlignmentCenter;
    dateTitleLabel.text = @"结算时间";
    [_scrollView addSubview:dateTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleHeight]];
    UILabel *rateTitleLabel = [[UILabel alloc] init];
    rateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rateTitleLabel.backgroundColor = [UIColor clearColor];
    rateTitleLabel.font = [UIFont systemFontOfSize:15.f];
    rateTitleLabel.textAlignment = NSTextAlignmentCenter;
    rateTitleLabel.text = @"资金服务费（/天）";
    [_scrollView addSubview:rateTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleHeight]];
    UIView *topView = nil;
    topView = [self addLineWithTopView:dateTitleLabel];
    for (GoodRateModel *model in _tradeRateItem) {
        topView = [self addRowsWithDate:model.rateName
                                   rate:model.ratePercent
                                topView:topView
                                 height:contentHeight];
    }
    CGFloat totalHeight = titleHeight + [_tradeRateItem count] * (contentHeight + kLineHeight) + kLineHeight;
    //竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.translatesAutoresizingMaskIntoConstraints = NO;
    vLine.backgroundColor = kColor(204, 202, 203, 1);
    [_scrollView addSubview:vLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:totalHeight]];
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

    UIView *xLine = [[UIView alloc] initWithFrame:CGRectMake(80, 80, wide-160, 1)];
    
    
    xLine.backgroundColor = kColor(204, 202, 203, 1);

   [_scrollView addSubview:xLine];
    UIView *yLine = [[UIView alloc] initWithFrame:CGRectMake(80, 80,1, totalHeight)];
    
    
    yLine.backgroundColor = kColor(204, 202, 203, 1);
    
    [_scrollView addSubview:yLine];
    
    UIView *yLine2 = [[UIView alloc] initWithFrame:CGRectMake(wide-80, 80,1, totalHeight)];
    
    
    yLine2.backgroundColor = kColor(204, 202, 203, 1);
    
    [_scrollView addSubview:yLine2];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, totalHeight);
}

- (UIView *)addRowsWithDate:(NSString *)date
                       rate:(CGFloat)rate
                    topView:(UIView *)topView
                     height:(CGFloat)height {
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:15.f];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = date;
    [_scrollView addSubview:dateLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dateLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:height]];
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rateLabel.backgroundColor = [UIColor clearColor];
    rateLabel.font = [UIFont systemFontOfSize:15.f];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    rateLabel.text = [NSString stringWithFormat:@"%.3f%%",rate];
    [_scrollView addSubview:rateLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:.5
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:rateLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:height]];
    UIView *rowLine = [self addLineWithTopView:dateLabel];
    return rowLine;
}

- (UIView *)addLineWithTopView:(UIView *)topView {
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = kColor(204, 202, 203, 1);
    [_scrollView addSubview:line];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:kLineHeight]];
    return line;
}

#pragma mark - 计算

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

- (void)addLabelWithTitle:(NSString *)title
                  content:(NSString *)content
                  offsetY:(CGFloat)offsetY {
    CGFloat leftSpace = 40.f;
    CGFloat titleLabelWidth = 120.f;
    CGFloat labelHeight = 30.f;
    CGFloat middleLeftSpace = leftSpace + titleLabelWidth + 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, offsetY, titleLabelWidth, labelHeight)];
    [self setLabels:titleLabel withTitle:title font:[UIFont systemFontOfSize:16.f]];
    titleLabel.textColor=[UIColor blackColor];
    
    [_mainScrollView addSubview:titleLabel];
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

    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftSpace, offsetY, wide - middleLeftSpace, labelHeight)];    contentLabel.textColor=[UIColor grayColor];

    [self setLabels:contentLabel withTitle:content font:[UIFont systemFontOfSize:16.f]];
    
}
- (void)setLabels:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
//    label.textColor=[UIColor grayColor];
    
    [_mainScrollView addSubview:label];
}
- ( void)handleViewWithOriginY:(CGFloat)originY {
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

    UIView *viewgf = [[UIView alloc] init];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 65, wide, 1)];

    if(iOS7)
    {
        viewgf.frame=CGRectMake(0, originY, SCREEN_HEIGHT , 65 );
        
    }else
    {
        viewgf.frame=CGRectMake(0, originY, SCREEN_WIDTH , 65 );
        
        
        
    }
    [self.view addSubview:lineview];
    lineview.backgroundColor = [UIColor grayColor];

    [self.view addSubview:viewgf];
    
    viewgf.backgroundColor = [UIColor whiteColor];
    
    
    
    if (self.supplyType==2)
    {
    if (_detailModel.canRent)
    {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"租赁说明",@"交易费率", nil];
        
        
        for (int i = 0; i < 5; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            rentButton.tag=i+1024;
            
            rentButton.frame = CGRectMake(viewgf.frame.size.width / 11*(2*i +1)-10, 15, viewgf.frame.size.width / 11+10, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewgf addSubview:rentButton];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewgf.frame.size.width / 5*(i+1), 20, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [viewgf addSubview:line];
        }
        
    }
        else
        {
        
        
            NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
            
            NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"交易费率", nil];
            
            
            for (int i = 0; i < 4; i++ ) {
                
                UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
                rentButton.frame = CGRectMake(viewgf.frame.size.width / 9*(2*i +1), 15, viewgf.frame.size.width / 9, 45);
                [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
                rentButton.titleLabel.font = [UIFont systemFontOfSize: 17.0];
                [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
                [viewgf addSubview:rentButton];
                if(i==3)
                {
                    rentButton.tag=1028;

                }
                else{
                
                    rentButton.tag=i+1024;

                }
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewgf.frame.size.width / 4*(i+1), 20, 1, 30)];
                line.backgroundColor = [UIColor grayColor];
                [viewgf addSubview:line];
            }

        
        }
    }
    else
    {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"交易费率", nil];
        
        
        for (int i = 0; i < 4; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rentButton.frame = CGRectMake(viewgf.frame.size.width / 9*(2*i +1), 15, viewgf.frame.size.width / 9, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 17.0];
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewgf addSubview:rentButton];
            if(i==3)
            {
                rentButton.tag=1028;
                
            }
            else{
                
                rentButton.tag=i+1024;
                
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewgf.frame.size.width / 4*(i+1), 20, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [viewgf addSubview:line];
        }
        
        
        
    }
    [self setSeletedIndex:self.secletA];

    //竖线
    //    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 0.5f, 25)];
    //    firstLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:firstLine];
    //    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 55, 0.5f, 25)];
    //    secondLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:secondLine];
}
-(void)scanRent:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    [self setSeletedIndex:sender.tag];
    
    
}
- (void)setSeletedIndex:(int)aIndex
{
    NSLog(@"%d",aIndex);
    if(aIndex==1024)
    {
        _mainScrollView.hidden=NO;
        _tableView.hidden=YES;
        _scrollViewrent.hidden=YES;
        _scrollViewmaterial.hidden=YES;

        _scrollView.hidden=YES;

        
    }
    else if(aIndex==1025)
        
    {        _scrollView.hidden=YES;
        
        _scrollViewrent.hidden=YES;
        _scrollViewmaterial.hidden=NO;
        
        _tableView.hidden=YES;
        
        _mainScrollView.hidden=YES;
        
    }

    else if(aIndex==1028)

    {        _scrollView.hidden=NO;

        _scrollViewrent.hidden=YES;
        _scrollViewmaterial.hidden=YES;

        _tableView.hidden=YES;

        _mainScrollView.hidden=YES;
  
    }
    else if(aIndex==1026)
        
    {        _scrollView.hidden=YES;
        _scrollViewrent.hidden=YES;

        _scrollViewmaterial.hidden=YES;

        _tableView.hidden=NO;
        
        _mainScrollView.hidden=YES;
        
    }
    else if(aIndex==1027)
        
    {
        _scrollView.hidden=YES;
        _scrollViewrent.hidden=NO;
        
        _scrollViewmaterial.hidden=YES;

        _tableView.hidden=YES;
        
        _mainScrollView.hidden=YES;
        
    }

    UIButton *previousButton = (UIButton *)[self.view viewWithTag:self.secletA];
    [previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.secletA = aIndex;
    
    //设置为正常状态下的图片
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:(aIndex )];
    [currentButton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
}
/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
