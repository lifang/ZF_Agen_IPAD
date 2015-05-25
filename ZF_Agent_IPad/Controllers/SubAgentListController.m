//
//  SubAgentListController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/2.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "SubAgentListController.h"
#import "AppDelegate.h"
#import "SubAgentCell.h"
#import "MineCommonController.h"
#import "MJRefresh.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "CreateViewController.h"
#import "NextAgentdetalViewController.h"

#import "NextAgentpeopeleViewController.h"
@interface SubAgentListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat defaultBenefit;

@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, assign) int page;

@end

@implementation SubAgentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDefaultBenefit];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAgentList)
                                                 name:@"agentshaxin"
                                               object:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];

    // Do any additional setup after loading the view.
    self.title = @"管理下级代理商";
    _dataItem = [[NSMutableArray alloc] init];
    
    [self setLeftViewWith:ChooseViewAfterSell];

    namelable=[[UILabel alloc]init];
    namelable.frame=CGRectMake(180, 40,  200, 30);
    namelable.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:namelable];

    UIButton *setbutton = [[UIButton alloc]init];
    [setbutton addTarget:self action:@selector(resetclick) forControlEvents:UIControlEventTouchUpInside];
   setbutton.frame = CGRectMake(400, 35, 120, 40);
    [setbutton setTitle:@"重置" forState:UIControlStateNormal];
    [setbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setbutton setBackgroundColor:kMainColor];
    
    
    
    
    UIButton *setnextbutton = [[UIButton alloc]init];
    [setnextbutton addTarget:self action:@selector(createnextclick) forControlEvents:UIControlEventTouchUpInside];
    [setnextbutton setTitle:@"创建下级代理商" forState:UIControlStateNormal];
    [setnextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setnextbutton setBackgroundColor:kMainColor];
    [self.view addSubview:setnextbutton];
    
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
    UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(180, 90, wide-260, 20)];
    rootview.backgroundColor = kColor(235, 233, 233, 1);
    [self.view addSubview: rootview];
    
    
    UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 20)];
    [rootview addSubview:goodslable];
    goodslable.textAlignment = NSTextAlignmentCenter;
    
    goodslable.text=@"代理商类型";
    
    UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-60-120, 0, 100, 20)];
    [rootview addSubview:phonelable];
    phonelable.textAlignment = NSTextAlignmentCenter;
    
    phonelable.text=@"代理商名称";
    UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-160-160-80, 0, 80, 20)];
    [rootview addSubview:numberlable];
    numberlable.textAlignment = NSTextAlignmentCenter;
    
    numberlable.text=@"加入时间";

    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 110,  SCREEN_HEIGHT-220, SCREEN_WIDTH-110) style:UITableViewStylePlain];
        setnextbutton.frame = CGRectMake(SCREEN_HEIGHT-220-60, 35, 160, 40);

    }
    else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 110,  SCREEN_WIDTH-220, SCREEN_HEIGHT-110) style:UITableViewStylePlain];


        setnextbutton.frame = CGRectMake(SCREEN_WIDTH-220-60, 35, 160, 40);

    
    }
    [self.view addSubview:setbutton];


    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
   
    
    [self initAndLayoutUI];
    [self firstLoadData];
}
- (void)refreshAgentList {
    [self firstLoadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resetclick
{

    [self createui];
    



}
#pragma mark - UI
-(void)createui
{
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        //  wide=SCREEN_HEIGHT;
        //  height=SCREEN_WIDTH;
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
    }
    else
    { // wide=SCREEN_WIDTH;
        //height=SCREEN_HEIGHT;
        wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    
    bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:bigsview];
    bigsview.image=[UIImage imageNamed:@"backimage"];
    bigsview.userInteractionEnabled=YES;
    
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wide/2, height/2)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2);
    witeview.alpha=1;
    
    [bigsview addSubview:witeview];
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(  10, 10, 30, 30);
    [okButton setImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:okButton];
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,wide/2, 30)];
    [witeview addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentCenter;
    
    newaddress.text=@"设置默认分润比例";
    newaddress .font = [UIFont systemFontOfSize:20.f];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, wide/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    
    [witeview addSubview:lineview];
    
    
    
        
        
        UILabel*defaultlable=[[UILabel alloc]initWithFrame:CGRectMake(20,50+60,100, 40)];
        [witeview addSubview:defaultlable];
        defaultlable.textAlignment = NSTextAlignmentCenter;
        
        defaultlable.text=@"默认比例";
    

            neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(140, 50+60,280, 40)];
            [witeview addSubview:neworiginaltextfield];
            neworiginaltextfield.textAlignment=NSTextAlignmentCenter;
            
            CALayer *layer=[neworiginaltextfield layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
   
        
        
    UILabel*BBlable=[[UILabel alloc]initWithFrame:CGRectMake(430, 110,30, 30)];
    [witeview addSubview:BBlable];
    
    BBlable.text=@"%";
    BBlable.font = [UIFont systemFontOfSize:20.f];
    
  
    
    UIButton*savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(  wide/4, height/2-80, 140, 40);
    savebutton.center=CGPointMake(wide/4, height/2-80);
    //    savebutton.layer.cornerRadius=10;
    
    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    [savebutton setTitle:@"确认" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(okclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:savebutton];
}

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
}
-(void)okclick
{
    if (!neworiginaltextfield.text || [neworiginaltextfield.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入分润比例";
        return;
    }
    if (![RegularFormat isFloat:neworiginaltextfield.text] ||
        [neworiginaltextfield.text floatValue] < 0 ||
        [neworiginaltextfield.text floatValue] > 100) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"分润比例必须介于1-100之间";
        return;
    }
    [self setDefaultBenefit];




}

- (void)initAndLayoutUI {
    [self setHeaderAndFooterView];
}
-(void)cancelclick
{
    
    
    [bigsview removeFromSuperview];
    
    
    
    
}
-(void)createnextclick
{

    CreateViewController*createv=[[CreateViewController alloc]init];
    createv.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:createv animated:YES];
    



}
#pragma mark - Request




//获取默认分润
- (void)getDefaultBenefit {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getDefaultBenefitWithAgentID:delegate.agentID token:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    _defaultBenefit = [[object objectForKey:@"result"] floatValue];
                  

                    NSString*st=@"%";
                    
                    namelable.text=[NSString stringWithFormat:@"默认分润比例:%.1f%@",_defaultBenefit,st];
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];
}

- (void)setDefaultBenefit {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface setDefaultBenefitWithAgentID:delegate.agentID token:delegate.token precent:[neworiginaltextfield.text floatValue] finished:^(BOOL success, NSData *response) {
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
                    
                    
                    [bigsview removeFromSuperview];
                    
                    [self getDefaultBenefit];
                    
//                    NSString*st=@"%";
//                    
//                    namelable.text=[NSString stringWithFormat:@"默认分润比例:%@%@",neworiginaltextfield.text,st];

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

- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
    NSLog(@"%d",self.page);
    
    [NetworkInterface getSubAgentListWithAgentID:delegate.agentID token:delegate.token page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    [self parseSubAgentListWithDictionary:object];
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

- (void)parseSubAgentListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([infoList isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [infoList count]; i++) {
            id agentDict = [infoList objectAtIndex:i];
            if ([agentDict isKindOfClass:[NSDictionary class]]) {
                SubAgentModel *model = [[SubAgentModel alloc] initWithParseDictionary:agentDict];
                [_dataItem addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            row = [_dataItem count];
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSString *titleName = nil;
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                break;
            default:
                break;
        }
        cell.textLabel.text = titleName;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        
        return cell;
    }
    else {
        //下级代理商
        static NSString *subAgentIdentifier = @"subAgentIdentifier";
        SubAgentCell *cell = [tableView dequeueReusableCellWithIdentifier:subAgentIdentifier];
        if (cell == nil) {
            cell = [[SubAgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subAgentIdentifier];
        }
        SubAgentModel *model = [_dataItem objectAtIndex:indexPath.row];
        [cell setContentWithData:model];
        
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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

                UIView*lineView = [[UIView alloc]init];
        lineView.frame=CGRectMake(20, 59, wide-220-40, 1);
        
        
             lineView.backgroundColor = [UIColor grayColor];
             [cell addSubview:lineView];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            //默认分润
            
        }
            break;
        case 1: {
            //创建下级代理商
        }
            break;
        case 2: {
            SubAgentModel *model = [_dataItem objectAtIndex:indexPath.row];

            if (model.agentType == AgentTypeCompany) {
                NextAgentdetalViewController*agentdetal=[[NextAgentdetalViewController alloc]init];
                agentdetal.subAgent = model;

                agentdetal.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:agentdetal animated:YES];                }
            else {
                NextAgentpeopeleViewController*agentdetal=[[NextAgentpeopeleViewController alloc]init];
                agentdetal.subAgent = model;

                agentdetal.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:agentdetal animated:YES];
            }

            
           
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return kSubAgentCellHeight;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.f;
    switch (section) {
        case 0:
            height = 0.001f;
            break;
        case 1:
            height = 0.001f;
            break;
        case 2:
            height = 0.001f;
            break;
        default:
            break;
    }
    return height;
}

//下拉刷新加载更多微博数据
-(void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
    
    [self firstLoadData];
    
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



@end
