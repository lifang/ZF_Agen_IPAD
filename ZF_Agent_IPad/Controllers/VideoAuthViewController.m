//
//  VideoAuthViewController.m
//  ZF_Agent_IPad
//
//  Created by wufei on 15/4/24.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "VideoAuthViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AppDelegate.h"



@interface VideoAuthViewController ()<AnyChatNotifyMessageDelegate>

@property (nonatomic, strong) AnyChatPlatform *anyChat;

@property (nonatomic, assign) int myUserID;  //视频认证登录后自己的id

@property (nonatomic, assign) int remoteID;  //远程连接的id

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *localVideoSurface;
@property (nonatomic, strong) UIImageView *remoteVideoSurface;
@property (nonatomic, strong) UIView *theLocalView;

@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UILabel *statusLB;

@property (strong, nonatomic) NSMutableArray  *onlineUserMArray;

@end

@implementation VideoAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"视频认证";
    
    _onlineUserMArray=[[NSMutableArray alloc] init];
    
    _remoteVideoSurface = [[UIImageView alloc] init];
    _remoteVideoSurface.translatesAutoresizingMaskIntoConstraints = NO;
    _remoteVideoSurface.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_remoteVideoSurface];
    [_remoteVideoSurface makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    

    _statusLB = [[UILabel alloc] init];
    _statusLB.text=@"正在连接";
    _statusLB.font=FONT20;
    _statusLB.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_statusLB];
    [_statusLB makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(80);
        make.right.equalTo(self.view.right);
        make.width.equalTo(@200);
        
    }];


    
    
    _theLocalView = [[UIImageView alloc] init];
    _theLocalView.translatesAutoresizingMaskIntoConstraints = NO;
    _theLocalView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_theLocalView];
    [_theLocalView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-5);
        make.bottom.equalTo(self.view.bottom).offset(-45);
        make.width.equalTo(@400);
        make.height.equalTo(@400);
    }];
    
    _endBtn = [[UIButton alloc] init];
    _endBtn.clipsToBounds = YES;
    _endBtn.layer.masksToBounds=YES;
    _endBtn.layer.borderWidth=1.0;
    _endBtn.layer.borderColor=[UIColor colorWithHexString:@"006df5"].CGColor;
    [_endBtn setTitle:@"结束视频认证" forState:UIControlStateNormal];
    _endBtn.backgroundColor=[UIColor colorWithHexString:@"006df5"];
    [_endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endBtn addTarget:self action:@selector(endBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endBtn];
    [_endBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-2);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];

    

}

-(void)initAndConnect
{
    //初始化anyChatSDK
    [AnyChatPlatform InitSDK:0];
    // _anychat = [AnyChatPlatform new];
    
    //注册通知中心
    [[NSNotificationCenter  defaultCenter] addObserver:self  selector:@selector(AnyChatNotifyHandler:)
                                                  name:@"ANYCHATNOTIFY" object:nil];
    //初始化SDK
    _anyChat = [[AnyChatPlatform alloc] init];
    //AnyChat通知消息代理(回调事件接收者)
    _anyChat.notifyMsgDelegate = self;
    
    //连接服务器,第一个参数为服务器地址,第二参数为端口。
    [AnyChatPlatform Connect:kVideoAuthIP:kVideoAuthPort];
    
    //用户登录(userName 变量:登录用户名)
    //AppDelegate *delegate = [AppDelegate shareAppDelegate];
    //[AnyChatPlatform Login:delegate.agentID :@"111"];
    //[AnyChatPlatform Login:@"123":@"123"];
    [AnyChatPlatform Login:_terminalID:@"111"];
    //进入房间
    [AnyChatPlatform EnterRoom:1 :@"1"];
    
    //设置本地视频采用 Overlay 模式
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    //设置本地视频采集随着设备而旋转而处理
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION :self.interfaceOrientation];

}



- (void)StartVideoChat:(int) userid
{
    //Get a camera, Must be in the real machine.
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if (cameraDeviceArray.count > 0)
    {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:1]];
    }
    
    // open local video
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:-1 : YES];
    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform SetVideoPos:userid: self.remoteVideoSurface:0:0:0:0];
    [AnyChatPlatform UserCameraControl:userid : YES];
    
    // self.iRemoteUserId = userid;
    //远程视频显示时随设备的方向改变而旋转（参数为int型， 0表示关闭， 1 开启[默认]，视频旋转时需要参考本地视频设备方向参数）
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION : self.interfaceOrientation];
}



//AnyChat SDK自动调用“摄像头硬件初始化”方法
- (void)OnLocalVideoInit:(id)session
{
   
    ///通过session控制设备的视频数据输入和输出流向
    _localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession:(AVCaptureSession *)session];
   
    //视频显示层UI设置
    _localVideoSurface.frame = CGRectMake(0, 0, 400, 400);
    
    _localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    ///视频显示层添加到自定义的 theLocalView 界面显示视图中。
    [_theLocalView.layer addSublayer:_localVideoSurface];
    //旋转
    _theLocalView.layer.transform = CATransform3DMakeRotation(-1.5707963267949, 0.0, 0.0, 1.0);
    
}

//请求远程视频
- (void)OnReomtVideoInit
{
    //打开当前房间在线目标对象的音视频,需要传入它的userid
    //[AnyChatPlatform UserSpeakControl:userid:YES];
    [AnyChatPlatform UserSpeakControl:111:YES];
    //绑定目标对象视频显示在自定义的
    //remoteVideoSurface UIImageView*remoteVideoSurface;
    //“0”参数:目标对象视频显示位置与尺寸大小
    //[AnyChatPlatform SetVideoPos:us_remoteVideoSurfacerface:0:0:0:0];
    [AnyChatPlatform SetVideoPos:111:_remoteVideoSurface:0:0:0:0];
    //打开目标用户视频
    //[AnyChatPlatform UserCameraControl:userid :YES];
    [AnyChatPlatform UserCameraControl:111 :YES];

}


-(void)closeLocalVideo
{
    //关闭本地音频
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    //关闭本地视频
    [AnyChatPlatform UserCameraControl: -1 : NO];
}

-(void)closeRemmotVideo
{
    //关闭远程音频，userid 为远程目标用户 userid
    //[AnyChatPlatform UserSpeakControl: userid : NO];
    [AnyChatPlatform UserSpeakControl: 111 : NO];
    //关闭远程视频
    //[AnyChatPlatform UserCameraControl: userid: NO];
    [AnyChatPlatform UserCameraControl: 111 : NO];
    
}


- (void)FinishVideoChat
{
    // 关闭摄像头
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    //关闭远程音频，userid 为远程目标用户//关闭远程视频
    [AnyChatPlatform UserSpeakControl:_remoteID : NO];
    [AnyChatPlatform UserCameraControl:_remoteID : NO];
    
    _remoteID = -1;
    //离开房间
    [AnyChatPlatform LeaveRoom:-1];
     //断开与服务器的连接
    [AnyChatPlatform Logout];
    
}



- (void) OnLocalVideoRelease:(id)sender {
    //“localVideoSurface”表示视频显示层全局变量 (参考 4.2.2)
    if(_localVideoSurface) {
    _localVideoSurface = nil;
  }
}


//消息观察者方法
- (void)AnyChatNotifyHandler:(NSNotification*)notify {
    NSDictionary* dict = notify.userInfo;
    
    [_anyChat OnRecvAnyChatNotify:dict];
}



//回调方法
// 连接服务器消息
- (void) OnAnyChatConnect:(BOOL) bSuccess
{
    NSLog(@"连接服务器！");
    if (bSuccess)
    {
        //theStateInfo.text = @"• Success connected to server";
        _statusLB.text=@"已成功连接，正等待客服";
    }
    

}
// 用户登陆消息
- (void) OnAnyChatLogin:(int) dwUserId : (int) dwErrorCode
{
    NSLog(@"用户登陆成功！");
    _onlineUserMArray = [NSMutableArray arrayWithCapacity:5];
    
    if(dwErrorCode == GV_ERR_SUCCESS)
    {
       
        
    }

}
// 用户进入房间消息
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode
{

     NSLog(@"用户进入房间成功！");
    /*
    //打开本地音频(参数“-1”表示本地用户,也可以用本地的真实 userid)
    [AnyChatPlatform UserSpeakControl: -1:YES];
    //设置本地视频 UI(“0”为默认适配视频显示位置与尺寸大小)
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    //打开本地视频(参数“-1”表示本地用户,也可以用本地的真实 userid)
    [AnyChatPlatform UserCameraControl:-1 : YES];
     */
   // [self StartVideoChat:111];
    [self StartVideoChat:_remoteID];

}
// 房间在线用户消息
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId
{
     NSLog(@"房间在线用户！");
    _onlineUserMArray = [[NSMutableArray alloc] initWithArray:[AnyChatPlatform GetOnlineUser]];
    if ([_onlineUserMArray count]) {
        int selectID = [[_onlineUserMArray objectAtIndex:0] intValue];
        _remoteID=selectID;
    }
    //[onLineUserList insertObject:[NSString stringWithFormat:@"%i",self.theMyUserID] atIndex:0];
    

}
// 用户进入房间消息
- (void) OnAnyChatUserEnterRoom:(int) dwUserId
{
    NSLog(@"用户进入房间！");
    _statusLB.text=@"已成功接通客服";

}
// 用户退出房间消息
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId
{
    

}
// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode
{

}



#pragma mark - Orientation Rotation
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //device orientation
    UIDeviceOrientation devOrientation = [UIDevice currentDevice].orientation;
    
    if (devOrientation == UIDeviceOrientationLandscapeLeft)
    {
         NSLog(@"left left");
        [self setFrameOfLandscapeLeft];
    }
    else if (devOrientation == UIDeviceOrientationLandscapeRight)
    {
         NSLog(@"right right");
        [self setFrameOfLandscapeRight];
    }
    NSLog(@"testetstdets");
   
}



-(void)setFrameOfLandscapeLeft
{
    //Rotate
    _remoteVideoSurface.layer.transform = CATransform3DMakeRotation(-1.5707963267949, 0.0, 0.0, 1.0);
    self.theLocalView.layer.transform = CATransform3DMakeRotation(-1.5707963267949, 0.0, 0.0, 1.0);
    //Scale
    //self.remoteVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    //self.theLocalView.frame = kLocalVideoLandscape_CGRect;
}

-(void)setFrameOfLandscapeRight
{
    //Rotate
    _remoteVideoSurface.layer.transform = CATransform3DMakeRotation(1.5707963267949, 0.0, 0.0, 1.0);
    self.theLocalView.layer.transform = CATransform3DMakeRotation(1.5707963267949, 0.0, 0.0, 1.0);    //Scale
    //self.remoteVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
   // self.theLocalView.frame = kLocalVideoLandscape_CGRect;
}


-(void)endBtnPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"结束当前视频认证"
                              delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        /*
        //关闭摄像头
        [self closeLocalVideo];
        //离开房间
        [AnyChatPlatform LeaveRoom:-1];
        //断开与服务器的连接
        [AnyChatPlatform Logout];
         */
        [self FinishVideoChat];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self initAndConnect];
    NSLog(@"termianlID:%@",_terminalID);
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    /*
    //关闭摄像头
    [self closeLocalVideo];
    //离开房间
    [AnyChatPlatform LeaveRoom:-1];
    //断开与服务器的连接
    [AnyChatPlatform Logout];
     */
    [self FinishVideoChat];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
