//
//  OpenProfitViewController.m
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/18.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "OpenProfitViewController.h"
#import "OpenProfitTableViewCell.h"
@interface OpenProfitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*allarry;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation OpenProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    //设置间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    
    
    
    UIButton*filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 120, 30);
    
    [filterButton setTitle:@"添加支付通道" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(setOPenProfirclick) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
//    _tableView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame=CGRectMake(wide/2+40, 0,wide/2-40, height);
    
    
    [self.view addSubview:_scrollView];
    [self createui];
    
    // Do any additional setup after loading the view.
}
-(void)createui
{    CGFloat wide;
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
    NSArray*namesarry=[NSArray arrayWithObjects:@"消费",@"转账",@"还款",@"话费充值",@"生活充值",nil];


    for(int i=0;i<5;i++)
    {
    
    
    
        
        UILabel*openlable=[[UILabel alloc]initWithFrame:CGRectMake(0,i*60+20,80, 40)];
        [_scrollView addSubview:openlable];
//        openlable.textAlignment = NSTextAlignmentRight;
        //    newaddress.font=[UIFont systemFontOfSize:18];
        
        openlable.text=[namesarry objectAtIndex:i];
        neworiginaltextfield=[[UITextField alloc]init];
        
        neworiginaltextfield.frame = CGRectMake(80,  i*60+20,280, 40);
        neworiginaltextfield.userInteractionEnabled=NO;
        neworiginaltextfield.placeholder=@"12";
        
        neworiginaltextfield.delegate=self;
        
        neworiginaltextfield.tag=i+1056;
        neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_scrollView addSubview:neworiginaltextfield];
    
    }

    UIButton* savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(0,340,80, 40);
    
    
   
    
    
    [savebutton setTitle:@"编辑" forState:UIControlStateNormal];
    
    //            [addressbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savebutton setBackgroundImage:kImageName(@"blue") forState:UIControlStateNormal];
    
    
    [savebutton addTarget:self action:@selector(openprofitclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:savebutton];



}
-(void)openprofitclick
{

  
    
        for(int i=0;i<5;i++)
        {
            UITextField*text=(UITextField*)[self.view viewWithTag:i+1056];
            

            text.userInteractionEnabled=YES;
            
            CALayer *layer=[text layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
        }
       
        

     

       

    



}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    OpenProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[OpenProfitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    cell.textLabel.text=@"12";
    [cell.deletebutton addTarget:self action:@selector(deletebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
   


    return cell;
    
    
}
-(void)deletebuttonclick:(UIButton*)send

{





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
