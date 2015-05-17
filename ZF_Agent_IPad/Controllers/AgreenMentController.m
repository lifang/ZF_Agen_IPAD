//
//  AgreenMentController.m
//  iPadff
//
//  Created by 黄含章 on 15/5/15.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AgreenMentController.h"
#import "NetworkInterface.h"
#import "ApplyDetailController.h"

@interface AgreenMentController ()

@property(nonatomic,strong)NSString *protocolText;

@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)BOOL isAgreen;

@end

@implementation AgreenMentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"申请开通协议";
    topLabel.font = [UIFont systemFontOfSize:17];
    topLabel.frame = CGRectMake(220, 20, 140, 30);
    [self.view addSubview:topLabel];
    
    UIScrollView *scrollV = [[UIScrollView alloc]init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.frame = CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 350);
    if (iOS7) {
        scrollV.frame = CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 10, SCREEN_HEIGHT, SCREEN_WIDTH - 350);
    }
    [self.view addSubview:scrollV];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    NSString *str = _protocolStr;
    contentLabel.text = str;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:16];
    CGSize size = CGSizeMake(470,0); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: contentLabel.font};
    CGSize labelsize = [contentLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //ios7以下方法
//    CGSize topLabelSize = {470,0};
//    topLabelSize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size];
    contentLabel.frame = CGRectMake(30, 0, SCREEN_WIDTH * 0.47, labelsize.height);
    
    if (iOS7) {
        contentLabel.frame = CGRectMake(30, 0, SCREEN_HEIGHT * 0.47, labelsize.height);
    }
    [scrollV addSubview:contentLabel];
    
    if (labelsize.height > scrollV.frame.size.height) {
        scrollV.contentSize = CGSizeMake(contentLabel.frame.size.width, labelsize.height+ 10);
    }
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(239, 239, 239, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(scrollV.frame), SCREEN_WIDTH, 1);
    if (iOS7) {
        line.frame = CGRectMake(0, CGRectGetMaxY(scrollV.frame), SCREEN_HEIGHT, 1);
    }
    [self.view addSubview:line];
    
    _selectedBtn = [[UIButton alloc]init];
    _isSelected = YES;
    [_selectedBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    _selectedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_selectedBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:line
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_selectedBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20.f]];

    UILabel *agreenLabel = [[UILabel alloc]init];
    agreenLabel.text = @"我接受此开通协议";
    agreenLabel.font = [UIFont systemFontOfSize:16];
    agreenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:agreenLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreenLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:line
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreenLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreenLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:180.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:agreenLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:25.f]];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    CALayer *readBtnLayer = [cancelBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kMainColor CGColor]];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cancelBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:25.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:25.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:kMainColor];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sureBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_selectedBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:25.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cancelBtn
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sureBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    

}

#pragma mark - Action
-(void)btnClicked
{
    if (_isSelected == NO) {
        self.isAgreen = NO;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    else{
        self.isAgreen = YES;
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    _isSelected = !_isSelected;
}


-(void)sureClicked
{
    if (!_isAgreen) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请先接受协议";
        return;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (_pushStyle == PushDredge) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newApply" object:nil userInfo:nil];
            _pushStyle = PushNone;
        }
        if (_pushStyle == PushTeminal) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newApplyTerminal" object:nil userInfo:nil];
            _pushStyle = PushNone;
        }
        if (_pushStyle == PushTeminalChild) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newDetailApply" object:nil userInfo:nil];
            _pushStyle = PushNone;
        }
    }];
}

-(void)cancelClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
