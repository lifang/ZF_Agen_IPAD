//
//  FindPasswordSuccessController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/19.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "FindPasswordSuccessController.h"

@interface FindPasswordSuccessController ()

@end

@implementation FindPasswordSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setupNavBar];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *label1 = [[UILabel alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:20];
    label1.text = @"重置密码邮件";
    label1.font = mainFont;
    label1.frame = CGRectMake(450, 60, 120, 40);
    [self.view addSubview:label1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = mainFont;
    label2.text = @"已发送至";
    label2.frame = CGRectMake(400, CGRectGetMaxY(label1.frame)-10,80, 40);
    [self.view addSubview:label2];
    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = [UIColor orangeColor];
    label3.font = mainFont;
    CGSize labelSize = [self labelAutoCalculateRectWith:_email FontSize:20 MaxSize:CGSizeMake(300, 40)];
    label3.text = _email;
    label3.frame = CGRectMake(CGRectGetMaxX(label2.frame), label2.frame.origin.y, labelSize.width, 40);
    [self.view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.font = mainFont;
    label4.text = @"请注意查收！！";
    label4.frame = CGRectMake(440, CGRectGetMaxY(label3.frame)-10, 180, 40);
    [self.view addSubview:label4];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(233, 233, 233, 1.0);
    line.frame = CGRectMake(60, CGRectGetMaxY(label4.frame) + 40, label4.frame.size.width * 5, 2);
    [self.view addSubview:line];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = mainFont;
    [loginBtn setBackgroundColor:kMainColor];
    loginBtn.frame = CGRectMake(label2.frame.origin.x - 10, CGRectGetMaxY(line.frame) + 40, 240, 40);
    [self.view addSubview:loginBtn];
    

}

-(void)setupNavBar
{
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *zeroBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    zeroBar.width = 30.f;
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 48, 48);
    [leftBtn setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    NSArray *leftArr = [NSArray arrayWithObjects:zeroBar,leftBar, nil];
    self.navigationItem.leftBarButtonItems = leftArr;

}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

-(void)loginClick
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
