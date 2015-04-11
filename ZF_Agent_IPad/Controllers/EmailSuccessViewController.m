//
//  EmailSuccessViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "EmailSuccessViewController.h"

@interface EmailSuccessViewController ()

@end

@implementation EmailSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initUI];
}

-(void)setupNavBar
{
    self.title = @"注册";
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

-(void)initUI
{
    UILabel *label1 = [[UILabel alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:20];
    label1.text = @"已注册成功!";
    label1.font = mainFont;
    label1.frame = CGRectMake(460, 120, 120, 40);
    [self.view addSubview:label1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = mainFont;
    label2.text = @"请至";
    label2.frame = CGRectMake(360, CGRectGetMaxY(label1.frame)-10,40, 40);
    [self.view addSubview:label2];
    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = kColor(253, 86, 36, 1.0);;
    label3.font = mainFont;
    CGSize labelSize = [self labelAutoCalculateRectWith:_email FontSize:20 MaxSize:CGSizeMake(300, 40)];
    label3.text = _email;
    label3.frame = CGRectMake(CGRectGetMaxX(label2.frame), label2.frame.origin.y, labelSize.width, 40);
    [self.view addSubview:label3];
    UILabel *label5 = [[UILabel alloc]init];
    label5.font = mainFont;
    label5.text = @"获取激活邮件";
    label5.frame = CGRectMake(CGRectGetMaxX(label3.frame), label2.frame.origin.y, 180, 40);
    [self.view addSubview:label5];
    UILabel *label4 = [[UILabel alloc]init];
    label4.font = mainFont;
    label4.text = @"激活成功后方能登陆";
    label4.frame = CGRectMake(label2.frame.origin.x + 70, CGRectGetMaxY(label3.frame)-10, 180, 40);
    [self.view addSubview:label4];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(233, 233, 233, 1.0);
    line.frame = CGRectMake(60, CGRectGetMaxY(label4.frame) + 40, label4.frame.size.width * 5, 2);
    [self.view addSubview:line];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"马上登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = mainFont;
    [loginBtn setBackgroundColor:kMainColor];
    loginBtn.frame = CGRectMake(label2.frame.origin.x + 70, CGRectGetMaxY(line.frame) + 40, 240, 40);
    [self.view addSubview:loginBtn];
    
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

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
