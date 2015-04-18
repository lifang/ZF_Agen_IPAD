//
//  ApplyDetailController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/10.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ApplyDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyOpenModel.h"
#import "CityHandle.h"
#import "channelListModel.h"
#import "MerchantDetailModel.h"
#import "MerchantSelecteViewController.h"
#import "BnakSelectViewController.h"
#import "BankModel.h"


#define kTextViewTag   111

@interface ApplyInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) MaterialType type;

@end

@implementation ApplyInfoCell

@end

@interface InputTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation InputTextField


@end

@interface ApplyDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,ApplyMerchantSelectedDelegate,BankSelectedDelegate>

@property(nonatomic,strong) UIPopoverController *popViewController;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong)NSString *startTime;

@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私

@property (nonatomic, strong) ApplyOpenModel *applyData;

@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property (nonatomic, strong) UIView *scrollView;
@property (nonatomic, strong) NSMutableArray *bankItems;//银行信息

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;
@property (nonatomic, assign) CGRect imageRect;

//用于记录点击的是哪一行
@property (nonatomic, strong) NSString *selectedKey;

@property (nonatomic, strong) UIPickerView *pickerView;


@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property(nonatomic,strong)UITableView *terminalTableView;

@property (nonatomic, strong) NSString *merchantID;
@property (nonatomic, strong) NSString *bankID;  //银行代码
@property (nonatomic, strong) NSString *channelID; //支付通道ID
@property (nonatomic, strong) NSString *billID;    //结算日期ID

//无作用 就是用来去掉cell中输入框的输入状态
@property (nonatomic, strong) UITextField *tempField;

@property (nonatomic, strong) NSMutableArray *channelItems;

@property (nonatomic, strong) NSString *masterChannel;
@property (nonatomic, strong) NSString *branchChannel;

@end

@implementation ApplyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _bankItems = [[NSMutableArray alloc] init];
    _channelItems = [[NSMutableArray alloc] init];
    
    keynamesarry=[NSArray arrayWithObjects:@"key_name",@"key_merchantName",@"key_sex",@"key_birth",@"key_cardID",@"key_phone",@"key_email",@"key_location",@"key_bank",@"key_bankID",@"key_bankAccount",@"key_taxID",@"key_organID",@"key_channel", nil];
    //Do any additional setup after loading the view.
    _applyType = OpenApplyPublic;
    _infoDict = [[NSMutableDictionary alloc] init];
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [self.view addSubview:_tempField];
    
    
    if (iOS7)
        
    {    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_HEIGHT,
                                                                    SCREEN_WIDTH) style:UITableViewStyleGrouped];
        
        
    }
    else
    {    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        
    }
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self beginApply];
 //   [self getBankList];
    
}

//选择终端tableView加载
-(UITableView *)terminalTableView
{
    if (!_terminalTableView) {
        _terminalTableView = [[UITableView alloc]init];
        _terminalTableView.tag = 1111;
        _terminalTableView.delegate = self;
        _terminalTableView.dataSource = self;
    }
    return _terminalTableView;
}
//创建选择终端tableView
-(void)setupTerminalTableView
{
    if(sexint==102)
    {
        self.terminalTableView.frame = CGRectMake(_cityField.frame.origin.x, _cityField.frame.origin.y+_cityField.frame.size.height, 280, 80);
        
    }
    else
    {
        
        NSInteger numberrow;
        numberrow=_applyData.merchantList.count;
        if(numberrow>5)
        {
            self.terminalTableView.frame = CGRectMake(accountnamebutton.frame.origin.x, 90, 280, 5*45);
            
        }else
        {
            self.terminalTableView.frame = CGRectMake(accountnamebutton.frame.origin.x, 90, 280, numberrow*45);
            
            
        }
    }
       [_scrollView addSubview:_terminalTableView];
    if (_applyData.merchantList.count != 0) {
        [_terminalTableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(sexint==102)
    {
        
        [_infoDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:key_sex];
        NSString *accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:key_sex]];
        
        if([accountname isEqualToString:@"0"])
        {
            [_cityField setTitle:@"女" forState:UIControlStateNormal];
            
        }else
        {
            
            [_cityField setTitle:@"男" forState:UIControlStateNormal];
            
            
        }
        
    }
    else
    {
        MerchantModel *model = [_applyData.merchantList objectAtIndex:indexPath.row];
        [_infoDict setObject:model.merchantName forKey:key_selected];
        [self beginApply];
    
    }
    
    
    //终端选择跳转
    if (tableView==_terminalTableView) {
        
        [_terminalTableView removeFromSuperview];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    NSInteger lastheightY;
    lastheightY=_applyData.materialList.count-2;
    
    lastheightY=_applyData.materialList.count/3;
    
    _scrollView = [[UIView alloc]init];
    
    if (iOS7)
        
    {
        
        _scrollView.frame = CGRectMake(0, 0, SCREEN_HEIGHT,
                                       700+lastheightY*70);
    }
    else
    {
        
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,
                                       500+lastheightY*70);
        
        
    }
    
    
    NSArray*namesarry=[NSArray arrayWithObjects:@"姓              名",@"店   铺  名   称",@"性              别",@"选   择   生  日",@"身  份  证  号",@"联   系  电  话",@"邮              箱",@"所      在     地",@"结算银行名称",@"结算银行代码",@"结算银行账户",@"税务登记证号",@"组 织 机 构 号",@"支  付   通  道", nil];
    
    CGFloat borderSpace = 40.f;
    CGFloat topSpace = 10.f;
    CGFloat labelHeight = 20.f;
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
    
    
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace+20, wide/2 - borderSpace , labelHeight)];
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_brandLabel];
    
    _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight+20, wide/2 - borderSpace, labelHeight)];
    _modelLabel.backgroundColor = [UIColor clearColor];
    _modelLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_modelLabel];
    
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 2+20, wide/2 - borderSpace, labelHeight)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    _terminalLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_terminalLabel];
    
    UILabel*accountnamelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2,topSpace + labelHeight * 2,140, 40)];
    [_scrollView addSubview:accountnamelable];
    accountnamelable.textAlignment = NSTextAlignmentCenter;
    accountnamelable.font=[UIFont systemFontOfSize:19];
    
    accountnamelable.text=@"选择已有商户";
    
    accountnamebutton= [UIButton buttonWithType:UIButtonTypeCustom];
    accountnamebutton.frame = CGRectMake(150+wide/2,  topSpace + labelHeight * 2,280, 40);
    
    //NSString *accountname=[_infoDict objectForKey:key_selected];
     NSString *accountname=[_infoDict objectForKey:@"key_merchantName"];
    
    [accountnamebutton setTitle:accountname forState:UIControlStateNormal];
    [accountnamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    accountnamebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [accountnamebutton setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    accountnamebutton.layer.masksToBounds=YES;
    accountnamebutton.layer.borderWidth=1.0;
    accountnamebutton.layer.borderColor=[UIColor grayColor].CGColor;
    accountnamebutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0,0);
    accountnamebutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    [accountnamebutton addTarget:self action:@selector(accountnamebuttonclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:accountnamebutton];
    
    _brandLabel.text = [NSString stringWithFormat:@"POS品牌   %@",_applyData.brandName];
    _modelLabel.text = [NSString stringWithFormat:@"POS型号   %@",_applyData.modelNumber];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号   %@",_applyData.terminalNumber];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",_applyData.channelName];
    
    UILabel*firestline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 4+30, wide - 138, 1)];
    firestline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:firestline];
    
    
    for(int i=0;i<namesarry.count;i++)
    {
        NSInteger row;
        row=i%2;
        NSInteger height;
        
        height=i/2;
        if(i>7)
        {
            topSpace=40;

        }
        UILabel *newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*row, height*70+topSpace + labelHeight * 7,140, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentCenter;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry objectAtIndex:i];
        
        if(i==2)
        {
            _cityField = [UIButton buttonWithType:UIButtonTypeCustom];
            _cityField.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            
            if([accountname isEqualToString:@"0"])
            {
                [_cityField setTitle:@"女" forState:UIControlStateNormal];
                
                
            }else
            {
                
                [_cityField setTitle:@"男" forState:UIControlStateNormal];
                
                
            }
            
            [_cityField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _cityField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_cityField setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            _cityField.layer.masksToBounds=YES;
            _cityField.layer.borderWidth=1.0;
            _cityField.layer.borderColor=[UIColor grayColor].CGColor;
            _cityField.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            _cityField.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [_cityField addTarget:self action:@selector(sexclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_cityField];
        }
        else if(i==3)
        {
            birthdaybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            birthdaybutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            
            [birthdaybutton setTitle:accountname forState:UIControlStateNormal];
            [birthdaybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            birthdaybutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [birthdaybutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            birthdaybutton.layer.masksToBounds=YES;
            birthdaybutton.layer.borderWidth=1.0;
            birthdaybutton.layer.borderColor=[UIColor grayColor].CGColor;
            birthdaybutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            birthdaybutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [birthdaybutton addTarget:self action:@selector(birthdaybuttonclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:birthdaybutton];
        }
        else if(i==7)
        {
            locationbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            locationbutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            
            NSString*strId=[_infoDict objectForKey:[keynamesarry objectAtIndex:i]];
            
            NSString*accountname= [CityHandle getCityNameWithCityID:strId];
            
            [locationbutton setTitle:accountname forState:UIControlStateNormal];
            [locationbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            locationbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [locationbutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            locationbutton.layer.masksToBounds=YES;
            locationbutton.layer.borderWidth=1.0;
            locationbutton.layer.borderColor=[UIColor grayColor].CGColor;
            locationbutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            locationbutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [locationbutton addTarget:self action:@selector(locationbuttonclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:locationbutton];
        }
        else if(i==8)
        {
            bankNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bankNameBtn.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            
            NSString *accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            [bankNameBtn setTitle:accountname forState:UIControlStateNormal];
            [bankNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bankNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [bankNameBtn setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            bankNameBtn.layer.masksToBounds=YES;
            bankNameBtn.layer.borderWidth=1.0;
            bankNameBtn.layer.borderColor=[UIColor grayColor].CGColor;
            bankNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            bankNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [bankNameBtn addTarget:self action:@selector(bankNameBtnclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:bankNameBtn];
        }
        else if (i==9)
        {
             bankIdTF=[[UITextField alloc]initWithFrame:CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40)];
             bankIdTF.delegate=self;
            
             bankIdTF.tag=i+1056;
             NSString *bankIdname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
             bankIdTF.text=[NSString stringWithFormat:@"  %@",bankIdname];
             bankIdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
             [_scrollView addSubview: bankIdTF];
             bankIdTF.layer.masksToBounds=YES;
             bankIdTF.layer.borderWidth=1.0;
             bankIdTF.layer.borderColor=[UIColor grayColor].CGColor;
            
        }
        
        else if(i==13)
        {
            zhifubutton = [UIButton buttonWithType:UIButtonTypeCustom];
            zhifubutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            NSString *accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            
            [zhifubutton setTitle:accountname forState:UIControlStateNormal];
            [zhifubutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            zhifubutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [zhifubutton setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
            zhifubutton.layer.masksToBounds=YES;
            zhifubutton.layer.borderWidth=1.0;
            zhifubutton.layer.borderColor=[UIColor grayColor].CGColor;
            zhifubutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            zhifubutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [zhifubutton addTarget:self action:@selector(zhifuclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:zhifubutton];
        }
        
        else
        {
            UITextField *neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40)];
            neworiginaltextfield.delegate=self;
            
            neworiginaltextfield.tag=i+1056;
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            neworiginaltextfield.text=[NSString stringWithFormat:@"  %@",accountname];
            neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_scrollView addSubview:neworiginaltextfield];
            neworiginaltextfield.layer.masksToBounds=YES;
            neworiginaltextfield.layer.borderWidth=1.0;
            neworiginaltextfield.layer.borderColor=[UIColor grayColor].CGColor;

            if(i==1)
            {
                
                UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(200+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7+45,280, 20)];
                [_scrollView addSubview:newaddress];
                newaddress.textAlignment = NSTextAlignmentLeft;
                newaddress.font=[UIFont systemFontOfSize:12];
                newaddress.text=@"例：上海好乐迪KTV";
            }
            
            
        }
        
        
    }
    
    
    
    UILabel*twoline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18,  4*70+topSpace + labelHeight *5+10, wide - 138, 1)];
    twoline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:twoline];
    UILabel*threeline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18,  670, wide - 138, 1)];
    threeline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:threeline];
    NSInteger imageint;
    imageint=0;
    
    for(int i=0;i<_applyData.materialList.count;i++)
    {
        
        NSInteger row;
        row=i%2;
        NSInteger height;
        
        height=i/2;
        MaterialModel *model = [_applyData.materialList objectAtIndex:i];
        if (model.materialType == MaterialList) {
            
            NSInteger lastheight;
            lastheight=_applyData.materialList.count-2;
            if(lastheight%3==0)
            {
                lastheight=_applyData.materialList.count/3;
                
            }
            else
            {
                
                lastheight=_applyData.materialList.count/3+1;
                
            }
            //选项 银行
            UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40, 710+lastheight*70,140, 40)];
            [_scrollView addSubview:newaddress];
            newaddress.textAlignment = NSTextAlignmentCenter;
            newaddress.font=[UIFont systemFontOfSize:18];
            
            newaddress.text=model.materialName;
            
            
            bankbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            bankbutton.frame = CGRectMake(wide/2-40-280,710+lastheight*70 ,280, 40);
           // NSString *bankCode = [self getApplyValueForKey:model.materialID];
           // [bankbutton setTitle:[self getBankNameWithBankCode:bankCode] forState:UIControlStateNormal];
            
            
            // [_cityField setTitle:@"123" forState:UIControlStateNormal];
            [bankbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bankbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [bankbutton setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
            bankbutton.layer.masksToBounds=YES;
            bankbutton.layer.borderWidth=1.0;
            bankbutton.layer.borderColor=[UIColor grayColor].CGColor;
            bankbutton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            bankbutton.imageEdgeInsets = UIEdgeInsetsMake(0,220,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            bankbutton.tag=[model.materialID integerValue];
            
            [bankbutton addTarget:self action:@selector(bankclick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:bankbutton];
            
            
        }
        else if (model.materialType == MaterialText)
        {
            
            NSMutableArray*typeArry=[[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray*MaterialTexttypeArry=[[NSMutableArray alloc]initWithCapacity:0];
            
            for(int i=0;i<_applyData.materialList.count;i++)
                
                
            {
                MaterialModel *model = [_applyData.materialList objectAtIndex:i];
                
                [typeArry addObject:[NSString stringWithFormat:@"%u",model.materialType] ];
                
                if(model.materialType==MaterialText)
                {
                    
                    [MaterialTexttypeArry addObject:model ];
                    
                    
                }
                
            }
            
            if ([typeArry containsObject: @"3"])
                
                
                
                
            {
                
                
                NSInteger lastheight;
                lastheight=_applyData.materialList.count-2;
                if(lastheight%3==0)
                {
                    lastheight=_applyData.materialList.count/3;
                    
                }
                else
                {
                    
                    lastheight=_applyData.materialList.count/3+1;
                    
                }
                for(int i=1;i<MaterialTexttypeArry.count+1;i++)
                    
                {
                    NSInteger LR=i%2;
                    MaterialModel *model = [MaterialTexttypeArry objectAtIndex:i-1];
                    
                    //文字
                    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(wide/2*LR, 700+lastheight*70+i/2*50+10,140, 40)];
                    [_scrollView addSubview:newaddress];
                    newaddress.textAlignment = NSTextAlignmentCenter;
                    newaddress.font=[UIFont systemFontOfSize:18];
                    
                    newaddress.text=model.materialName;
                    UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(wide/2*LR+150,700+lastheight*70+i/2*50+10,280, 40)];
                    neworiginaltextfield.tag=i+1056;
                    
                    [_scrollView addSubview:neworiginaltextfield];
                    //neworiginaltextfield.delegate=self;
                    neworiginaltextfield.layer.masksToBounds=YES;
                    neworiginaltextfield.layer.borderWidth=1.0;
                    neworiginaltextfield.layer.borderColor=[UIColor grayColor].CGColor;
                    
                    
                }
                
            }
            else
            {
                
                NSInteger lastheight;
                lastheight=_applyData.materialList.count-2;
                if(lastheight%3==0)
                {
                    lastheight=_applyData.materialList.count/3;
                    
                }
                else
                {
                    
                    lastheight=_applyData.materialList.count/3+1;
                    
                }
                for(int i=0;i<MaterialTexttypeArry.count;i++)
                    
                {
                    
                    
                    NSInteger LR=i%2;
                    MaterialModel *model = [MaterialTexttypeArry objectAtIndex:i];
                    
                    //文字
                    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40+wide/2*LR, 700+lastheight*70+i/2*50+10,140, 40)];
                    [_scrollView addSubview:newaddress];
                    newaddress.textAlignment = NSTextAlignmentCenter;
                    newaddress.font=[UIFont systemFontOfSize:18];
                    
                    newaddress.text=model.materialName;
                    UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(wide/2*LR+190,700+lastheight*70+i/2*50+10,280, 40)];
                    neworiginaltextfield.tag=i+1056;
                    
                    [_scrollView addSubview:neworiginaltextfield];
                    //neworiginaltextfield.delegate=self;
                    neworiginaltextfield.layer.masksToBounds=YES;
                    neworiginaltextfield.layer.borderWidth=1.0;
                    neworiginaltextfield.layer.borderColor=[UIColor grayColor].CGColor;
                    
                }
            }
        }
        else if (model.materialType == MaterialImage) {
            NSInteger row;
            row=imageint%3;
            NSInteger heightlk;
            
            heightlk=imageint/3;
            UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide-80)/3*row, 700+heightlk*70,(wide-80)/3-142, 40)];
            [_scrollView addSubview:newaddress];
            newaddress.textAlignment = NSTextAlignmentLeft;
            newaddress.font=[UIFont systemFontOfSize:18];
            
            newaddress.text=model.materialName;
            UIButton*imagebutton= [UIButton buttonWithType:UIButtonTypeCustom];
            imagebutton.frame=CGRectMake(40+(wide-80)/3*row+(wide-80)/3-142, 700+heightlk*70,100, 40);
            imagebutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
            [imagebutton addTarget:self action:@selector(imageclick:) forControlEvents:UIControlEventTouchUpInside];
            imagebutton.tag=[model.materialID integerValue];
            [self getApplyValueForKey:model.materialID];
            if ([_infoDict objectForKey:model.materialID] && ![[_infoDict objectForKey:model.materialID] isEqualToString:@""])
            {    [imagebutton setImage:[UIImage imageNamed:@"haveImage.png"] forState:UIControlStateNormal];
                
            }
            else {
                [imagebutton setTitle:@"上传图片" forState:UIControlStateNormal];
                imagebutton.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
                
            }
            
            [_scrollView addSubview:imagebutton];
            
            imageint++;
            
        }
        
        
    }
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 700+lastheightY*70+80, 160, 40);
    submitBtn.center=CGPointMake(wide/2, 700+lastheightY*70+150);
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.backgroundColor=[UIColor colorWithHexString:@"006fd5"];
    [submitBtn addTarget:self action:@selector(submitApply:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    _scrollView.userInteractionEnabled=YES;
    return _scrollView;
    
    
}
#pragma mark - UI
#pragma mark - 点击事件

//上传图片
-(void)imageclick:(UIButton*)send

{
    _imageRect = [[send superview] convertRect:send.frame toView:self.view];
    
    
    _selectedKey =[NSString stringWithFormat:@"%d", send.tag];
    
    [self showImageOption];
    
}
-(void)zhifuclick
{
    
    sexint=105;
    [self getChannelList];
    [self pickerDisplay:zhifubutton];
    
}

-(void)bankclick:(UIButton*)send
{
    BnakSelectViewController *BnakSC=[[BnakSelectViewController alloc] init];
    BnakSC.delegate=self;
    BnakSC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:BnakSC animated:YES];
  
}
//选择所在地

-(void)locationbuttonclick
{
    sexint=101;
    _selectedKey = key_location;
    [self pickerDisplay:locationbutton];
    
    
}
//选择生日

-(void)birthdaybuttonclick
{
    
    [self setupStartDate ];
    
    
}
//性别

-(void)sexclick
{
    sexint=102;
    [self setupTerminalTableView];
    
}


-(void)accountnamebuttonclick
{
  
    MerchantSelecteViewController *MerchantSC=[[MerchantSelecteViewController alloc] init];
    MerchantSC.delegate=self;
    MerchantSC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:MerchantSC animated:YES];
    
    
}

-(void)bankNameBtnclick
{
    BnakSelectViewController *BnakSC=[[BnakSelectViewController alloc] init];
    BnakSC.delegate=self;
    BnakSC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:BnakSC animated:YES];
}


-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 80);
    }
    //创建头部按钮
    UIButton *publicBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.publickBtn = publicBtn;
    [publicBtn addTarget:self action:@selector(publicClicked) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.backgroundColor = [UIColor clearColor];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setTitle:@"对公" forState:UIControlStateNormal];
    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.4 , 40, 140, 40);
    self.privateY = 40;
    self.publicX = headerView.frame.size.width * 0.4;
    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    [privateBtn addTarget:self action:@selector(privateClicked) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"对私" forState:UIControlStateNormal];
    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 44, 120, 36);
    self.privateX = CGRectGetMaxX(publicBtn.frame);
    [headerView addSubview:privateBtn];
    if(_applyType==OpenApplyPublic)
    {
        [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _publickBtn.frame = CGRectMake(_publicX, _privateY, 140, 40);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 120, 36);
    }else
    {
        [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _privateBtn.frame = CGRectMake(_privateX, _privateY, 140, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 120, 36);
        
    }
    
    
    [self.view addSubview:headerView];
}

#pragma mark - Request


-(void)publicClicked
{
    _applyType = OpenApplyPublic;
    [self beginApply];
}

-(void)privateClicked
{
    _applyType = OpenApplyPrivate;
    _isChecked = NO;
    [self beginApply];
    
}

-(void)setupNavBar
{
    self.title = @"申请开通";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initAndLayoutUI {
    [self setupNavBar];
    [self setupHeaderView];
   
}


- (void)setTextFieldAttr:(InputTextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kTextViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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

#pragma mark - Data

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *list = [dict objectForKey:@"result"];
    [_channelItems removeAllObjects];
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *channelDict = [list objectAtIndex:i];
        ChannelListModel *model = [[ChannelListModel alloc] initWithParseDictionary:channelDict];
        [_channelItems addObject:model];
        NSLog(@"_channelItem:%@",_channelItems);
    }
    [_pickerView reloadAllComponents];
}




- (void)beginApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"YYYYYYYY:%@%@",delegate.token,delegate.agentID);
    
    [NetworkInterface beginToApplyWithToken:delegate.token agentId:delegate.agentID applyStatus:_applyType terminalId:_terminalID finished:^(BOOL success, NSData *response) {
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
                    [self parseApplyDataWithDictionary:object];
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


- (void)submitApplyInfoWithArray:(NSArray *)params {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitApplyWithToken:delegate.token params:params finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"添加成功";
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *applyDict = [dict objectForKey:@"result"];
    
    ApplyOpenModel *model = [[ApplyOpenModel alloc] initWithParseDictionary:applyDict];
    _applyData = model;
    [self setPrimaryData];
    
    [self initAndLayoutUI];
    
    
}
//保存获取的内容
- (void)setPrimaryData {
    if (_applyData.personName) {
        [_infoDict setObject:_applyData.personName forKey:key_name];
    }
    if (_applyData.merchantName) {
        [_infoDict setObject:_applyData.merchantName forKey:key_merchantName];
    }
    if (_applyData.birthday) {
        [_infoDict setObject:_applyData.birthday forKey:key_birth];
    }
    if (_applyData.cardID) {
        [_infoDict setObject:_applyData.cardID forKey:key_cardID];
    }
    if (_applyData.phoneNumber) {
        [_infoDict setObject:_applyData.phoneNumber forKey:key_phone];
    }
    if (_applyData.email) {
        [_infoDict setObject:_applyData.email forKey:key_email];
    }
    if (_applyData.cityID) {
        [_infoDict setObject:_applyData.cityID forKey:key_location];
    }
    if (_applyData.bankName) {
        [_infoDict setObject:_applyData.bankName forKey:key_bank];
    }
    if (_applyData.bankNumber) {
        [_infoDict setObject:_applyData.bankNumber forKey:key_bankID];
    }
    if (_applyData.bankAccount) {
        [_infoDict setObject:_applyData.bankAccount forKey:key_bankAccount];
    }
    if (_applyData.taxID) {
        [_infoDict setObject:_applyData.taxID forKey:key_taxID];
    }
    if (_applyData.organID) {
        [_infoDict setObject:_applyData.organID forKey:key_organID];
    }
    if (_applyData.channelOpenName && _applyData.billingName) {
        [_infoDict setObject:[NSString stringWithFormat:@"%@ %@",_applyData.channelOpenName,_applyData.billingName] forKey:key_channel];
    }
    _channelID = _applyData.channelID;
    _billID = _applyData.billingID;
    
    [_infoDict setObject:[NSNumber numberWithInt:_applyData.sex] forKey:key_sex];
    _merchantID = _applyData.merchantID;
    
    /*之前上传过对公对私资料 保存*/
    for (ApplyInfoModel *model in _applyData.applyList) {
        if (model.value && ![model.value isEqualToString:@""]) {
            [_infoDict setObject:model.value forKey:model.targetID];
        }
    }
    [self.tableView reloadData];
    
}




//根据对公对私材料的id找到是否已经提交过材料
- (NSString *)getApplyValueForKey:(NSString *)key {
    NSLog(@"!!%@,key = %@",[_infoDict objectForKey:key],key);
    if ([_infoDict objectForKey:key] && ![[_infoDict objectForKey:key] isEqualToString:@""]) {
        //setPrimaryData方法中已经保存此值， 若修改则返回修改的值
        return [_infoDict objectForKey:key];
    }
    //    else {
    //        //是否之前提交过
    //        if ([_applyData.applyList count] <= 0) {
    //            return nil;
    //        }
    //        for (ApplyInfoModel *model in _applyData.applyList) {
    //            if ([model.targetID isEqualToString:key]) {
    //                if (model.value && ![model.value isEqualToString:@""]) {
    //                    [_infoDict setObject:model.value forKey:key];
    //                }
    //                return model.value;
    //            }
    //        }
    //    }
    return nil;
}

/*
//根据银行编码获取银行名
- (NSString *)getBankNameWithBankCode:(NSString *)bankCode {
    for (BankModel *model in _bankItems) {
        if ([model.bankCode isEqualToString:bankCode]) {
            return model.bankName;
        }
    }
    return nil;
}
*/


- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

#pragma mark - 上传图片

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadImageWithImage:image finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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


//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}
 
 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [self.popViewController dismissPopoverAnimated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.popViewController dismissPopoverAnimated:NO];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            [self scanBigImage];
            
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        self.popViewController = popover;//对局部UIPopoverController对象popover我们赋给了一个全局的UIPopoverController对象popoverController
        // popover.popoverContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.popViewController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2.0, 0, 0, 42) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
            
        }
        else
        {
            
            [self.popViewController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2.0, 0, 0, 42) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}

#pragma mark - UIImagePickerDelegate
- (void)scanBigImage {
    NSString *urlString = [_infoDict objectForKey:_selectedKey];
   // [self showDetailImageWithURL:urlString imageRect:self.imageRect];
    [self showDetailImageWithURL:urlString imageRect:self.imageRect WithIdentifier:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self.popViewController dismissPopoverAnimated:NO];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 1;
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if(tableView==_terminalTableView)
    {
        if(sexint==102)
        {
            return 2;
        }
        
        else
        {
            NSLog(@"count:::%lu",(unsigned long)_applyData.merchantList.count);
            return _applyData.merchantList.count;
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"cellIdentifier";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    if(tableView==_terminalTableView)
    {
        NSLog(@"%@",_applyData.merchantList);
        NSArray*arry=[NSArray arrayWithObjects:@"女", @"男",nil];
        if(sexint==102)
        {
            
            cell.textLabel.text =[arry objectAtIndex:indexPath.row];
            
            cell.backgroundColor = kColor(214, 214, 214, 1.0);
            
        }else
        {
            MerchantModel *model = [_applyData.merchantList objectAtIndex:indexPath.row];
            cell.textLabel.text = model.merchantName;
            cell.backgroundColor = kColor(214, 214, 214, 1.0);
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==_terminalTableView)
    {
        return 0;
        
    }
    else
    {
        
        NSInteger lastheightY;
        lastheightY=_applyData.materialList.count-2;
        if(lastheightY%3==0)
        {
            lastheightY=_applyData.materialList.count/3;
            
        }
        else
        {
            
            lastheightY=_applyData.materialList.count/3+1;
            
        }
        
        return    1000+lastheightY*70;
        
        
    }
}
//创建开始日期选择器
-(void)setupStartDate
{
    datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake( birthdaybutton.frame.origin.x , birthdaybutton.frame.origin.y+birthdaybutton.frame.size.height, birthdaybutton.frame.size.width , 160);
    
    [datePicker addTarget:self action:@selector(startPick) forControlEvents:UIControlEventValueChanged];
    makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.tag = 1112;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    [_scrollView addSubview:makeSureBtn];
    [_scrollView addSubview:datePicker];
}

-(void)makeSureClick:(UIButton *)button
{
    [makeSureBtn removeFromSuperview];
    [datePicker removeFromSuperview];
    [self startPick];
    
    [_infoDict setObject: self.startTime forKey:key_birth];
    NSString *accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:key_birth]];
    
    [birthdaybutton setTitle:accountname forState:UIControlStateNormal];
    
    
    
    
}

-(void)startPick
{
    self.startTime = [self stringFromDate:datePicker.date];
    
    NSLog(@"%@",self.startTime);
    
}

//将日期转化成字符串yyyy-MM-dd格式
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    if ([dateString length] >= 10) {
        return [dateString substringToIndex:10];
    }
    return dateString;
}

//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}



- (void)submitApply:(id)sender {
    [_tempField becomeFirstResponder];
    [_tempField resignFirstResponder];
    if (![_infoDict objectForKey:key_name]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (![_infoDict objectForKey:key_merchantName]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写店铺名称";
        return;
    }
    if (![_infoDict objectForKey:key_sex]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择性别";
        return;
    }
    if (![_infoDict objectForKey:key_birth]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择生日";
        return;
    }
    if (![_infoDict objectForKey:key_cardID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写身份证号";
        return;
    }
    if (![_infoDict objectForKey:key_phone]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写电话";
        return;
    }
    if (![_infoDict objectForKey:key_email]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![_infoDict objectForKey:key_location]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }
    if (![_infoDict objectForKey:key_bank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行名称";
        return;
    }
    if (![_infoDict objectForKey:key_bankID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行代码";
        return;
    }
    if (![_infoDict objectForKey:key_bankAccount]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行账户";
        return;
    }
    if (![_infoDict objectForKey:key_taxID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写税务登记证号";
        return;
    }
    if (![_infoDict objectForKey:key_organID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写组织机构号";
        return;
    }
    if (!_channelID || !_billID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择支付通道";
        return;
    }
  
    NSMutableArray *paramList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:[_terminalID intValue]] forKey:@"terminalId"];
    [params setObject:[NSNumber numberWithInt:_openStatus] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:[delegate.agentID intValue]] forKey:@"applyCustomerId"];
    [params setObject:[NSNumber numberWithInt:_applyType] forKey:@"publicPrivateStatus"];
    [params setObject:[NSNumber numberWithInt:[_merchantID intValue]] forKey:@"merchantId"];
    [params setObject:[_infoDict objectForKey:key_merchantName] forKey:@"merchantName"];
    [params setObject:[_infoDict objectForKey:key_sex] forKey:@"sex"];
    [params setObject:[_infoDict objectForKey:key_birth] forKey:@"birthday"];
    [params setObject:[_infoDict objectForKey:key_cardID] forKey:@"cardId"];
    [params setObject:[_infoDict objectForKey:key_phone] forKey:@"phone"];
    [params setObject:[_infoDict objectForKey:key_name] forKey:@"name"];
    [params setObject:[_infoDict objectForKey:key_email] forKey:@"email"];
    [params setObject:[NSNumber numberWithInt:[[_infoDict objectForKey:key_location] intValue]] forKey:@"cityId"];
    [params setObject:[NSNumber numberWithInt:[_channelID intValue]] forKey:@"channel"];
    [params setObject:[NSNumber numberWithInt:[_billID intValue]] forKey:@"billingId"];
    [params setObject:[_infoDict objectForKey:key_bankAccount] forKey:@"bankNum"];
    [params setObject:[_infoDict objectForKey:key_bank] forKey:@"bankName"];
    [params setObject:[_infoDict objectForKey:key_bankID] forKey:@"bankCode"];
    [params setObject:[_infoDict objectForKey:key_organID] forKey:@"organizationNo"];
    [params setObject:[_infoDict objectForKey:key_taxID] forKey:@"registeredNo"];
    
    [paramList addObject:params];
    for (MaterialModel *model in _applyData.materialList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *value = nil;
        if (model.materialType == MaterialList) {
            value = _bankID;
        }
        else {
            value = [_infoDict objectForKey:model.materialID];
        }
        [dict setObject:model.materialName forKey:@"Key"];
        if (value) {
            [dict setObject:value forKey:@"Value"];
        }
        [dict setObject:[NSNumber numberWithInt:model.materialType] forKey:@"types"];
        [dict setObject:[NSNumber numberWithInt:[model.materialID intValue]] forKey:@"targetId"];
        [dict setObject:[NSNumber numberWithInt:[model.levelID intValue]] forKey:@"openingRequirementId"];
        [paramList addObject:dict];
    }
    [self submitApplyInfoWithArray:paramList];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //[self pickerScrollOut];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        
        
        [_infoDict setObject:textField.text forKey:[keynamesarry objectAtIndex:textField.tag-1056]];
    }
    
}

#pragma mark - ApplyMerchantSelectedDelegate
//选中商户后 带入商户的一些信息
- (void)getSelectedMerchant:(MerchantDetailModel *)model {
    _merchantID = model.merchantID;
    if (model.merchantPersonName && ![model.merchantPersonName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonName forKey:key_selected];
        [_infoDict setObject:model.merchantPersonName forKey:key_name];
    }
    if (model.merchantName && ![model.merchantName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantName forKey:key_merchantName];
    }
    if (model.merchantPersonID && ![model.merchantPersonID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonID forKey:key_cardID];
    }
    if (model.merchantCityID && ![model.merchantCityID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantCityID forKey:key_location];
    }
    if (model.merchantTaxID && ![model.merchantTaxID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantTaxID forKey:key_taxID];
    }
    if (model.merchantOrganizationID && ![model.merchantOrganizationID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantOrganizationID forKey:key_organID];
    }
    [_tableView reloadData];
}


-(void)displaySelectedMerchant:(MerchantModel *)model{
    
    [accountnamebutton setTitle:model.merchantName forState:UIControlStateNormal];
    NSLog(@"infoDict:%@",_infoDict);

}


#pragma mark - ChannelSelectedDelegate
- (void)getSelectedBank:(BankModel *)model {
    NSLog(@"yinhang");
    if (model) {
         NSLog(@"model:%@",model);
        NSLog(@"model.bank:%@",model.bankName);
    [bankNameBtn setTitle:[NSString stringWithFormat:@"%@",model.bankName] forState:UIControlStateNormal];
    bankIdTF.text=model.bankCode;


        [_infoDict setObject:model.bankCode forKey:@"key_bankID"];
        [_infoDict setObject:model.bankName forKey:@"key_bank"];
        NSLog(@"infoDict:%@",_infoDict);
    }
  
}




#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
  if (sexint==101) {
    
        if (component == 0) {
        return [[CityHandle shareProvinceList] count];
         }
      else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
            }
    
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
                _cityArray = channel.children;
                return [_cityArray count];
            }
            return 0;

        }

    }
    
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (sexint==101) {
       if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
         }
         else {
        //市
           return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
             }
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
            if ([_cityArray count] > 0) {
                BillingModel *model = [_cityArray objectAtIndex:row];
                return model.billName;
            }
            return @"";

        }

    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (sexint==101) {
        [_pickerView reloadComponent:1];
        
    }
    else{
        if (component == 0) {
            //
            
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
            ChannelListModel *model=[_channelItems objectAtIndex:row];
            _masterChannel =model.channelName;
            _channelID=model.channelID;
            
        }else
        {
            if ([_cityArray count] > 0){
                BillingModel *billModel=[_cityArray objectAtIndex:row];
                _branchChannel=billModel.billName;
                _billID=billModel.billID;
            }
        }
    }
}

 
#pragma mark - UIPickerView


- (void)pickerDisplay:(id)sender {
    
    NSLog(@"pickerDiplay");
    
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifySender:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:_toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(120, 0, 0, 42) inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
    
}


- (void)pickerHide
{
    [_popViewController dismissPopoverAnimated:NO];
    
}

- (void)modifySender:(id)sender {
    
    [self pickerHide];
    if (sexint==101) {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
       [locationbutton setTitle:cityName forState:UIControlStateNormal];
       [_infoDict setObject:cityID forKey:key_location];
    }
    else if (sexint==105)
    {
       /*
        NSString  *channelInfo;
        NSLog(@"citynArray:%@",_cityArray);
        NSLog(@"channelItems:%@",_channelItems);
        NSLog(@"channelInfoWUWUWU");
        NSInteger index = [_pickerView selectedRowInComponent:1];
        ChannelListModel *model=[_channelItems objectAtIndex:index];
        BillingModel *billModel=[_cityArray objectAtIndex:index];
        channelInfo = [NSString stringWithFormat:@"%@ %@",model.channelName,billModel.billName];
        [zhifubutton setTitle:channelInfo forState:UIControlStateNormal];
        [_infoDict setObject:channelInfo forKey:key_channel];
        _channelID=model.channelID;
        _billID = billModel.billID;
    */
         NSString  *channelInfo = [NSString stringWithFormat:@"%@ %@",_masterChannel,_branchChannel];
        [zhifubutton setTitle:channelInfo forState:UIControlStateNormal];
        [_infoDict setObject:channelInfo forKey:key_channel];

        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
