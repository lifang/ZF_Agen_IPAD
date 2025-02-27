//
//  TerminalSelectViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/14.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "TerminalSelectViewController.h"
#import "TerminalSelectCell.h"
#import "TerminalSelectModel.h"
#import "NetworkInterface.h"
#import "ChannelListModel.h"
#import "RegularFormat.h"
#import "SearchTermianlViewController.h"
#import "MJRefresh.h"

@interface TerminalSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIPopoverControllerDelegate,SearchDelegate>
{
   // BOOL isSelected;
    //CGFloat summaryPrice;
     NSInteger sumall;
     NSInteger pickerstatus;
    NSInteger URLstatus;

}

@property (nonatomic, strong) UITextView *POSTV;
@property (nonatomic, strong) UIButton *POSBtn;
@property (nonatomic, strong) UITextView *channelTV;
@property (nonatomic, strong) UIButton *channelBtn;

@property (nonatomic, strong) UITextView *terminalTV;

@property (nonatomic, strong) UILabel *placeholderLB;

//@property (nonatomic, strong) UITextView *minPriceTV;
//@property (nonatomic, strong) UITextView *maxPriceTV;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *terminalList;

@property (nonatomic, strong) NSMutableArray *terminalItems;


@property (nonatomic, strong) NSString *POStitle;
@property (nonatomic, assign) int channelsId;
@property (nonatomic, assign) int minPrice;
@property (nonatomic, assign) int maxPrice;
@property (nonatomic, strong) NSString *masterChannel;
@property (nonatomic, strong) NSString *branchChannel;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIPopoverController *popViewController;

@property (nonatomic, strong) UIPickerView  *pickerView;

@property (nonatomic, strong) NSMutableArray *POSArray;

@property (nonatomic, strong) NSMutableArray *channelItems;

@property (nonatomic, strong) NSArray *pickerArray;  //pickerView 第二列

@property (nonatomic, strong) UILabel *numberLB;

@property (nonatomic, assign) int page;

//@property (nonatomic, strong)NSMutableArray *terminalsArray;//输入的终端号

@end

@implementation TerminalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择终端";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _terminalList=[[NSMutableArray alloc] init];
    _POSArray=[[NSMutableArray alloc] init];
    _channelItems=[[NSMutableArray alloc] init];
    URLstatus=1000;
    //_terminalsArray=[[NSMutableArray alloc] init];
    
    UILabel *POSLB=[[UILabel alloc ] init];
    POSLB.font = FONT20;
    POSLB.text=@"选择POS机";
    POSLB.textColor = [UIColor colorWithHexString:@"292929"];
    POSLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:POSLB];
    [POSLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(self.view.top).offset(90);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _POSTV = [[UITextView alloc] init];
    _POSTV.delegate = self;
    _POSTV.userInteractionEnabled = NO;
    _POSTV.clipsToBounds = YES;
    _POSTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _POSTV.layer.borderWidth = 1.0f;
    _POSTV.layer.cornerRadius = 3.0f;
    _POSTV.font = FONT20;
    _POSTV.textAlignment=NSTextAlignmentLeft;
    _POSTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _POSTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_POSTV];
    [_POSTV  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(POSLB.mas_right).offset(24);
        make.top.equalTo(POSLB.top);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    _POSBtn = [[UIButton alloc] init];
    [_POSBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [_POSBtn addTarget:self action:@selector(POSBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_POSBtn];
    [_POSBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(POSLB.top);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.width.equalTo(@(280/6.0));
        
    }];

    
    UILabel *channelLB=[[UILabel alloc ] init];
    channelLB.font = FONT20;
    channelLB.text=@"选择支付通道";
    channelLB.textColor = [UIColor colorWithHexString:@"292929"];
    channelLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:channelLB];
    [channelLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(44);
        make.top.equalTo(self.view.top).offset(90);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _channelTV = [[UITextView alloc] init];
    _channelTV.delegate = self;
    _channelTV.userInteractionEnabled = NO;
    _channelTV.clipsToBounds = YES;
    _channelTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _channelTV.layer.borderWidth = 1.0f;
    _channelTV.layer.cornerRadius = 3.0f;
    _channelTV.font = FONT20;
    _channelTV.textAlignment=NSTextAlignmentLeft;
    _channelTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _channelTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_channelTV];
    [_channelTV  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(channelLB.mas_right).offset(24);
        make.top.equalTo(channelLB.top);
        make.right.equalTo(self.view.right).offset(-64);
        make.height.equalTo(@42);
    }];
    
    _channelBtn = [[UIButton alloc] init];
    [_channelBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [_channelBtn addTarget:self action:@selector(channelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_channelBtn];
    [_channelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(POSLB.top);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.right).offset(-64);
        make.width.equalTo(@(280/6.0));
        
    }];

    UILabel *TerminalLB=[[UILabel alloc ] init];
    TerminalLB.font = FONT20;
    TerminalLB.text=@"输入终端号";
    TerminalLB.textColor = [UIColor colorWithHexString:@"292929"];
    TerminalLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:TerminalLB];
    [TerminalLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(64);
        make.top.equalTo(POSLB.bottom).offset(60);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _terminalTV = [[UITextView alloc] init];
    _terminalTV.delegate = self;
    _terminalTV.returnKeyType = UIReturnKeyDone;
    _terminalTV.clipsToBounds = YES;
    _terminalTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _terminalTV.layer.borderWidth = 1.0f;
    _terminalTV.layer.cornerRadius = 3.0f;
    _terminalTV.font = FONT14;
    _terminalTV.textAlignment=NSTextAlignmentLeft;
    _terminalTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _terminalTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_terminalTV];
    [_terminalTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(TerminalLB.mas_right).offset(24);
        make.centerY.equalTo(TerminalLB.centerY);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@80);
    }];
    
    
    _placeholderLB = [[UILabel alloc] init];
    _placeholderLB.backgroundColor = [UIColor clearColor];
    _placeholderLB.textColor = kColor(146, 146, 146, 1);
    _placeholderLB.font = [UIFont systemFontOfSize:15.f];
    _placeholderLB.text = @"请输入终端号，终端号之间回车间隔";
    [self.view addSubview:_placeholderLB];
    [_placeholderLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_terminalTV.left).offset(5);
        make.top.equalTo(_terminalTV.top).offset(5);
        make.right.equalTo(_terminalTV.right);
        
    }];
    
    
    _confirmBtn = [[UIButton alloc] init];
    [ _confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [_confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    [_confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.centerX).offset(44);
        make.centerY.equalTo(TerminalLB.centerY);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
        
    }];
    
/*
    UILabel *priceLB=[[UILabel alloc ] init];
    priceLB.font = FONT20;
    priceLB.text=@"价格";
    priceLB.textColor = [UIColor colorWithHexString:@"292929"];
    priceLB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:priceLB];
    [priceLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(44);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@42);
    }];
    
    
    _minPriceTV = [[UITextView alloc] init];
    _minPriceTV.delegate = self;
    _minPriceTV.clipsToBounds = YES;
    _minPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _minPriceTV.layer.borderWidth = 1.0f;
    _minPriceTV.layer.cornerRadius = 3.0f;
    _minPriceTV.font = FONT20;
    _minPriceTV.textAlignment=NSTextAlignmentLeft;
    _minPriceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _minPriceTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_minPriceTV];
    [_minPriceTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.right).offset(24);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@42);
    }];
    
    UILabel *LB=[[UILabel alloc ] init];
    LB.font = FONT20;
    LB.text=@"-";
    LB.textColor = [UIColor colorWithHexString:@"292929"];
    LB.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:LB];
    [LB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minPriceTV.right).offset(5);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@42);
    }];
    
    
    _maxPriceTV = [[UITextView alloc] init];
    _maxPriceTV.delegate = self;
    _maxPriceTV.clipsToBounds = YES;
    _maxPriceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _maxPriceTV.layer.borderWidth = 1.0f;
    _maxPriceTV.layer.cornerRadius = 3.0f;
    _maxPriceTV.font = FONT20;
    _maxPriceTV.textAlignment=NSTextAlignmentLeft;
    _maxPriceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _maxPriceTV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_maxPriceTV];
    [_maxPriceTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LB.right).offset(5);
        make.centerY.equalTo(TerminalLB.centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@42);
    }];

    _confirmBtn = [[UIButton alloc] init];
    [ _confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [_confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    [_confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_maxPriceTV.right).offset(10);
        make.centerY.equalTo(TerminalLB.centerY);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.right).offset(-64);
 
    }];
*/
 
    UILabel *line=[[UILabel alloc ] init];
    [line setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [self.view  addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_terminalTV.bottom).offset(20);
        make.left.equalTo(self.view.left).offset(60);
        make.right.equalTo(self.view.right).offset(-60);
        make.height.equalTo(@1);
    }];
    
    
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    //headerView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(20);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@40);
    }];
    
    UILabel *termLB = [[UILabel alloc] init];
    [termLB setBackgroundColor:[UIColor clearColor]];
    [termLB setFont:[UIFont systemFontOfSize:20]];
    termLB.textColor= [UIColor colorWithHexString:@"292929"];
    termLB.text=@"终端号";
    termLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:termLB];
    [termLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
       // make.left.equalTo(headerView.left).offset(26);
        make.left.equalTo(headerView.left).offset(100);
        make.right.equalTo(headerView.centerX);
        //make.width.equalTo(@120);
        
    }];
    
    UILabel *priLB = [[UILabel alloc] init];
    [priLB setBackgroundColor:[UIColor clearColor]];
    [priLB setFont:[UIFont systemFontOfSize:20]];
    priLB.textColor= [UIColor colorWithHexString:@"292929"];
    priLB.text=@"价格";
    priLB.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:priLB];
    [priLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.centerX);
        make.right.equalTo(headerView.right).offset(-200);
        //make.width.equalTo(@120);
        
    }];
    
    
    UIButton *searchBtn=[[UIButton alloc] init];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    [searchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
       // make.left.equalTo(priceLB.right).offset(60);
        make.right.equalTo(headerView.right).offset(-100);
        make.width.equalTo(@40);
        
    }];

    _tableView= [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-60);
    }];
    
    [_tableView addHeaderWithTarget:self action:@selector(firstLoadData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    
    
    //创建头部View
    UIView *FooterView = [[UIView alloc]init];
    FooterView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
    [self.view addSubview:FooterView];
    [FooterView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@60);
    }];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.layer.masksToBounds = YES;
    _finishBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [FooterView addSubview:_finishBtn];
    [_finishBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.right.equalTo(self.view.right).offset(-100);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
    
    //选中按钮
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedBtn setImage:kImageName(@"btn_noselect") forState:UIControlStateNormal];
    //[_selectedBtn setSelected:NO];
    [FooterView addSubview:_selectedBtn];
    [_selectedBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.left.equalTo(self.view.left).offset(100);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    
    //全选文字
    UILabel *selectedLB = [[UILabel alloc] init];
    selectedLB.backgroundColor = [UIColor clearColor];
    selectedLB.font = [UIFont systemFontOfSize:15.f];
    selectedLB.textColor = kColor(128, 126, 126, 1);
    selectedLB.text = @"全选";
    selectedLB.userInteractionEnabled = YES;
    [FooterView addSubview:selectedLB];
    [selectedLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.left.equalTo(_selectedBtn.right).offset(30);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];
   
  
   
    _numberLB = [[UILabel alloc] init];
    _numberLB.font = [UIFont boldSystemFontOfSize:16.f];
    _numberLB.text = [NSString stringWithFormat:@"已选中0台"];
    [FooterView addSubview:_numberLB];
    [_numberLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FooterView.centerY);
        make.centerX.equalTo(FooterView.centerX);
        make.height.equalTo(@42);
        make.width.equalTo(@120);
    }];

   
    
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"])
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)loadMoreData
{    if( [self isBlankString: _POSTV.text]==NO||[self isBlankString:_channelTV.text]==NO||[self isBlankString:_terminalTV.text]==NO)

{

    if (URLstatus==1000) {
        [self  FilterTerminalsWithPage:_page isMore:YES];
    }

}

   
    else
    {
       
      [_tableView footerEndRefreshing];
    }
  

}


-(void)POSBtnPressed:(id)sender
{
    pickerstatus=100;
    
    URLstatus=1000;
    [self ChoosePOSData];
   // _POStitle=[NSString stringWithFormat:@"%@"
   //            , [_POSArray[0] objectForKey:@"title"]];
    //[self pickerDisplay:_POSTV];
    
}

-(void)channelBtnPressed:(id)sender
{
     pickerstatus=200;
    
     URLstatus=1000;
     [self getChannelList];
    //[self pickerDisplay:_channelTV];


}

-(void)confirmBtnPressed:(id)sender
{
     URLstatus=2000;
    [_terminalList removeAllObjects];
   // [self FilterTerminals];
  //   [self firstLoadData];
    NSArray *terminalArray = [_terminalTV.text componentsSeparatedByString:@"\n"];
    //_terminalsArray = [_terminalTV.text componentsSeparatedByString:@"\n"];
    if (terminalArray) {
        [self searchTerminalWithArray:terminalArray];
        //[self firstLoadData];
    }

}


-(void)searchBtnPressed:(id)sender
{
    URLstatus=3000;
    [_terminalList removeAllObjects];
    
    SearchTermianlViewController *searchTerminalVC=[[SearchTermianlViewController alloc] init];
    searchTerminalVC.delegate=self;
    searchTerminalVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchTerminalVC animated:YES];

}


- (void)refreshSelectedInfo {
    int selectedCount = 0;
    for (TerminalSelectModel *model in _terminalList) {
        if (model.isSelected) {
            selectedCount++;
        }
    }
    if (selectedCount > 0) {
        
      if (selectedCount == [_terminalList count]) {
    
       // [_selectedBtn setImage:kImageName(@"select_height") forState:UIControlStateNormal];
        [_selectedBtn setImage:kImageName(@"btn_select") forState:UIControlStateNormal];
      }
      else {
       // [_selectedBtn setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        [_selectedBtn setImage:kImageName(@"btn_noselect") forState:UIControlStateNormal];

      }
    }
    _numberLB.text = [NSString stringWithFormat:@"已选中%d台",selectedCount];
   
}



-(void)selectedBtnPressed:(id)sender
{
    
    
    int Count = 0;
    if (_selectedBtn.isSelected) {
        for (TerminalSelectModel *model in _terminalList) {
            if (!model.isSelected) {
                model.isSelected = !model.isSelected;
            }
            Count++;
        }
        [_selectedBtn setSelected:NO];
        [_selectedBtn setImage:kImageName(@"btn_select") forState:UIControlStateNormal];
            }
    else {
        Count =0;
        for (TerminalSelectModel *model in _terminalList) {
            if (model.isSelected) {
                model.isSelected = !model.isSelected;
            }
        }
        [_selectedBtn setSelected:YES];
        [_selectedBtn setImage:kImageName(@"btn_noselect") forState:UIControlStateNormal];
        
    }
    _numberLB.text = [NSString stringWithFormat:@"已选中%d台",Count];
    [_tableView reloadData];

}




-(void)select:(TerminalSelectModel *)model
{
    
    [self refreshSelectedInfo];
    
}


#pragma mark -searchTerminalDelegate

- (void)getSearchKeyword:(NSString *)keyword
{
    [self searchTerminalWithString:keyword];
    

}


-(void)finishBtnPressed:(id)sender
{
    
         NSMutableArray *selectedTerminal = [[NSMutableArray alloc] init];
         for (TerminalSelectModel *model in _terminalList) {
             if (model.isSelected) {
                 [selectedTerminal addObject:model];
             }
         }
         if ([selectedTerminal count] <= 0) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
             hud.customView = [[UIImageView alloc] init];
             hud.mode = MBProgressHUDModeCustomView;
             [hud hide:YES afterDelay:1.f];
             hud.labelText = @"请至少选择一个终端";
             return;
         }
    /*
    NSMutableArray *terminalList = [[NSMutableArray alloc] init];
    for (TerminalSelectModel *model in _terminalList) {
        if (model.isSelected) {
            [terminalList addObject:model];
        }
    }
*/
    
   // if (_delegate && [_delegate respondsToSelector:@selector(getSelectedTerminal:)]) {
        [_delegate getSelectedTerminal:selectedTerminal];
         [self.navigationController popViewControllerAnimated:YES];
    // }
}


//选择POS
- (void)ChoosePOSData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface  screeningPOSNameWithtoken:delegate.token customerId:delegate.agentUserID finished:^(BOOL success, NSData *response) {
        NSLog(@"POS：%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parsePOSDataWithDictionary:object];
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


//选择支付通道

- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getChannelsWithToken:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseChannelListWithDictionary:object];
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


#pragma mark - Request
//pos机,通道,价格,筛选终端

- (void)firstLoadData {
     _page = 1;
    if( [self isBlankString: _POSTV.text]==NO||[self isBlankString:_channelTV.text]==NO||[self isBlankString:_terminalTV.text]==NO)

    {
    
        if(URLstatus==1000) {
            [self FilterTerminalsWithPage:_page isMore:NO];
            
        }
        else if(URLstatus==2000)
        {
            
            //[self searchTerminalWithArray:_terminalsArray];
            [_tableView headerEndRefreshing];
            //[_tableView footerEndRefreshing];
            
        }

    
    
    }
       else
    {
       // [self searchTerminalWithString:];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    
    }
   
    
}

- (void)FilterTerminalsWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    
     [NetworkInterface screeningTerminalNumWithtoken:delegate.token agentId:delegate.agentID POStitle:_POSTV.text channelsId:_channelsId minPrice:0 maxPrice:0 page:page rows:kPageSize finished:^(BOOL success, NSData *response)
     {
         [_tableView headerEndRefreshing];
         [_tableView footerEndRefreshing];
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
                         [_terminalItems removeAllObjects];
                         [_terminalList removeAllObjects];
                     }
                     id list = [object objectForKey:@"result"];
                     if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                         //有数据
                         _page++;
                         [hud hide:YES];
                     }
                     else {
                         //无数据
                         hud.labelText = @"没有更多数据了...";
                     }
                     [self parseSearchListWithData:object];
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


//终端
- (void)searchTerminalWithArray:(NSArray *)array {
    
     //NSLog(@"terminals:%@",terminals);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface batchTerminalNumWithtoken:delegate.token agentId:delegate.agentID serialNum:array finished:^(BOOL success, NSData *response) {
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
                    
                    [self parseSearchListWithData:object];
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




//搜索终端
- (void)searchTerminalWithString:(NSString *)title {
    NSMutableArray *terminals = [[NSMutableArray alloc] init];
    if (title && ![title isEqualToString:@""]) {
        [terminals addObject:title];
    }
    NSLog(@"terminals:%@",terminals);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface batchTerminalNumWithtoken:delegate.token agentId:delegate.agentID serialNum:terminals finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
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
                    [self parseSearchListWithData:object];
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

- (void)parseSearchListWithData:(NSDictionary *)dict {
   // if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
     //   return;
   // }
    //[ _terminalList removeAllObjects];
    NSArray *serialList = [dict objectForKey:@"result"];
    for (int i = 0; i < [serialList count]; i++) {
        id TerminalDict = [serialList objectAtIndex:i];
        if ([TerminalDict isKindOfClass:[NSDictionary class]]) {
            TerminalSelectModel *model = [[TerminalSelectModel alloc] initWithParseDictionary:TerminalDict];
            [_terminalList addObject:model];
        }
    }
    [_tableView reloadData];
    [self refreshSelectedInfo];
   
}




#pragma mark - Data-POS

- (void)parsePOSDataWithDictionary:(NSDictionary *)dict {
    
    //if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
    //    return;
   // }
   // NSDictionary *infoDict = [dict objectForKey:@"result"];
    _POSArray=[dict objectForKey:@"result"];
    _POStitle=[NSString stringWithFormat:@"%@", [_POSArray[0] objectForKey:@"title"]];
    [self pickerDisplay:_POSTV];

    
}

#pragma mark - Data-channel

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *list = [dict objectForKey:@"result"];
    [self pickerDisplay:_channelTV];
    [_channelItems removeAllObjects];
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *channelDict = [list objectAtIndex:i];
        ChannelListModel *model = [[ChannelListModel alloc] initWithParseDictionary:channelDict];
        [_channelItems addObject:model];
        NSLog(@"_channelItem:%@",_channelItems);
      
    }
    
    [_pickerView reloadAllComponents];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalList.count;
}


- (CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //内容Cell
    static NSString *identifier = @"Terminal";
    TerminalSelectModel *model = [_terminalList objectAtIndex:indexPath.row];
    TerminalSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TerminalSelectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setTerminalSelectModel:model andTarget:self];
 
    return cell;
}





-(void)modifyStatus:(id)sender
{
    if (pickerstatus==100) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
       _POSTV.text=[NSString stringWithFormat:@"%@"
                   , [[_POSArray objectAtIndex:index] objectForKey:@"title"]];
       
       
    }
    else
    {
       
        NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
        NSInteger secondIndex = [_pickerView selectedRowInComponent:1];
        ChannelListModel *channel = nil;
        BillingModel *model = nil;
        if (firstIndex < [_channelItems count]) {
            channel = [_channelItems objectAtIndex:firstIndex];
            _channelsId=[channel.channelID intValue];
        }
        if (secondIndex < [_pickerArray count]) {
            model = [_pickerArray objectAtIndex:secondIndex];
        }
        if (model==nil) {
            _channelTV.text=[NSString stringWithFormat:@"%@",channel.channelName];
            
        }
        else
        {
           _channelTV.text= [NSString stringWithFormat:@"%@ %@",channel.channelName,model.billName];
        }
       
    }
    [self pickerHide];
    [self firstLoadData];

}

#pragma mark - UIPickerView


- (void)pickerDisplay:(id)sender{
    
    NSLog(@"pickerDiplay");
    
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyStatus:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(0, 0, 0, 42) inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
    
}


- (void)pickerHide
{
    
    [_popViewController dismissPopoverAnimated:NO];
    
}




#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerstatus==100) {
        return 1;
    }
    else
    {
    return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (pickerstatus==100) {
        
      return _POSArray.count;
        
    }
    
    else
    {
        if (component == 0) {
            return [_channelItems count];;
        }
        else {
            NSInteger channelIndex = [pickerView selectedRowInComponent:0];
            if ([_channelItems count] > 0) {
                ChannelListModel *channel = [_channelItems objectAtIndex:channelIndex];
                _pickerArray = channel.children;
                return [_pickerArray count];
            }
            return 0;
            
        }
        
    }
    
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerstatus==100) {
        
        return [[_POSArray objectAtIndex:row] objectForKey:@"title"];
   
    }
    else
    {
        if (component == 0) {
            //通道
            ChannelListModel *model = [_channelItems objectAtIndex:row];
            return model.channelName;
        }
        else {
            //结算时间
            if ([_pickerArray count] > 0) {
                BillingModel *model = [_pickerArray objectAtIndex:row];
                return model.billName;
            }
            return @"";
            
        }
        
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
     if (pickerstatus==200) {
          if (component == 0) {
              //
               [_pickerView reloadComponent:1];
               }
        }
   }





#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        _placeholderLB.text = @"请输入终端号，终端号之间回车间隔";
    }
    else {
        _placeholderLB.text = @"";
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
