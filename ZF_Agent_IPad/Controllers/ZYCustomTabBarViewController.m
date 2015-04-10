//
//  ZYCustomTabBarViewController.m
//  ZYCustomTabBar
//
//  Created by wxg on 13-6-4.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

//动画持续时间，该时间与压栈和出栈时间相当
#define SLIDE_ANIMATION_DURATION 0
#import "ZYCustomTabBarViewController.h"
#import "MBProgressHUD.h"

@interface ZYCustomTabBarViewController()
@property(nonatomic,strong)UIImageView *backView;
@property(nonatomic,strong)UISwitch *noticeSwitch;
- (void)test;
@end
@implementation ZYCustomTabBarViewController
@synthesize viewControllers = _viewControllers;
@synthesize seletedIndex = _seletedIndex;
@synthesize previousNavViewController = _previousNavViewController;
- (void)test
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"123---%f",[UIDevice currentDevice].systemVersion.floatValue);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showbar) name:@"showbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidebar) name:@"hiedebar" object:nil];

    _nomalImageArray = [[NSArray alloc] initWithObjects:@"tabar_n1",@"tabar_n2",@"tabar_n3",@"tabar_n4",@"tabbar_button_notes_normal.png",nil];
    _hightlightedImageArray = [[NSArray alloc]initWithObjects:@"tabar1_h",@"taba2_h",@"tabar3_h",@"tabar4_h",@"tabbar_button_notes_selected.png",nil];
    [self createui];
    _seletedIndex = 0;
//      用self.赋值默认会调set方法
//		self.seletedIndex = _seletedIndex;
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)hidebar
{
    [self hideTabBar:1 animated:YES];
    
    
    
}
-(void)showbar
{
    [self showTabBar:1 animated:YES];
    


}
- (void)showMessage:(NSString*)message viewHeight:(float)height;
{
    if(self)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        //        hud.dimBackground = YES;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.yOffset = height;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}

-(void)createui
{
    if (iOS8) {
        _tabView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, SCREEN_HEIGHT)];
    }
    else
    {
        _tabView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, SCREEN_WIDTH)];
    }
    [self.view addSubview:_tabView];
    _tabView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    if (iOS7) {
        button1.frame=CGRectMake(10,SCREEN_WIDTH/8-40,  40, 50);
    }
    else
    {
        button1.frame=CGRectMake(10,SCREEN_HEIGHT/8-40,  40, 50);
    }
    button1.tag=1;
    [_tabView addSubview:button1];
    [button1 setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:0]] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button1 setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag=2;
    if (iOS8) {
        button2.frame=CGRectMake(10,2*SCREEN_HEIGHT/8-40,   40, 50);
    }
    else
    {
        button2.frame=CGRectMake(10,2*SCREEN_WIDTH/8-40,   40, 50);
    }
    [_tabView addSubview:button2];
    [button2 setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:1]] forState:UIControlStateNormal];
    [button2.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button2 setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
    UIButton *button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag=3;
    if (iOS8) {
        button3.frame=CGRectMake(10,3*SCREEN_HEIGHT/8-40,   40, 50);
    }
    else
    {
        button3.frame=CGRectMake(10,3*SCREEN_WIDTH/8-40,   40, 50);
    }
    [_tabView addSubview:button3];
    [button3 setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:2]] forState:UIControlStateNormal];
    [button3.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button3 setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
    UIButton *button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.tag=4;
    if (iOS8) {
        button4.frame=CGRectMake(10,4*SCREEN_HEIGHT/8-40,   40, 50);
    }
    else
    {
        button4.frame=CGRectMake(10,4*SCREEN_WIDTH/8-40,   40, 50);
    }
    [_tabView addSubview:button4];
    [button4 setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:3]] forState:UIControlStateNormal];
    [button4.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button4 setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
   
//    [button1 setBackgroundColor:[UIColor whiteColor]];
//    [button2 setBackgroundColor:[UIColor whiteColor]];
//    [button4 setBackgroundColor:[UIColor whiteColor]];
//    [button3 setBackgroundColor:[UIColor whiteColor]];
    
    [button2 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (iOS8) {
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/8+40-40,  60, 20)];
        [_tabView addSubview:lab1];
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0,2*SCREEN_HEIGHT/8+40-40,  60, 20)];
        [_tabView addSubview:lab2];
        UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(0,3*SCREEN_HEIGHT/8+40-40,  60, 20)];
        [_tabView addSubview:lab3];
        UILabel *lab4=[[UILabel alloc]initWithFrame:CGRectMake(0,4*SCREEN_HEIGHT/8+40-40,  60, 20)];
        [_tabView addSubview:lab4];
        lab1.text = @"首页";
        lab1.tag = 10;
        lab2.text = @"全部商品";
        lab2.tag = 11;
        lab3.tag = 12;
        lab4.tag = 13;
        lab1.font = [UIFont systemFontOfSize:12];
        lab2.font = [UIFont systemFontOfSize:12];
        lab3.font = [UIFont systemFontOfSize:12];
        lab4.font = [UIFont systemFontOfSize:12];
        lab3.text = @"我的消息";
        lab4.text = @"我的";
        lab1.textAlignment = NSTextAlignmentCenter;
        lab2.textAlignment = NSTextAlignmentCenter;
        lab3.textAlignment = NSTextAlignmentCenter;
        lab4.textAlignment = NSTextAlignmentCenter;
        lab1.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab2.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab3.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab4.textColor = [UIColor colorWithWhite:1 alpha:1];
    }
    else
    {
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0,SCREEN_WIDTH/8+40-40,  60, 20)];
        [_tabView addSubview:lab1];
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,2*SCREEN_WIDTH/8+40-40,  60, 20)];
        [_tabView addSubview:lab2];
        UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(0,3*SCREEN_WIDTH/8+40-40,  60, 20)];
        [_tabView addSubview:lab3];
        UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(0,4*SCREEN_WIDTH/8+40-40,  60, 20)];
        [_tabView addSubview:lab4];
        lab1.text = @"首页";
        lab1.tag = 10;
        lab2.text = @"购物车";
        lab2.tag = 11;
        lab3.tag = 12;
        lab4.tag = 13;
        lab1.font = [UIFont systemFontOfSize:12];
        lab2.font = [UIFont systemFontOfSize:12];
        lab3.font = [UIFont systemFontOfSize:12];
        lab4.font = [UIFont systemFontOfSize:12];
        lab3.text = @"我的消息";
        lab4.text = @"我的";
        lab1.textAlignment = NSTextAlignmentCenter;
        lab2.textAlignment = NSTextAlignmentCenter;
        lab3.textAlignment = NSTextAlignmentCenter;
        lab4.textAlignment = NSTextAlignmentCenter;
        lab1.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab2.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab3.textColor = [UIColor colorWithWhite:1 alpha:1];
        lab4.textColor = [UIColor colorWithWhite:1 alpha:1];
    }
    
    UIButton*button5=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if (iOS8) {
        button5.frame=CGRectMake(10,SCREEN_HEIGHT-80,  40, 50);
    }
    else
    {
        button5.frame=CGRectMake(10,SCREEN_WIDTH-80,  40, 50);
    }
    [_tabView addSubview:button5];
    [button5 setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(setclick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSeletedIndex:(int)aIndex
{
    //如果索引值没有改变不做其他操作
//	if (_seletedIndex == aIndex) return;
	
    //如果索引值改变了需要做操作
    /*
     安全性判断
     如果_seletedIndex表示当前显示的有视图
     需要把原来的移除掉，然后把对应的TabBar按钮设置为正常状态
     */
	if (_seletedIndex >= 0)
	{
        /*
         把视图控制器的视图移除掉
         但是数组中视图控制器的对象还在
         */
        //找出对应索引的视图控制器
		UIViewController *priviousViewController = [_viewControllers objectAtIndex:_seletedIndex];
        //移除掉
         NSLog(@"aaaaaabbbb%lu", (unsigned long)_viewControllers.count);
		[priviousViewController.view removeFromSuperview];
		
        //找出对应的TabBar按钮
		UIButton *previousButton = (UIButton *)[self.view viewWithTag:_seletedIndex + 1];
        
        UILabel*lab=(UILabel *)[self.view viewWithTag:_seletedIndex + 10];
        [rootimageview removeFromSuperview];
        lab.textColor = [UIColor colorWithWhite:1 alpha:1];

        //设置为正常状态下的图片
        //lab.textColor=[UIColor blackColor];
		[previousButton setImage:[UIImage imageNamed:[_nomalImageArray objectAtIndex:_seletedIndex]] forState:UIControlStateNormal];
	}
    /*
     记录当前索引，采用属性直接赋值的方式F
     更改TabBar按钮状态为高亮状态
     添加视图
     */
    //记录一下当前的索引
	_seletedIndex = aIndex;
    [_tabView addSubview:rootimageview];
    //获得对应的按钮并且设置为高亮状态下的图片
    UILabel*lab=(UILabel *)[self.view viewWithTag:aIndex + 10];
    //设置为正常状态下的图片
    lab.textColor=kColor(3, 112, 214, 1);
	UIButton *currentButton = (UIButton *)[self.view viewWithTag:(aIndex + 1)];
	[currentButton setImage:[UIImage imageNamed:[_hightlightedImageArray objectAtIndex:aIndex]] forState:UIControlStateNormal];
	
    //获得对应的视图控制器
	UIViewController *currentViewController = [_viewControllers objectAtIndex:aIndex];
    //如果此条件成立表示当前是第一个，即“导航控制器”
	if ([currentViewController isKindOfClass:[UINavigationController class]])
	{
        //设置导航控制器的代理
		((UINavigationController *)currentViewController).delegate = self;
	}
    //设置当前视图的大小
    if(iOS7)
    {
        if(self.AG==78)
        {
            currentViewController.view.frame = CGRectMake(60, 0,  SCREEN_HEIGHT - 60,SCREEN_WIDTH+260);
        }
        else
        {
            currentViewController.view.frame = CGRectMake(60, 0,  SCREEN_HEIGHT - 60,SCREEN_WIDTH);
        }
        self.AG=79;
    }
    else
    {
        currentViewController.view.frame = CGRectMake(60, 0,  SCREEN_WIDTH - 60,SCREEN_HEIGHT);
    }
    //添加到Tab上
	[self.view addSubview:currentViewController.view];
	
    //把视图放到TabBar下面
	[self.view sendSubviewToBack:currentViewController.view];
	
}
-(void)tabBarButtonClicked:(id)sender
{
    //获得索引
	UIButton *btn = (UIButton *)sender;
	int index = btn.tag - 1.0;
   
    //用self.赋值默认会调set方法
    [self setSeletedIndex:index];
}
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"vc is %@",viewController);
    /*
     第一次加载根视图:previousNavViewController当前导航控制器里面的视图控制器数组
     之后显示视图:previousNavViewController操作前的视图控制器数组
     */
	if (!_previousNavViewController)
	{
        //导航控制器中的视图数组
		self.previousNavViewController = navigationController.viewControllers;
	}
	/*
     是否为压栈的标记，初始化为NO
     如果原来的控制器数不大于当前导航的视图控制器数表示是压栈
     */
	BOOL isPush = NO;
	if ([_previousNavViewController count] <= [navigationController.viewControllers count])
	{
		isPush = YES;
	}
    /*
     上一个视图控制器当压栈的时候底部条是否隐藏
     当前视图控制器当压栈的时候底部条是否隐藏
     这两个视图控制器有可能是同一个
     */
	BOOL isPreviousHidden = [[_previousNavViewController lastObject] hidesBottomBarWhenPushed];
	BOOL isCurrentHidden = viewController.hidesBottomBarWhenPushed;
//    [[navigationController.viewControllers lastObject] hidesBottomBarWhenPushed]
	
    //重新记录当前导航器中的视图控制器数组
	self.previousNavViewController = navigationController.viewControllers;
	
    /*
     如果状态相同不做其他操作
     如果上一个显示NO，这个隐藏YES，则隐藏TabBar
     如果上一个隐藏YES，这个显示NO，则显示TabBar
     */
	if (!isPreviousHidden && !isCurrentHidden)
	{
		return;
	}
	else if(isPreviousHidden && isCurrentHidden)
	{
		return;
	}
	else if(!isPreviousHidden && isCurrentHidden)
	{
		//隐藏tabbar 压栈
		[self hideTabBar:isPush ? ZYSlideDirectionLeft : ZYSlideDirectionRight  animated:animated];
	}
	else if(isPreviousHidden && !isCurrentHidden)
	{
		//显示tabbar 出栈
		[self showTabBar:isPush ? ZYSlideDirectionLeft : ZYSlideDirectionRight animated:animated];
	}
	
}

/*
 显示底部TabBar相关
 需要重置当前视图控制器View的高度为整个屏幕的高度-TabBar的高度
 */
- (void)showTabBar:(ZYSlideDirection)direction animated:(BOOL)isAnimated
{
	//根据压栈还是出栈设置TabBar初始位置
	CGRect tempRect = _tabView.frame;
    
	tempRect.origin.x = 60 * ( (direction == ZYSlideDirectionRight) ? -1 : 1);
	_tabView.frame = tempRect;
	 
    //执行动画
	[UIView animateWithDuration:isAnimated ? SLIDE_ANIMATION_DURATION : 0 delay:0 options:0 animations:^
	 {
         
		 //动画效果
		 CGRect tempRect = _tabView.frame;
		 tempRect.origin.x = 0;
		 _tabView.frame = tempRect;
		 
	 }
    completion:^(BOOL finished)
	 {
         //动画结束时
         //重置当前视图控制器View的高度为整个屏幕的高度-TabBar的高度
		 UIViewController *currentViewController = [_viewControllers objectAtIndex:_seletedIndex];
		 
		 CGRect viewRect = currentViewController.view.frame;
		 viewRect.origin.x = 60;

		 currentViewController.view.frame = viewRect;
	 }];
}

/*
 隐藏底部TabBar相关
 需要重置当前视图控制器View的高度为整个屏幕的高度
 */
- (void)hideTabBar:(ZYSlideDirection)direction animated:(BOOL)isAnimated
{
    //获得当前视图控制器
	UIViewController *currentViewController = [_viewControllers objectAtIndex:_seletedIndex];
	//重置高度
	CGRect viewRect = currentViewController.view.frame;
    
	viewRect.size.width = self.view.bounds.size.width;
    
    viewRect.origin.x = 0;

	currentViewController.view.frame = viewRect;
	
    //设置TabBar的位置
	CGRect tempRect = _tabView.frame;
	tempRect.origin.x = 0;
	_tabView.frame = tempRect;
	
    //采用Block的形式开启一个动画
	[UIView animateWithDuration:isAnimated ? SLIDE_ANIMATION_DURATION : 0 delay:0 options:0 animations:^(void)
     {
         //根据压栈还是出栈设置动画效果
		 CGRect tempRect = _tabView.frame;
		 tempRect.origin.x = 60* (direction == ZYSlideDirectionLeft ? -1 : 1);
		 _tabView.frame = tempRect;
		 
     }
    completion:^(BOOL finished){}
     ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - setting Clicked
-(void)setclick
{
    [self initBackView];
}
#pragma mark - setting Clicked UI
-(void)initBackView
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = kScreenHeight;
        height = kScreenWidth;
    }
    else
    {
        width = kScreenWidth;
        height = kScreenHeight;
    }
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:_backView];
    _backView.image=[UIImage imageNamed:@"backimage"];
    _backView.userInteractionEnabled=YES;
    [self.view addSubview:_backView];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(width / 2 - 180, 180, width / 2.4, height / 2.5);
    [_backView addSubview:whiteView];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setBackgroundImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(15, 15, 22, 22);
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBtn];
    
    UILabel *setLabel = [[UILabel alloc]init];
    setLabel.text = @"设置";
    setLabel.textColor = kColor(52, 53, 54, 1.0);
    setLabel.font = [UIFont boldSystemFontOfSize:22];
    setLabel.frame = CGRectMake(whiteView.frame.size.width / 2 - 20, 5, 60, 40);
    [whiteView addSubview:setLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(143, 142, 142, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(setLabel.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UIButton *getNews = [[UIButton alloc]init];
    [getNews setTitle:@"接收新通知" forState:UIControlStateNormal];
    [getNews setTitleColor:kColor(57, 57, 57, 1.0) forState:UIControlStateNormal];
    getNews.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    getNews.frame = CGRectMake(50, CGRectGetMaxY(line.frame) + 20, 200, 40);
    [whiteView addSubview:getNews];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = kColor(228, 226, 225, 1.0);
    line2.frame = CGRectMake(0, CGRectGetMaxY(getNews.frame) + 20, whiteView.frame.size.width, 1);
    [whiteView addSubview:line2];
    
    UIButton *examineBtn = [[UIButton alloc]init];
    [examineBtn setTitle:@"检测版本更新" forState:UIControlStateNormal];
    [examineBtn setTitleColor:kColor(57, 57, 57, 1.0) forState:UIControlStateNormal];
    examineBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    examineBtn.frame = CGRectMake(50, CGRectGetMaxY(line2.frame) + 20, 200, 40);
    [whiteView addSubview:examineBtn];

    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = kColor(228, 226, 225, 1.0);
    line3.frame = CGRectMake(0, CGRectGetMaxY(examineBtn.frame) + 20, whiteView.frame.size.width, 1);
    [whiteView addSubview:line3];
    
    UIButton *clearMemory = [[UIButton alloc]init];
    [clearMemory setTitle:@"清除缓存" forState:UIControlStateNormal];
    [clearMemory setTitleColor:kColor(57, 57, 57, 1.0) forState:UIControlStateNormal];
    clearMemory.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    clearMemory.frame = CGRectMake(50, CGRectGetMaxY(line3.frame) + 20, 200, 40);
    [whiteView addSubview:clearMemory];
    
    _noticeSwitch = [[UISwitch alloc]init];
    _noticeSwitch.backgroundColor = [UIColor clearColor];
    _noticeSwitch.onTintColor = kMainColor;
    _noticeSwitch.frame = CGRectMake(CGRectGetMaxX(getNews.frame) + 50, CGRectGetMaxY(line.frame) + 24, 85, 50);
    [_noticeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [whiteView addSubview:_noticeSwitch];
    
    UILabel *versionsLabel = [[UILabel alloc]init];
    versionsLabel.textColor = kColor(156, 155, 154, 1.0);
    versionsLabel.font = [UIFont systemFontOfSize:20];
    versionsLabel.text = @"V1.0.1";
    versionsLabel.frame = CGRectMake(CGRectGetMaxX(getNews.frame) + 50, CGRectGetMaxY(line2.frame) + 15, 85, 50);
    [whiteView addSubview:versionsLabel];
    
    UILabel *memoryLabel = [[UILabel alloc]init];
    memoryLabel.textColor = kColor(156, 155, 154, 1.0);
    memoryLabel.font = [UIFont systemFontOfSize:20];
    memoryLabel.text = @"200M";
    memoryLabel.frame = CGRectMake(CGRectGetMaxX(getNews.frame) + 50, CGRectGetMaxY(line3.frame) + 15, 85, 50);
    [whiteView addSubview:memoryLabel];
    
}

-(void)cancelClicked
{
    [_backView removeFromSuperview];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchV = sender;
    if (switchV.isOn) {
        NSLog(@"开!");
    }else{
        NSLog(@"关!");
    }
}
@end
