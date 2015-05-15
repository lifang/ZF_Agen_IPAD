//
//  GoodListViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodListViewController.h"
#import "SearchViewController.h"
#import "FilterViewController.h"
#import "NavigationBarAttr.h"
#import "ZFSearchBar.h"
#import "GoodsCell.h"
#import "SortView.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "GoodListModel.h"
#import "AppDelegate.h"
#import "TreeDataHandle.h"
#import "GoodDetailViewController.h"
#import "GoodsCellCollectionViewCell.h"
#import "MJRefresh.h"

#import "GoodsCollectionViewCell2.h"

@interface GoodListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,SortViewDelegate,SearchDelegate>

@property (nonatomic, strong) ZFSearchBar *searchBar;

@property (nonatomic, strong) UICollectionView *tableView;

@property (nonatomic, strong) SortView *sortView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@property (nonatomic, assign) int page;

/*搜索字段*/

@property (nonatomic, assign) OrderFilter filterType;  //排序类型
///保存用户选择的筛选条件
@property (nonatomic, strong) NSMutableDictionary *filterDict;
@property (nonatomic, strong) NSString *keyword;      //关键字

@end

@implementation GoodListViewController


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];
    UIButton *shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(0, 0, 30, 30);
    [shoppingButton setBackgroundImage:[UIImage imageNamed:@"good_right1@2x"] forState:UIControlStateNormal];
    
    //    [shoppingButton setBackgroundImage:kImageName(@"good_right1.png") forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(goShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 30, 30);
    [filterButton setBackgroundImage:kImageName(@"good_right2@2x.png") forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterGoods:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%f",self.view.frame.size.width);
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    UIBarButtonItem *rightItems = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:nil];

    spaceItem.width = 52;
//    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:shoppingButton];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,spaceItem,filterItem,spaceItem,nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,spaceItem, rightItems,nil];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listRefresh) name:@"listRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listRefreshs) name:@"listRefreshs" object:nil];
//现在全部为代购
    self.supplyType=SupplyGoodsProcurement;


  filterC = [[FilterViewController alloc] init];
    changA=8;
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    _filterDict = [[NSMutableDictionary alloc] init];
    [self setOriginalQuery];
    [self firstLoadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGoodList)
                                                 name:UpdateGoodListNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)getSearchKeyword:(NSString *)keyword {
    _keyword = keyword;
    _searchBar.text = _keyword;
    [self firstLoadData];
}

- (void)initAndLayoutUI {
    //导航栏
    [self initNavigationBarView];
    
    [self initContentView];
}

- (void)initNavigationBarView {
    
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

    
    _searchBar = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, wide, 30)];
    _searchBar.delegate = self;
    
    self.navigationItem.titleView = _searchBar;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
  
}

- (void)setHeaderAndFooterView {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
//    _tableView.tableFooterView = footerView;
}

- (void)initContentView {
    NSArray *nameArray = [NSArray arrayWithObjects:
                      @"默认排序",
                      @"销量优先",
                      @"价格降序",
                      @"评分最高",
                      nil];
    
    
    _sortView = [[SortView alloc] initWithFrame:CGRectMake(0, 0, 360, 60)];
    _sortView.delegate = self;
    
    if(iOS7)
    {
        _sortView.center=CGPointMake(SCREEN_HEIGHT/2,30);

    }else
    {
    
        _sortView.center=CGPointMake(SCREEN_WIDTH/2,30);

    
        
        
    }
    
    [_sortView setItems:nameArray];
    
    [self.view addSubview:_sortView];
    
    button1=[UIButton buttonWithType:UIButtonTypeCustom];
    
//    隐藏批购代购
//    wholesalebutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    behalfbutton=[UIButton buttonWithType:UIButtonTypeCustom];
//    wholesalebutton.frame=CGRectMake(60,10,  40, 40);
//    behalfbutton.frame=CGRectMake(120,10,  40, 40);
//    [behalfbutton setTitle:@"代购" forState:UIControlStateNormal];
//    [wholesalebutton setTitle:@"批购" forState:UIControlStateNormal];
//    [wholesalebutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
//    [behalfbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    wholesalebutton.tag=506;
//    behalfbutton.tag=507;
//
//    UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(110, 20, 1, 20)];
//    linview.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:linview];
//    [behalfbutton addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
//    [wholesalebutton addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
//
//    
//    [self.view addSubview:behalfbutton];
//    [self.view addSubview:wholesalebutton];

    
    if (iOS7) {
        
        button1.frame=CGRectMake(SCREEN_HEIGHT-210,10,  40, 40);
      

        
    }
    else
    {
        
        button1.frame=CGRectMake(SCREEN_WIDTH-210,10,  40, 40);
        
    }
    
    
    
    [self.view addSubview:button1];
    [button1 setImage:[UIImage imageNamed:@"9kind_height"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(change9) forControlEvents:UIControlEventTouchUpInside];
    
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    if (iOS7) {
        
        button2.frame=CGRectMake(SCREEN_HEIGHT-130,10,  40, 40);
        
    }
    else
    {
        
        button2.frame=CGRectMake(SCREEN_WIDTH-130,10,  40, 40);
        
    }
    
    
    
    [self.view addSubview:button2];
    [button2 setImage:[UIImage imageNamed:@"8kind_normal"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(change8) forControlEvents:UIControlEventTouchUpInside];
    

    
    flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
//   flowLayout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);//设置其边
    
    
    
    
    
    
    _tableView  = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_tableView registerClass:[GoodsCellCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    
    [_tableView registerClass:[GoodsCollectionViewCell2 class] forCellWithReuseIdentifier:@"myCells"];

    [flowLayout setItemSize:CGSizeMake(220, 320)];//设置cell的尺寸

    
    
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:_sortView
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//    
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
    if(changA==8)
    {
        if(iOS7)
        {
            _tableView.frame=CGRectMake(0, 60, SCREEN_HEIGHT-60-20, SCREEN_WIDTH-130);
            

        }
        else
        {
        
            _tableView.frame=CGRectMake(0, 60,  SCREEN_WIDTH-60-20, SCREEN_HEIGHT-130);
            

        
        }
        
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                              attribute:NSLayoutAttributeRight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeRight
//                                                             multiplier:1.0
//                                                               constant:-20]];
    }else
    {
        
        
        if(iOS7)
        {
            _tableView.frame=CGRectMake(0, 60, SCREEN_HEIGHT-60, SCREEN_WIDTH-130);
            
            
        }
        else
        {
            
            _tableView.frame=CGRectMake(0, 60,  SCREEN_WIDTH-60, SCREEN_HEIGHT-130);
            
            
            
        }
        

//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                              attribute:NSLayoutAttributeRight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeRight
//                                                             multiplier:1.0
//                                                               constant:0]];
    
    }
   
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//    
    
    
//    if(iOS7)
//    {
//        _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.height, 80)];
//        _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, 60)];
//
//    }else
//    {
//        
//        _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
//        
//        _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
//
//        
//        
//    }
    [_tableView addHeaderWithTarget:self action:@selector(loadNewStatuses:) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    //上拉
    [_tableView addFooterWithTarget:self action:@selector(loadMoreStatuses)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @">.< 正在努力加载中!";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @">.< 正在努力加载中!";
    
}
-(void)change8
{
   

    changA=9;

    [button1 setImage:[UIImage imageNamed:@"9kind_normal"] forState:UIControlStateNormal];

    [button2 setImage:[UIImage imageNamed:@"8kind_height"] forState:UIControlStateNormal];
    
    if(iOS7)
        
    {
    
        [flowLayout setItemSize:CGSizeMake(SCREEN_HEIGHT, 150)];//设置cell的尺寸

    }
    else
        
    {
    
        [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH, 150)];//设置cell的尺寸

    }

    [_tableView reloadData];
    
}
-(void)change9
{
    changA=8;
    
    [flowLayout setItemSize:CGSizeMake(220, 320)];//设置cell的尺寸

    [button2 setImage:[UIImage imageNamed:@"8kind_normal"] forState:UIControlStateNormal];

    [button1 setImage:[UIImage imageNamed:@"9kind_height"] forState:UIControlStateNormal];
    [_tableView reloadData];

}
//下拉刷新加载更多微博数据
-(void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
    
    [self firstLoadData];


//上拉加载


    
    
    //    });
}

//上拉刷新加载更多微博数据
-(void)loadMoreStatuses
{
    self.page++;

    [self downloadDataWithPage:self.page isMore:YES];

    
  
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_Seatchtable footerEndRefreshing];
    //
    //    });
}

#pragma mark - Data

//搜索条件初始化
- (void)setOriginalQuery {
    _filterType = OrderFilterDefault;
    _keyword = nil;
    TreeNodeModel *original = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                  children:nil
                                                                    nodeID:kNoneFilterID];
    NSMutableArray *item = [[NSMutableArray alloc] initWithObjects:original, nil];
    //所有条件可多选，value为数组
    [_filterDict setObject:item forKey:s_brands];
    [_filterDict setObject:item forKey:s_category];
    [_filterDict setObject:item forKey:s_channel];
    [_filterDict setObject:item forKey:s_card];
    [_filterDict setObject:item forKey:s_trade];
    [_filterDict setObject:item forKey:s_slip];
    [_filterDict setObject:item forKey:s_date];
    //值
    [_filterDict setObject:[NSNumber numberWithBool:NO] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:0] forKey:s_minPrice];
}

//根据字典中选中条件获取请求需要的数组
- (NSArray *)filterForKey:(NSString *)key {
    NSArray *filterItem = [_filterDict objectForKey:key];
    
    
    for (TreeNodeModel *node in filterItem) {
        
        //若筛选条件包含全部，数组返回nil
        if ([[NSString stringWithFormat:@"%@",node.nodeID] isEqualToString:kNoneFilterID])
        
        {
            return nil;
        }
    }
    NSMutableArray *IDItem = [[NSMutableArray alloc] init];
    for (TreeNodeModel *node in filterItem) {
        [IDItem addObject:[NSNumber numberWithInt:[node.nodeID intValue]]];
    }
    return IDItem;
}
-(void)listRefreshs

{

    [wholesalebutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
            [behalfbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
            self.supplyType=SupplyGoodsProcurement;

    [self firstLoadData];


}
-(void)listRefresh
{
    

        self.supplyType=SupplyGoodsProcurement;
        
        [behalfbutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        [wholesalebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self firstLoadData];

}
- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    //****************筛选条件***************
    NSArray *brandItem = [self filterForKey:s_brands];
    NSArray *catrgoryItem = [self filterForKey:s_category];
    NSArray *channelItem = [self filterForKey:s_channel];
    NSArray *cardItem = [self filterForKey:s_card];
    NSArray *tradeItem = [self filterForKey:s_trade];
    NSArray *slipItem = [self filterForKey:s_slip];
    NSArray *dateItem = [self filterForKey:s_date];
    BOOL isRent = [[_filterDict objectForKey:s_rent] boolValue];
    CGFloat maxPrice = [[_filterDict objectForKey:s_maxPrice] floatValue];
    CGFloat minPrice = [[_filterDict objectForKey:s_minPrice] floatValue];
    
    
    NSLog(@"%@",delegate.agentID);


    //***************************************
   [NetworkInterface getGoodListWithCityID:delegate.cityID agentID:delegate.agentID supplyType:_supplyType sortType:_filterType brandID:brandItem category:catrgoryItem channelID:channelItem payCardID:cardItem tradeID:tradeItem slipID:slipItem date:dateItem maxPrice:maxPrice minPrice:minPrice keyword:_keyword onlyRent:isRent page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
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
                        [_dataItem removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseDataWithDictionary:object];
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
//        if (!isMore) {
//            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
//        }
//        else {
//            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
//        }
    }];
}

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *goodList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [goodList count]; i++) {
        GoodListModel *good = [[GoodListModel alloc] initWithParseDictionary:[goodList objectAtIndex:i]];
        [_dataItem addObject:good];
    }
    [_tableView reloadData];
}

#pragma mark - Action
- (IBAction)selectStatus:(id)sender {
    UIButton*but=(UIButton*)sender;
    if(but.tag==506)
    {
        
        
        [wholesalebutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        [behalfbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        self.supplyType=SupplyGoodsWholesale;
        
        
        
    }
    else
    {
        self.supplyType=SupplyGoodsProcurement;

        [behalfbutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
        [wholesalebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
//    self.currentType = but.tag;
    [self firstLoadData];
}

- (IBAction)goShoppingCart:(id)sender {
//    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.tabBarViewController setSeletedIndex:1];
}


- (IBAction)filterGoods:(id)sender {
    
    filterC.filterDict = _filterDict;
    filterC.hidesBottomBarWhenPushed =  YES ;

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterC];
//    [NavigationBarAttr setNavigationBarStyle:nav];
    [self.navigationController pushViewController:filterC animated:YES];
    
//    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Notification

- (void)updateGoodList {
    [self firstLoadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    return [_dataItem count];
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath


{
    if(changA==8)
    {
    
        GoodsCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCells" forIndexPath:indexPath];
        GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
        
        
        [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:good.goodImagePath]
                            placeholderImage:kImageName(@"test1.png")];
        cell.titleLabel.text = good.goodName;

        if(_supplyType==SupplyGoodsWholesale)
        {
            cell.salesVolumeLabel.text = [NSString stringWithFormat:@"已售%d",good.goodSaleNumbers];
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",good.goodWholesalePrice];

        }else
        {
        
            cell.salesVolumeLabel.text = [NSString stringWithFormat:@"已售%d",good.goodSaleNumber];

            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",good.goodPrimaryPrice];

        }
        cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号   %@%@",good.goodBrand,good.goodModel];
        cell.channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",good.goodChannel];
        if (good.isRent)
            
        {
            cell.attrView.hidden = NO;
        }
        else {
            cell.attrView.hidden = YES;
        }
        
        return cell;

    
    }
    else
        
    {
        GoodsCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
        if(indexPath.row==0)
        {
            
            cell.bigimages.hidden=NO;

            cell.bigtitleLabel.hidden=NO;
            cell.pricelable.hidden=NO;
            cell.salemorelable.hidden=NO;

            NSLog(@"%f",cell.bigtitleLabel.frame.size.width);
            

        }
        else
        {
        
            cell.bigtitleLabel.hidden=YES;
            cell.bigimages.hidden=YES;
            cell.pricelable.hidden=YES;
            cell.salemorelable.hidden=YES;
        }
        
        [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:good.goodImagePath]
                            placeholderImage:kImageName(@"test1.png")];
        cell.titleLabel.text = good.goodName;
        
        
        
       
        
        cell.lastnumber.text = [NSString stringWithFormat:@"最小起批量%d件",good.minWholesaleNumber];
        cell.newpriceLabel.text = [NSString stringWithFormat:@"￥%.2f",good.goodPrimaryPrice];
      
        
        cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号   %@%@",good.goodBrand,good.goodModel];
        cell.channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",good.goodChannel];
        
        if(_supplyType==SupplyGoodsProcurement)
        {
            cell.salesVolumeLabel.text = [NSString stringWithFormat:@"%d",good.goodSaleNumber];

            if (good.isRent)
                
            {
                cell.attrView.hidden = NO;
            }
            else {
                cell.attrView.hidden = YES;
            }

        
        }else
        {
            cell.salesVolumeLabel.text = [NSString stringWithFormat:@"%d",good.goodSaleNumbers];

            cell.attrView.hidden = YES;

            NSString *primaryPrice = [NSString stringWithFormat:@"原价 ￥%.2f",good.goodPrimaryPrice];
            NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:primaryPrice];
            NSDictionary *priceAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:15.f],NSFontAttributeName,
                                       [NSNumber numberWithInt:2],NSStrikethroughStyleAttributeName,
                                       nil];
            [priceAttrString addAttributes:priceAttr range:NSMakeRange(0, [priceAttrString length])];
            cell.priceLabel.attributedText = priceAttrString;

        
        }
        
        return cell;

    
    
    }
    
    
}



//- (void)tableView:(UICollectionView *)tableView willDisplayCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kGoodCellHeight;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
    
    detailC.hidesBottomBarWhenPushed =  YES ;
    detailC.supplyType=self.supplyType;
    
    detailC.goodID = good.goodID;
    [self.navigationController pushViewController:detailC animated:YES];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GoodListModel *good = [_dataItem objectAtIndex:indexPath.row];
//    GoodDetailViewController *detailC = [[GoodDetailViewController alloc] init];
//    
//    detailC.hidesBottomBarWhenPushed =  YES ;
//
//    detailC.goodID = good.goodID;
//    [self.navigationController pushViewController:detailC animated:YES];
//}
//
#pragma mark - UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchC = [[SearchViewController alloc] init];
    
    searchC.delegate = self;
    searchC.keyword = _keyword;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchC];
    [NavigationBarAttr setNavigationBarStyle:nav];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiedebar" object:self userInfo:nil];

    [self presentViewController:nav animated:NO completion:nil];
    return NO;

}

#pragma mark - SortViewDelegate

- (void)changeValueWithIndex:(NSInteger)index {
    switch (index) {
        case SortDefault:
            _filterType = OrderFilterDefault;
            break;
        case SortSales:
            _filterType = OrderFilterSales;
            break;
        case SortPriceDown:
            _filterType = OrderFilterPriceDown;
            break;
        case SortPriceUp:
            _filterType = OrderFilterPriceUp;
            break;
        case SortScore:
            _filterType = OrderFilterScore;
            break;
        default:
            break;
    }
    [self firstLoadData];
}

#pragma mark - Refresh
//
//- (void)refreshViewReloadData {
//    _reloading = YES;
//}
//
//- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
//    _reloading = NO;
//    if (direction == PullFromTop) {
//        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
//    }
//    else if (direction == PullFromBottom) {
//        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
//        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
//    }
//    [self updateFooterViewFrame];
//}
//
//- (BOOL)refreshViewIsLoading:(RefreshView *)view {
//    return _reloading;
//}
//
//- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
//    [self refreshViewReloadData];
//    //loading...
//    if (view == _topRefreshView) {
//        [self pullDownToLoadData];
//    }
//    else if (view == _bottomRefreshView) {
//        [self pullUpToLoadData];
//    }
//}
//
//- (void)updateFooterViewFrame {
//    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
//    _bottomRefreshView.hidden = NO;
//    if (_tableView.contentSize.height < _tableView.frame.size.height) {
//        _bottomRefreshView.hidden = YES;
//    }
//}
//
//#pragma mark - UIScrollView
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _primaryOffsetY = scrollView.contentOffset.y;
//    
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _tableView) {
//        CGPoint newPoint = scrollView.contentOffset;
//        if (_primaryOffsetY < newPoint.y) {
//            //上拉
//            if (_bottomRefreshView.hidden) {
//                return;
//            }
//            [_bottomRefreshView refreshViewDidScroll:scrollView];
//        }
//        else {
//            //下拉
//            [_topRefreshView refreshViewDidScroll:scrollView];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView == _tableView) {
//        CGPoint newPoint = scrollView.contentOffset;
//        if (_primaryOffsetY < newPoint.y) {
//            //上拉
//            if (_bottomRefreshView.hidden) {
//                return;
//            }
//            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
//        }
//        else {
//            //下拉
//            [_topRefreshView refreshViewDidEndDragging:scrollView];
//        }
//    }
//}

#pragma mark - 上下拉刷新
//下拉刷新
//- (void)pullDownToLoadData {
//    
//    [self firstLoadData];
//}
//
////上拉加载
//- (void)pullUpToLoadData {
//    [self downloadDataWithPage:self.page isMore:YES];
//}

@end
