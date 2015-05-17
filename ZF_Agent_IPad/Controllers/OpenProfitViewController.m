//
//  OpenProfitViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "OpenProfitViewController.h"
#import "OpenProfitTableViewCell.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ChannelListModel.h"
#import "CreateBenefitController.h"
#import "RegularFormat.h"

#import "BenefitModel.h"
@interface OpenProfitViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*allarry;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSMutableArray *dataItem;
@property (nonatomic, strong) NSMutableArray *channelList;

@end

@implementation OpenProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"选择支付通道";
    
    _dataItem = [[NSMutableArray alloc] init];
    _channelList = [[NSMutableArray alloc] init];
    [self getBenefitList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshBenefitList)
                                                 name:@"refresh"
                                               object:nil];    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    

    
    UIButton*filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 120, 30);
    
    [filterButton setTitle:@"添加支付通道" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(addBenefit:) forControlEvents:UIControlEventTouchUpInside];
    
    
    spaceItem.width = 52;
    UIBarButtonItem *shoppingItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,shoppingItem,spaceItem,spaceItem,nil];

    
    
    
    _allarry=[[NSMutableArray alloc]initWithCapacity:0];

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

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, wide/2,height ) style: UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [self initPickerView];

//    _tableView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    // Do any additional setup after loading the view.
}

-(void)refreshBenefitList
{

    [self getBenefitList];



}
- (IBAction)addBenefit:(id)sender {
    CreateBenefitController *createC = [[CreateBenefitController alloc] init];
//    createC.channel = channel;
    createC.subAgentID = _subAgentID;
    createC.hidesBottomBarWhenPushed=YES;
    createC.datearry=_dataItem;
    
    [self.navigationController pushViewController:createC animated:YES];

//    if ([_channelList count] <= 0) {
//        [self getChannelList];
//    }
//    else {
//        [self pickerScrollIn];
//    }
// 
}



- (void)initPickerView {
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
    

    
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height, wide, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    
    
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(selectedChannelss:)];
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height, wide, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
    
}
- (IBAction)selectedChannelss:(id)sender {
    NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
    ChannelListModel *channel = nil;
    if (firstIndex < [_channelList count]) {
        channel = [_channelList objectAtIndex:firstIndex];
    }
    [self addBenefitForChannel:channel];
}
- (void)addBenefitForChannel:(ChannelListModel *)channel {
    for (BenefitModel *model in _dataItem) {
        if ([model.ID isEqualToString:channel.channelID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"该通道已设置过分润";
            return;
        }
    }
    CreateBenefitController *createC = [[CreateBenefitController alloc] init];
    createC.channel = channel;
    createC.subAgentID = _subAgentID;
    createC.hidesBottomBarWhenPushed=YES;
    createC.datearry=_dataItem;
    
    [self.navigationController pushViewController:createC animated:YES];

}



#pragma mark - Request

//支付通道
- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAgentChannelListWithToken:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseChannelListWithDictionary:object];
                    [self pickerScrollIn];
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


- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_channelList removeAllObjects];
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [list count]; i++) {
            id channelDict = [list objectAtIndex:i];
            if ([channelDict isKindOfClass:[NSDictionary class]]) {
                
              

                ChannelListModel *model = [[ChannelListModel alloc] init];
                if ([channelDict objectForKey:@"id"]) {
                    model.channelID = [NSString stringWithFormat:@"%@",[channelDict objectForKey:@"id"]];
                }
                if ([channelDict objectForKey:@"name"]) {
                    model.channelName = [NSString stringWithFormat:@"%@",[channelDict objectForKey:@"name"]];
                }
                [_channelList addObject:model];
            }
        }
    }
    [_pickerView reloadAllComponents];
}
#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_channelList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //通道
    ChannelListModel *model = [_channelList objectAtIndex:row];
    return model.channelName;
}

- (void)pickerScrollIn {
    
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

    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height - 260, wide, 44);
        _pickerView.frame = CGRectMake(0, height - 216, wide, 216);
    }];
    _scrollView.userInteractionEnabled=YES;
    
    [_scrollView sendSubviewToBack:_toolbar];

}

- (void)pickerScrollOut {
    
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

    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height, wide, 44);
        _pickerView.frame = CGRectMake(0, height, wide, 216);
    }];
}


//删除分润
- (void)deleteBenefitWithModel:(BenefitModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteBenefitWithAgentID:delegate.agentID token:delegate.token subAgentID:_subAgentID channelID:model.ID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
                    [self getBenefitList];
                    [self createui];
                    
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

- (void)getBenefitList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getBenefitListWithToken:delegate.token subAgentID:_subAgentID finished:^(BOOL success, NSData *response) {
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
                    [self parseBenefitListWithDictionary:object];
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

- (void)parseBenefitListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    numberint=0;
    
    [_dataItem removeAllObjects];
    id list = [[dict objectForKey:@"result"] objectForKey:@"list"];
    if ([list isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [list count]; i++) {
            id benefitDict = [list objectAtIndex:i];
            if ([benefitDict isKindOfClass:[NSDictionary class]]) {
                BenefitModel *model = [[BenefitModel alloc] initWithParseDictionary:benefitDict];
                [_dataItem addObject:model];
            }
        }
    }
    
    if(_dataItem.count>0)
    {
        [self createui];
        [_tableView reloadData];

    
    }

}

-(void)createui
{
    
 

    
    [_scrollView removeFromSuperview];
    
    
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
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame=CGRectMake(wide/2+40, 0,wide/2-40, height);
    _scrollView.userInteractionEnabled=YES;
    self.view.userInteractionEnabled=YES;

    
    [self.view addSubview:_scrollView];
    BenefitModel *model = [_dataItem objectAtIndex:numberint];

//    NSArray*namesarry=[NSArray arrayWithObjects:@"消费",@"转账",@"还款",@"话费充值",@"生活充值",nil];


    for(int i=0;i<model.tradeList.count;i++)
    {
    
        TradeTypeModel *tradeModel = [model.tradeList objectAtIndex:i];

    
        
        UILabel*openlable=[[UILabel alloc]initWithFrame:CGRectMake(0,i*60+20,80, 40)];
        [_scrollView addSubview:openlable];
//        openlable.textAlignment = NSTextAlignmentRight;
        //    newaddress.font=[UIFont systemFontOfSize:18];
        
        openlable.text=tradeModel.tradeName;
        neworiginaltextfield=[[UITextField alloc]init];
        
        neworiginaltextfield.frame = CGRectMake(80,  i*60+20,280, 40);
        neworiginaltextfield.userInteractionEnabled=YES;
        neworiginaltextfield.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *v = [[UIView alloc]init];
        v.frame = CGRectMake(0, 0, 10, 40);
        neworiginaltextfield.leftView = v;
        CALayer *layer=[neworiginaltextfield layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        
        //设置边框线的宽
        //
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:[[UIColor grayColor] CGColor]];
        
        neworiginaltextfield.placeholder=[NSString stringWithFormat:@"%.1f%%",tradeModel.percent];
        
//        neworiginaltextfield.delegate=self;
        
        neworiginaltextfield.tag=i+1056;
        neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_scrollView addSubview:neworiginaltextfield];
    
    }

    
    if(model.tradeList.count!=0)
    {
    
        UIButton* savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        savebutton.frame = CGRectMake(0,340,120, 40);
        
        
        
        
        
        [savebutton setTitle:@"保存" forState:UIControlStateNormal];
        
        //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
        
        
        [savebutton addTarget:self action:@selector(openprofitclick) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:savebutton];
        

    }
    

}
- (void)modityBenefit {
    
    
    
    
    
    BenefitModel *model = [_dataItem objectAtIndex:numberint];
    
    //    NSArray*namesarry=[NSArray arrayWithObjects:@"消费",@"转账",@"还款",@"话费充值",@"生活充值",nil];
    
    NSString *string = nil;
    NSString *lastString = @"";
    for(int i=0;i<model.tradeList.count;i++)
    {
        
        TradeTypeModel *tradeModel = [model.tradeList objectAtIndex:i];
        UITextField*textfield=(UITextField*)[self.view viewWithTag:i+1056];
        
        
        NSString *benefitString = [NSString stringWithFormat:@"%.1f_%@",[textfield.text floatValue],tradeModel.ID];

        
        string = [NSString stringWithFormat:@"%@%@|", lastString, benefitString];
        
        lastString = [NSString stringWithFormat:@"%@", string];
        
    }
    
    
   
   

    
    
    
    
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitBenefitWithAgentID:delegate.agentID token:delegate.token subAgentID:_subAgentID channelID:model.ID profit:lastString type:0 finished:^(BOOL success, NSData *response) {
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
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBenefitListNotification object:nil];
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

-(void)openprofitclick
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

    
    
//    if ([neworiginaltextfield.text floatValue] < 0 ||
//        [neworiginaltextfield.text floatValue] > 100)
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:1.f];
//        hud.labelText = @"分润比例必须介于1-100之间";
//        return;
//
//    }
    
    [self modityBenefit];
    
       

    



}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataItem count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BenefitModel *model = [_dataItem objectAtIndex:indexPath.row];

    static NSString *cellIdentifier = @"Cell";
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    OpenProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[OpenProfitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    cell.textLabel.text=model.channelName;
    [cell.deletebutton addTarget:self action:@selector(deletebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
   
    cell.deletebutton.tag=indexPath.row;

    if(numberint==indexPath.row)
        
    {
        
        
            cell.backgroundColor=[UIColor whiteColor];

        cell.deletebutton.hidden=NO;
        
        
    
    }
    else
    {
        cell.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1];

        cell.deletebutton.hidden=YES;

    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    numberint=indexPath.row;
    
    [self createui];
    [_tableView reloadData];
    
    
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

-(void)deletebuttonclick:(UIButton*)send

{ UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    


    alertint=send.tag;
    
    




}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //回调方法把alert本身传过来是为了区分多个alertView时，哪个alert进行的回调
    
  if (buttonIndex==1)
    {
            BenefitModel *model = [_dataItem objectAtIndex:alertint];
            [self deleteBenefitWithModel:model];
        
            
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
