//
//  MessageChildViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageChildViewController.h"
#import "NetworkInterface.h"

@interface MessageChildViewController ()<UIAlertViewDelegate>


@property(nonatomic,strong)UIScrollView *contentView;

@property (nonatomic, strong) MessageModel *detail;

@end

@implementation MessageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self getMessageDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    //创建主view
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.backgroundColor = [UIColor whiteColor];
    //创建标题Label
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.numberOfLines = 0;
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.textColor = kColor(56, 56, 56, 1.0);
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont systemFontOfSize:20];
    NSString *topLabelStr = _detail.messageTitle;
    topLabel.text = topLabelStr;
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: topLabel.font};
    CGSize labelsize = [topLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGSize topLabelSize = {0,0};
    topLabelSize = [topLabelStr sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(320.0, 50)];
    topLabel.frame = CGRectMake(180, 40, SCREEN_WIDTH * 0.6, topLabelSize.height);
    if (iOS7) {
        topLabel.frame = CGRectMake(180, 40, SCREEN_HEIGHT * 0.6, labelsize.height);
    }
    [contentView addSubview:topLabel];
    //创建时间Label
    UILabel *timeLabel = [[UILabel alloc]init];
    NSString *timeStr = _detail.messageTime;
    timeLabel.text = timeStr;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = kColor(107, 107, 107, 1.0);
    timeLabel.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(topLabel.frame) + 10, 140, 20);
    [contentView addSubview:timeLabel];
    //创建分隔线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = kMainColor;
    lineView.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(timeLabel.frame) + 10 , topLabel.frame.size.width, 1);
    [contentView addSubview:lineView];
    //创建正文Label
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textColor = kColor(81, 81, 81, 1.0);
    textLabel.font = [UIFont systemFontOfSize:18];
    NSString *contentStr = _detail.messageContent;
    textLabel.text = contentStr;
    CGSize textLabelSize = {0,0};
    textLabelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(topLabel.frame.size.width, 5000)];
    textLabel.numberOfLines = 0;
    textLabel.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 10 , topLabel.frame.size.width, textLabelSize.height);
    [contentView addSubview:textLabel];
    [self.view addSubview:contentView];
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(textLabel.frame) + 30);
    if (iOS7) {
        contentView.contentSize = CGSizeMake(SCREEN_HEIGHT, CGRectGetMaxY(textLabel.frame) + 30);
    }
    self.contentView = contentView;

}

-(void)setupNavBar
{
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn setImage:[UIImage imageNamed:@"laji"] forState:UIControlStateNormal];
    UIBarButtonItem *kongBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    kongBar.width = 30.f;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    NSArray *rightArr = [NSArray arrayWithObjects:kongBar,rightBar, nil];
    self.navigationItem.rightBarButtonItems = rightArr;
}

-(void)rightClicked:(id)sender
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定要删除这条消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.delegate = self;
    alertV.tag = 11144;
    [alertV show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11144) {
        if (buttonIndex == 1) {
            [self deleteMessage:nil];
        }
    }
}

#pragma mark - Action

- (IBAction)deleteMessage:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteSingleMessageWithAgentID:delegate.agentUserID token:delegate.token messageID:_message.messageID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"消息删除成功";
                    //更新列表
                    [self updateMessageListWithDelete];
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


-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Request

- (void)getMessageDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMyMessageDetailWithAgentID:delegate.agentUserID token:delegate.token messageID:_message.messageID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parseMessageDetailDataWithDictionary:object];
                    //列表变成已读
                    [self updateMessageListWithRead];
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

- (void)parseMessageDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    _detail = [[MessageModel alloc] initWithParseDictionary:infoDict];
    [self initUI];
}

- (void)updateMessageListWithRead {
    _message.messageRead = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMessageListNotification object:nil];
}


- (void)updateMessageListWithDelete {
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_message,@"message", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMessageListNotification object:nil userInfo:info];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
