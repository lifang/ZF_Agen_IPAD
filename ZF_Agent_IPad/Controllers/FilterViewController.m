//
//  FilterViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "FilterViewController.h"
#import "NetworkInterface.h"
#import "TreeDataHandle.h"
#import "FilterContentViewController.h"
#import "AppDelegate.h"
#import "RegularFormat.h"
#import "TreeDataHandle.h"
#import "TreeView.h"
@interface FilterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableViewPJ;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *lowField;

@property (nonatomic, strong) UITextField *highField;

@property (nonatomic, strong) UIButton *switchButton;
///下载的筛选条件
@property (nonatomic, strong) NSDictionary *loadDict;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
  
    
    for(int i=0;i<8;i++)
    {
        _flagArray[i]=YES;
        
        
        
        
        
    }

    namekey=[NSArray arrayWithObjects:@"brands",@"category",@"pay_channel",@"pay_card",@"trade_type",@"sale_slip",@"tDate",@"" ,nil];
    nameking=[NSArray arrayWithObjects:@"POS品牌", @"POS类型",@"支付通道",@"支付卡类型",@"支付交易类型",@"签购单方式",@"对账日期",nil];
    
    _chagnearry=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry1=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry2=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry3=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry4=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry5=[[NSMutableArray alloc]initWithCapacity:0];
    _chagnearry6=[[NSMutableArray alloc]initWithCapacity:0];
    bigarry=[[NSMutableArray alloc]initWithCapacity:0];

    // Do any additional setup after loading the view.
    self.title = @"筛选";
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGoodList)
                                                 name:@"newrefsh"
                                               object:nil];
    [self downloadFilterInfo];
//    [self setOriginalQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

#pragma mark - UI


- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc]init];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
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
    [self initInputView];
}

- (void)initInputView {
   
}

#pragma mark - Data 
////设置查询初始值
//- (void)setOriginalQuery {
//    TreeNodeModel *original = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
//                                                                children:nil
//                                                                  nodeID:kNoneFilterID];
//    NSMutableArray *item = [[NSMutableArray alloc] initWithObjects:original, nil];
//    //所有条件可多选，value为数组
//    [_filterDict setObject:item forKey:s_brands];
//    [_filterDict setObject:item forKey:s_category];
//    [_filterDict setObject:item forKey:s_channel];
//    [_filterDict setObject:item forKey:s_card];
//    [_filterDict setObject:item forKey:s_trade];
//    [_filterDict setObject:item forKey:s_slip];
//    [_filterDict setObject:item forKey:s_date];
//}

//界面上显示筛选条件名，顿号分隔
- (NSString *)nameForSelectedKey:(NSString *)key {
    NSArray *item = [_filterDict objectForKey:key];
    NSString *names = @"";
    for (int i = 0; i < [item count]; i++) {
        TreeNodeModel *node = [item objectAtIndex:i];
        names = [names stringByAppendingString:node.nodeName];
        if (i != [item count] - 1) {
            names = [names stringByAppendingString:@"、"];
        }
    }
    return names;
}

- (void)downloadFilterInfo {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    
    
    [NetworkInterface getGoodSearchInfoWithCityID:delegate.cityID finished:^(BOOL success, NSData *response) {
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
                    
                    _loadDict = [TreeDataHandle parseData:object];
                    
                    NSArray*arry=[[object objectForKey:@"result"] objectForKey:@"brands"];
                    
                    for(int i=0;i<arry.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry objectAtIndex:i] objectForKey:@"value"];

                        [_chagnearry addObject:tree ];
                        
                    }
                    NSArray*arry6=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:6]];
                    for(int i=0;i<arry6.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry6 objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry6 objectAtIndex:i] objectForKey:@"value"];
                        
                        [_chagnearry6 addObject:tree ];
                       
                    }
                    NSArray*arry1=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:2]];
                    
                    for(int i=0;i<arry1.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry1 objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry1 objectAtIndex:i] objectForKey:@"value"];
                        
                        [_chagnearry2 addObject:tree ];
                    }
                    
                    
                    NSArray*arry2=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:1]];
                    NSLog(@"%lu",(unsigned long)arry2.count);
                    
                    for(int i=0;i<arry2.count;i++)
                    {
                        
                        
                        
                        NSString *ID = [NSString stringWithFormat:@"%@",[[arry2 objectAtIndex:i] objectForKey:@"id"]];
                        NSString *value = [NSString stringWithFormat:@"%@",[[arry2 objectAtIndex:i] objectForKey:@"value"]];
                        NSArray *children = [[arry2 objectAtIndex:i] objectForKey:@"son"];

                        
                        
                        
//                        NSArray*at=[[arry2 objectAtIndex:i] objectForKey:@"son"];
//                        NSMutableArray*muarry=[[NSMutableArray alloc]init];
//                        
//                        for(int i=0;i<at.count;i++)
//                        {
                        
                            TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                            tree.nodeID=ID;
                            tree.nodeName=value;
                            tree.children=children;

                        
//                        }
                        [_chagnearry1 addObject:tree ];

                    }
                    
                    
                    
                    NSArray*arry3=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:3]];
                    
                    for(int i=0;i<arry3.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry3 objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry3 objectAtIndex:i] objectForKey:@"value"];
                        
                        [_chagnearry3 addObject:tree ];
                    }
                    
                    
                    NSArray*arry4=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:4]];
                    
                    for(int i=0;i<arry4.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry4 objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry4 objectAtIndex:i] objectForKey:@"value"];
                        
                        [_chagnearry4 addObject:tree ];
                    }
                    
                    
                    NSArray*arry5=[[object objectForKey:@"result"] objectForKey:[namekey objectAtIndex:5]];

                    
                    for(int i=0;i<arry5.count;i++)
                    {
                        TreeNodeModel*tree=[[TreeNodeModel alloc]init];
                        tree.nodeID=[[arry5 objectAtIndex:i] objectForKey:@"id"];
                        tree.nodeName=[[arry5 objectAtIndex:i] objectForKey:@"value"];
                        
                        [_chagnearry5 addObject:tree ];
                    }
                    
                    [bigarry addObject:_chagnearry];
                    [bigarry addObject:_chagnearry1];
                    [bigarry addObject:_chagnearry2];
                    [bigarry addObject:_chagnearry3];
                    [bigarry addObject:_chagnearry4];
                    [bigarry addObject:_chagnearry5];
                    [bigarry addObject:_chagnearry6];


                    [self initAndLayoutUI];

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


#pragma mark - Action
//- (void)removeFilterIfContainAll:(NSMutableArray *)selectedItem {
//    BOOL isContainAll = NO;
//    for (TreeNodeModel *node in selectedItem)
//    {
//        if ([node.nodeID isEqualToString:kNoneFilterID])
//        {
//            isContainAll = YES;
//            break;
//        }
//    }
//    if (isContainAll)
//    {
//        for (TreeNodeModel *node in selectedItem) {
//            if (![node.nodeID isEqualToString:kNoneFilterID])
//            {
//                node.isSelected = NO;
//            }
//        }
//        [selectedItem removeAllObjects];
//        TreeNodeModel *node = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
//                                                                  children:nil
//                                                                    nodeID:kNoneFilterID];
//        [selectedItem addObject:node];
//    }
//}
-(void)updateGoodList
{

   
    
    for(int i=0;i<7;i++)
        
        
        
        
    {
        
        
        NSMutableArray *selectedFilterItem = [[NSMutableArray alloc] init];
        
        
        [selectedFilterItem removeAllObjects];
        
        
       
            
            
            TreeNodeModel *node = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                      children:nil
                                                                        nodeID:kNoneFilterID];
            [selectedFilterItem addObject:node];
            
        [_filterDict setObject:selectedFilterItem forKey:[namekey objectAtIndex:i]];
        
        
    }
    
    
    
    
    [_filterDict setObject:[NSNumber numberWithBool:rentbool] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:[@"0" intValue]] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:[@"0" intValue]] forKey:s_minPrice];
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateGoodListNotification object:nil];

}

- (IBAction)filterFinished:(id)sender {
    
    
    BOOL maxIsNumber = [RegularFormat isNumber:_highField.text];
    BOOL minIsNumber = [RegularFormat isNumber:_lowField.text];
    if (!maxIsNumber || !minIsNumber) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"价格必须为正整数，可输入0查询所有数据"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([_highField.text intValue] < [_lowField.text intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"最低价不能超过最高价"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    for(int i=0;i<7;i++)
        
        
        
        
    {
        
        
        NSMutableArray *selectedFilterItem = [[NSMutableArray alloc] init];

        NSArray*arry=[bigarry objectAtIndex:i];

        [selectedFilterItem removeAllObjects];
        
        
        
        if (_allbool[i])
        {
            for (TreeNodeModel *node in arry)
            {
                if (node.isSelected)
                {
                    
                    [selectedFilterItem addObject:node];
                    
                }
                
                
            }
          
        }

        else
        {
            

            TreeNodeModel *node = [[TreeNodeModel alloc] initWithDirectoryName:@"全部"
                                                                      children:nil
                                                                        nodeID:kNoneFilterID];
            [selectedFilterItem addObject:node];
        
        }
               [_filterDict setObject:selectedFilterItem forKey:[namekey objectAtIndex:i]];

    
    }
    
    


    [_filterDict setObject:[NSNumber numberWithBool:rentbool] forKey:s_rent];
    [_filterDict setObject:[NSNumber numberWithFloat:[_highField.text intValue]] forKey:s_maxPrice];
    [_filterDict setObject:[NSNumber numberWithFloat:[_lowField.text intValue]] forKey:s_minPrice];
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateGoodListNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (IBAction)filterCanceled:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(tableView==_tableViewPJ)
    {
        
        UIView*rootimageview=[[UIView alloc]init];
        return rootimageview;
        
        
    }else
    {
    
    
    
        UIView*rootimageview=[[UIView alloc]init];
        UIView*rootimageviews=[[UIView alloc]init];
        
        if (_flagArray[section])
        {
            
            
            
            if(iOS7)
            {
                rootimageviews.frame=CGRectMake(0, 0, SCREEN_HEIGHT, 100);
                
                rootimageview.frame=CGRectMake(0, 0, SCREEN_HEIGHT, 40);
            }
            else
            {
                rootimageview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 40);
                rootimageviews.frame=CGRectMake(0, 0, SCREEN_WIDTH, 100);
                
                
            }
            
            
            
            
        }
        else
        {
            
            
            if(section<7)
            {
                boolcountA=[[bigarry objectAtIndex:section ] count];
            }
            
            if(iOS7)
            {
                rootimageviews.frame=CGRectMake(0, 0, SCREEN_HEIGHT, 100);
                
                if(boolcountA%4==0)
                {
                    rootimageview.frame=CGRectMake(0, 0, SCREEN_HEIGHT, boolcountA/4*60);
                    
                }else
                {
                    rootimageview.frame=CGRectMake(0, 0, SCREEN_HEIGHT, boolcountA/4*60+60);
                    
                    
                }
            }
            else
            {
                if(boolcountA%4==0)
                {
                    rootimageview.frame=CGRectMake(0, 0, SCREEN_WIDTH, boolcountA/4*60);
                    
                }else
                {
                    rootimageview.frame=CGRectMake(0, 0, SCREEN_WIDTH, boolcountA/4*60+60);
                    
                    
                }
                rootimageviews.frame=CGRectMake(0, 0, SCREEN_WIDTH, 100);
                
                
            }
            
        }
        rootimageviews.userInteractionEnabled=YES;
        rootimageviews.backgroundColor=[UIColor whiteColor];
        rootimageview.userInteractionEnabled=YES;
        rootimageview.backgroundColor=[UIColor whiteColor];
        UILabel*line=[[UILabel alloc]init];
        line.frame=CGRectMake(40,0, rootimageview.frame.size.width-80, 2);
        line.backgroundColor=[UIColor grayColor];
        
        [rootimageview addSubview:line];
        UILabel*lines=[[UILabel alloc]init];
        lines.frame=CGRectMake(40,0, rootimageviews.frame.size.width-80, 2);
        lines.backgroundColor=[UIColor grayColor];
        
        [rootimageviews addSubview:lines];
        
        if(section<7)
        {
            
            UILabel*addresslable=[[UILabel alloc]init];
            addresslable.frame=CGRectMake(100,15, 100, 30);
            
            addresslable.font=[UIFont systemFontOfSize:15];
            [rootimageview addSubview:addresslable];
            addresslable.text=[nameking objectAtIndex:section];
            
            
            
            
            UIButton*phonebutton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            phonebutton.frame=CGRectMake( 200, 15,30, 30);
            if (_allbool[section])
            {
                
                [phonebutton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                
                
                
            }
            else
            {
                
                [phonebutton setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                
            }
            
            [phonebutton addTarget:self action:@selector(allclick:) forControlEvents:UIControlEventTouchUpInside];
            phonebutton.tag=section+1026;
            
            [rootimageview addSubview:phonebutton];
            
            UILabel*allnamelable=[[UILabel alloc]init];
            allnamelable.frame=CGRectMake(235,15, 30, 30);
            
            allnamelable.font=[UIFont systemFontOfSize:15];
            [rootimageview addSubview:allnamelable];
            allnamelable.text=@"全部";
            NSInteger countA;
            
            countA=[[bigarry objectAtIndex:section ] count];
            if (_flagArray[section])
            {
                if(countA<5)
                {
                    for(int i=0;i<countA;i++)
                    {
                        
                        
                        UIButton*whichkindButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
                        whichkindButton.frame= CGRectMake(290+i*140, 15, 30, 30);
                        [rootimageview addSubview:whichkindButton];
                        [whichkindButton addTarget:self action:@selector(selsctButtonclick:) forControlEvents:UIControlEventTouchUpInside];
                        TreeNodeModel *node = [[bigarry objectAtIndex:section] objectAtIndex:i];
                        
                        if (node.isSelected) {
                            
                            [whichkindButton setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                        }
                        else {
                            [whichkindButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                            
                        }
                        whichkindButton.tag=section*1000+i;
                        
                        UILabel*whichlable=[[UILabel alloc]init];
                        whichlable.frame=CGRectMake(320+i*140, 15, 100, 30);
                        whichlable.font=[UIFont systemFontOfSize:15];
                        whichlable.tag=(section*1000+i)*10;

                        [rootimageview addSubview:whichlable];
                        TreeNodeModel*tr=[[bigarry objectAtIndex:section ] objectAtIndex:i ];
                        
                        whichlable.text=tr.nodeName;
                        
                        
                        
                    }
                }
                else
                {
                    
                    for(int i=0;i<4;i++)
                    {
                        UIButton*whichkindButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
                        whichkindButton.frame= CGRectMake(290+i*140, 15, 30, 30);
                        [rootimageview addSubview:whichkindButton];
                        [whichkindButton addTarget:self action:@selector(selsctButtonclick:) forControlEvents:UIControlEventTouchUpInside];
                        TreeNodeModel *node = [[bigarry objectAtIndex:section] objectAtIndex:i];
                        
                        if (node.isSelected) {
                            
                            [whichkindButton setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                        }
                        else {
                            [whichkindButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                            
                        }
                        whichkindButton.tag=section*1000+i;
                        
                        UILabel*whichlable=[[UILabel alloc]init];
                        whichlable.frame=CGRectMake(320+i*140, 15, 100, 30);
                        whichlable.font=[UIFont systemFontOfSize:15];
                        [rootimageview addSubview:whichlable];
                        TreeNodeModel*tr=[[bigarry objectAtIndex:section ] objectAtIndex:i ];
                        
                        whichlable.text=tr.nodeName;
                        
                        whichlable.tag=(section*1000+i)*10;

                        
                    }
                    
                }
                
                
            }
            else
            {
                
                
                for(int i=0;i<countA;i++)
                {
                    UIButton*whichkindButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
                    whichkindButton.frame= CGRectMake(290+i%4*140, i/4*60+15, 30, 30);
                    [rootimageview addSubview:whichkindButton];
                    whichkindButton.tag=section*1000+i;
                    
                    
                    [whichkindButton addTarget:self action:@selector(selsctButtonclick:) forControlEvents:UIControlEventTouchUpInside];
                    TreeNodeModel *node = [[bigarry objectAtIndex:section] objectAtIndex:i];
                    
                    if (node.isSelected) {
                        
                        [whichkindButton setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                    }
                    else {
                        [whichkindButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                        
                    }
                    
                    UILabel*whichlable=[[UILabel alloc]init];
                    whichlable.frame=CGRectMake(320+i%4*140, i/4*60+15, 100, 30);
                    whichlable.font=[UIFont systemFontOfSize:15];
                    [rootimageview addSubview:whichlable];
                    TreeNodeModel*tr=[[bigarry objectAtIndex:section ] objectAtIndex:i ];
                    whichlable.tag=(section*1000+i)*10;

                    whichlable.text=tr.nodeName;
                    
                    
                    
                }
                
            }
            
            UIButton*morebutton = [UIButton buttonWithType:UIButtonTypeCustom] ;
            morebutton.tag=section;
            
            morebutton.frame= CGRectMake(rootimageview.frame.size.width-130, 15, 80, 30);
            [rootimageview addSubview:morebutton];
            [morebutton addTarget:self action:@selector(moreclick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            if (_flagArray[section])
            {
                
                [morebutton setTitle:@"更多" forState:UIControlStateNormal];
                
                
                
            }
            else
            {if(countA<5)
            {
                [morebutton setTitle:@"已无更多" forState:UIControlStateNormal];
                
            }else
            {
                [morebutton setTitle:@"收起" forState:UIControlStateNormal];
            }
            }
            
            
            [morebutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
            
            return rootimageview;
        }
        else
        {
            
            _switchButton =[UIButton buttonWithType:UIButtonTypeCustom];
            _switchButton.frame=CGRectMake(50, 65, 30, 30);
            [_switchButton addTarget:self action:@selector(rentboolclick) forControlEvents:UIControlEventTouchUpInside];
            
            [rootimageviews addSubview:_switchButton];
            
            if(      [[_filterDict objectForKey:s_rent] boolValue])
            {
                [_switchButton setBackgroundImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                
            }
            else
            {
                [_switchButton setBackgroundImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                
                
            }
            
            
            UILabel*rentlable=[[UILabel alloc]init];
            rentlable.frame=CGRectMake(80,65, 140, 30);
            rentlable.text=@"支持租赁";
            rentlable.font=[UIFont systemFontOfSize:16];
            rentlable.textColor=[UIColor grayColor];
            [rootimageviews addSubview:rentlable];
            
            
            if(iOS7)
            {
                _highField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT-210-100, 60, 80, 40)];
                _lowField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT-210-90-120, 60, 80, 40)];
                
                
            }
            
            
            
            
            else
            {
                _highField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210-100, 60, 80, 40)];
                _lowField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210-90-120, 60, 80, 40)];
                
                
            }
            
            _lowField.keyboardType = UIKeyboardTypeNumberPad;
            _highField.keyboardType = UIKeyboardTypeNumberPad;
            _highField.rightViewMode = UITextFieldViewModeAlways;
            _lowField.rightViewMode = UITextFieldViewModeAlways;
            
            UIView *v = [[UIView alloc]init];
            v.frame = CGRectMake(0, 0, 10, 40);
            UIView *v1 = [[UIView alloc]init];
            v1.frame = CGRectMake(0, 0, 10, 40);
            _highField.rightView = v;
            _lowField.rightView = v1;
            
            _lowField.font = [UIFont systemFontOfSize:14.f];
            _lowField.backgroundColor = [UIColor clearColor];
            _lowField.textAlignment = NSTextAlignmentRight;
            //        _lowField.placeholder = @"0    ";
            _lowField.delegate = self;
            CALayer *layer=[_lowField layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
            [rootimageviews addSubview:_lowField];
            
            UILabel*pricelable=[[UILabel alloc]init];
            pricelable.frame=CGRectMake(_lowField.frame.origin.x-50,65, 50, 30);
            pricelable.text=@"价格： ";
            pricelable.font=[UIFont systemFontOfSize:16];
            pricelable.textColor=[UIColor grayColor];
            [rootimageviews addSubview:pricelable];
            
            _highField.font = [UIFont systemFontOfSize:14.f];
            _highField.backgroundColor = [UIColor clearColor];
            //        _highField.placeholder = @"0   ";
            _highField.delegate = self;
            
            _lowField.text = [NSString stringWithFormat:@"%d",[[_filterDict objectForKey:s_minPrice] intValue]];
            _highField.text = [NSString stringWithFormat:@"%d",[[_filterDict objectForKey:s_maxPrice] intValue]];
            _highField.textAlignment = NSTextAlignmentRight;
            
            CALayer *layers=[_highField layer];
            //是否设置边框以及是否可见
            [layers setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layers setBorderWidth:1];
            //设置边框线的颜色
            [layers setBorderColor:[[UIColor grayColor] CGColor]];
            [rootimageviews addSubview:_highField];
            
            UILabel*adlable=[[UILabel alloc]init];
            adlable.frame=CGRectMake(_lowField.frame.size.width+_lowField.frame.origin.x+10,80, 10, 2);
            adlable.font=[UIFont systemFontOfSize:20];
            adlable.backgroundColor=[UIColor grayColor];
            [rootimageviews addSubview:adlable];
            
            UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *canebutton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if(iOS7)
            {
                
                signOut.frame = CGRectMake(SCREEN_HEIGHT-40-80, 60, 80, 40);
                canebutton.frame = CGRectMake(SCREEN_HEIGHT-40-80-90, 60, 80, 40);
                
                
            }
            else
                
            {
                
                signOut.frame = CGRectMake(SCREEN_WIDTH-40-80, 60, 80, 40);
                canebutton.frame = CGRectMake(SCREEN_WIDTH-40-80-90, 60, 80, 40);
                
                
            }
            //        canebutton.layer.cornerRadius = 4;
            canebutton.layer.masksToBounds = YES;
            canebutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
            [canebutton setTitle:@"取消" forState:UIControlStateNormal];
            [canebutton setTitleColor:kColor(3, 112, 214, 1) forState:UIControlStateNormal];
            [canebutton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
            
            CALayer *layercane=[canebutton layer];
            //是否设置边框以及是否可见
            [layercane setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layercane setBorderWidth:1];
            //设置边框线的颜色
            [layercane setBorderColor:[kColor(3, 112, 214, 1) CGColor]];
            
            //        signOut.layer.cornerRadius = 4;
            signOut.layer.masksToBounds = YES;
            signOut.titleLabel.font = [UIFont systemFontOfSize:16.f];
            [signOut setTitle:@"确认" forState:UIControlStateNormal];
            [signOut setBackgroundColor:kColor(3, 112, 214, 1)];
            
            [signOut addTarget:self action:@selector(filterFinished:) forControlEvents:UIControlEventTouchUpInside];
            [rootimageviews addSubview:signOut];
            [rootimageviews addSubview:canebutton];
            
            
            return rootimageviews;
        }

    
    }
    
   

}
-(void)goback
{



    [self.navigationController popViewControllerAnimated:YES];
    



}
-(void)allclick:(UIButton*)sender
{

    UIButton *button=(UIButton *)sender;
    
    //根据按钮的tag值找到所找按钮所在的区
    int section=button.tag-1026;
    
    //取反  如果布尔数组中的值是yes=>>no.no=>>yes
    _allbool[section]=!_allbool[section];
    
    [_tableView reloadData];


}
-(void)rentboolclick
{

    rentbool=!rentbool;
    [_filterDict setObject:[NSNumber numberWithBool:rentbool] forKey:s_rent];
    [_tableView reloadData];
    


}
-(void)createui
{
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
    
    bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:bigsview];
    bigsview.image=[UIImage imageNamed:@"backimage"];
    bigsview.userInteractionEnabled=YES;
    
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wide/2, wide/2)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2-120);
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
    
    newaddress.text=@"POS类型";
    newaddress .font = [UIFont systemFontOfSize:20.f];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, wide/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    
    [witeview addSubview:lineview];
    _tableViewPJ = [[UITableView alloc] initWithFrame:CGRectMake(0, 51, wide/2, wide/2) style:UITableViewStylePlain];
   _tableViewPJ.backgroundColor =[UIColor whiteColor];
    _tableViewPJ.delegate = self;
    _tableViewPJ.dataSource = self;
    [witeview addSubview:_tableViewPJ];
    _tableViewPJ.tableFooterView = [[UIView alloc]init];

   
    
    
}
-(void)cancelclick
{
    
    
    [bigsview removeFromSuperview];
}

-(void)selsctButtonclick:(UIButton*)sender
{
    selectinttag=sender.tag;
    
     selectint=sender.tag/1000;
//    [_namesnumber removeAllObjects];
    _smallarry=[[NSMutableArray alloc]init];
    [_smallarry removeLastObject];
    
    _namesnumber=[[NSArray alloc]init];
    

if(selectint==1)
{
    TreeNodeModel*tr=[[bigarry objectAtIndex:selectint ] objectAtIndex:sender.tag-selectint*1000 ];
    
    _namesnumber=tr.children;
    
    for(int i=0;i<_namesnumber.count;i++)
    {
    
        TreeNodeModel*trs=[[TreeNodeModel alloc]init];
        trs.nodeID=[[_namesnumber objectAtIndex:i] objectForKey:@"id"];
        trs.nodeName=[[_namesnumber objectAtIndex:i] objectForKey:@"value"];

        [_smallarry addObject:trs];
        

    
    
    }
    
    
    if(_namesnumber.count>=1)
    {
    
        [self createui];

    
    
    }else
    {
    
//        TreeNodeModel *node = [[bigarry objectAtIndex:selectint] objectAtIndex:sender.tag-selectint*1000];
        
        NSArray*arry=[bigarry objectAtIndex:selectint];
        for(int i=0;i<arry.count;i++)
        {    UIButton*button=(UIButton*)[self.view viewWithTag:1000+i];
            TreeNodeModel *node = [[bigarry objectAtIndex:selectint] objectAtIndex:i];

            if(button.tag==selectinttag)
            {
                node.isSelected =YES;

                [button setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
                
            }else
            {
                node.isSelected = NO;

                
                [button setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
                
                
            }
            
            
        }

//        if (node.isSelected) {
//            
//            [sender setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
//        }
//        else {
//            [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
//            
//        }

    
    
    
    }
    
    
}
else
{

    TreeNodeModel *node = [[bigarry objectAtIndex:selectint] objectAtIndex:sender.tag-selectint*1000];
    
    
    node.isSelected = !node.isSelected;
    if (node.isSelected) {
        
        [sender setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        
    }
}


}
-(void)moreclick:(UIButton*)sender
{

    UIButton *button=(UIButton *)sender;
    
    //根据按钮的tag值找到所找按钮所在的区
    int section=button.tag;
    
    //取反  如果布尔数组中的值是yes=>>no.no=>>yes
    _flagArray[section]=!_flagArray[section];

    [_tableView reloadData];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        if(tableView==_tableViewPJ)
        {
            return 0;
            
        
        }else
        {
        
        
            if(section==0)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            if(section==1)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            if(section==2)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            if(section==3)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            if(section==4)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            if(section==5)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            if(section==6)
            {
                
                if (_flagArray[section])
                {
                    return 40;
                    
                }
                else
                {
                    boolcountA=[[bigarry objectAtIndex:section ] count];
                    
                    if(boolcountA%4==0)
                    {
                        return  boolcountA/4*60;
                        
                        
                    }
                    else
                    {
                        return boolcountA/4*60+40;
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            else
            {
                
                return 120;
                
                
            }
            
            
            
            
            

        
        
        }
        
        
  
  
    












}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView==_tableViewPJ)
    {
        return 1;

    }else
    {
        return 8;

    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    if(tableView==_tableViewPJ)
    {
        return _namesnumber.count;
        
    }else
    {
        return 0;
        
        
    }

    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    switch (indexPath.section) {
//        case 0: {
//            cell.textLabel.text = @"只包含租赁";
//            _switchButton.frame = CGRectMake(kScreenWidth - 60, 6, 40, 30);
//            [cell.contentView addSubview:_switchButton];
//        }
//            break;
//        case 1: {
//            NSString *titleName = nil;
//            NSString *key = nil;
//            switch (indexPath.row) {
//                case 0:
//                    titleName = @"选择POS品牌";
//                    key = s_brands;
//                    break;
//                case 1:
//                    titleName = @"选择POS类型";
//                    key = s_category;
//                    break;
//                case 2:
//                    titleName = @"选择支付通道";
//                    key = s_channel;
//                    break;
//                case 3:
//                    titleName = @"选择支付卡类型";
//                    key = s_card;
//                    break;
//                case 4:
//                    titleName = @"选择支付交易类型";
//                    key = s_trade;
//                    break;
//                case 5:
//                    titleName = @"选择签购单方式";
//                    key = s_slip;
//                    break;
//                case 6:
//                    titleName = @"选择对账日期";
//                    key = s_date;
//                    break;
//                default:
//                    break;
//            }
//            cell.textLabel.text = titleName;
//            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
//            cell.detailTextLabel.text = [self nameForSelectedKey:key];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
//        case 2: {
//            switch (indexPath.row) {
//                case 0: {
//                    cell.textLabel.text = @"最低价￥";
//                    _lowField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
//                    [cell.contentView addSubview:_lowField];
//                }
//                    break;
//                case 1: {
//                    cell.textLabel.text = @"最高价￥";
//                    _highField.frame = CGRectMake(kScreenWidth - 120, 0, 100, cell.frame.size.height);
//                    [cell.contentView addSubview:_highField];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    
    if(tableView==_tableViewPJ)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
        
        cell.imageView.image=[UIImage imageNamed:@"select_normal"];
        cell.textLabel.text=[[_namesnumber objectAtIndex:indexPath.row ] objectForKey:@"value"];
        
        return cell;
        
    }else
    {    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

        
        return cell;

    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (indexPath.section == 1) {
//        NSString *key = nil;
//        switch (indexPath.row) {
//            case 0:
//                key = s_brands;
//                break;
//            case 1:
//                key = s_category;
//                break;
//            case 2:
//                key = s_channel;
//                break;
//            case 3:
//                key = s_card;
//                break;
//            case 4:
//                key = s_trade;
//                break;
//            case 5:
//                key = s_slip;
//                break;
//            case 6:
//                key = s_date;
//                break;
//            default:
//                break;
//        }
//        FilterContentViewController *filterC = [[FilterContentViewController alloc] init];
//        filterC.title = cell.textLabel.text;
//        filterC.key = key;
//        filterC.selectedFilterDict = _filterDict;
//        filterC.dataItem = [_loadDict objectForKey:key];
//        [self.navigationController pushViewController:filterC animated:YES];
//    }
    TreeNodeModel *node = [_smallarry objectAtIndex:indexPath.row];

    
    node.isSelected = !node.isSelected;
    [bigsview removeFromSuperview];
    UILabel*lable=(UILabel*)[self.view viewWithTag:selectinttag*10];
    lable.text=node.nodeName;
    
    NSArray*arry=[bigarry objectAtIndex:selectint];
    
    
//    nodes.isSelected = !nodes.isSelected;
    for(int i=0;i<arry.count;i++)
        
        
    {            TreeNodeModel *node = [[bigarry objectAtIndex:selectint] objectAtIndex:i];

        
        UIButton*button=(UIButton*)[self.view viewWithTag:1000+i];

    if(button.tag==selectinttag)
    {
        node.isSelected=YES;
        
        [button setImage:[UIImage imageNamed:@"select_height"] forState:UIControlStateNormal];

    }else
    {
        node.isSelected=NO;

        [button setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];

    
    }
    
    
    }
    
    
//    if (nodes.isSelected) {
//        
//    }
//    else {
//        
//    }
    
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    
//    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    

    
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
    
    [self  closeKeyboard];
    
    
    
    
    
}// m
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [self  closeKeyboard];
    
    
    [_lowField resignFirstResponder];
    [_highField resignFirstResponder];

    return YES;
}
-(void)closeKeyboard
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(iOS7)
    {
    
        _tableView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);

    }
    
    else
    
    {
        
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
 
        
        
    }
    
    
    [UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    
    if(iOS7)
    {
        
        _tableView.frame=CGRectMake(0, -160, SCREEN_HEIGHT, SCREEN_WIDTH);
        
    }
    
    else
        
    {
        
        _tableView.frame=CGRectMake(0, -160, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        
        
    }
    
    
    
    [UIView commitAnimations];
    
    
}


@end
