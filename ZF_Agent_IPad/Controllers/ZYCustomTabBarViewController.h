//
//  ZYCustomTabBarViewController.h
//  ZYCustomTabBar
//
//  Created by wxg on 13-6-4.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FLViewController.h"
//标记一下方向
typedef enum
{
    ZYSlideDirectionRight = 0,
    ZYSlideDirectionLeft
}
ZYSlideDirection;

/*
 自定义TabBar类，实现了UINavigationControllerDelegate协议
 */
@interface ZYCustomTabBarViewController : FLViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView*lingquview;
    UIImageView*lingquimage;
    UIButton*lingqubutton;
    //TabBar视图
     UIView *_tabView;
	//TabBar视图数组
	NSArray  *_viewControllers;
   UIImageView *rootimageview;
    UISwipeGestureRecognizer*recognizer;
    UIImageView*getimage;
    UIView*view1;
    UITextField*phonefield1;
    UITextField*phonefield;
    UIButton*getbutton;
    int count;
    //正常状态下的图片数组
	NSArray  *_nomalImageArray;
    //高亮状态下的图片数组
	NSArray  *_hightlightedImageArray;
    UIImageView*phonetextfieldimage;
     UIImageView*phonetextfieldimage1;
     UIImageView*phonetextfieldimage2;
        UIImageView*phonetextfieldimage3;
    //TabBar被选中的索引
int     _seletedIndex;
	NSTimer * timer1;
    //导航控制器中的视图数组
	NSArray  *_previousNavViewController;
    UILabel *_versionsLabel;
    
    NSString*down_url;
}
/*
 描述的过程其实就是生成set和get方法的过程
 例如：
 描述了int seletedIndex;
 描述之后可以用self.seletedIndex赋值
 如果在.m里实现了一个 setSeletedIndex方法，那当用self.seletedIndex赋值
 的时候会不会调用setSeletedIndex这个方法？会调用
 */

@property (nonatomic,retain) NSArray  *previousNavViewController;
@property (nonatomic,retain) NSArray  *viewControllers;
@property (nonatomic,assign)int    seletedIndex;

@property (nonatomic,assign)int    AG;


- (void)showTabBar:(ZYSlideDirection)direction animated:(BOOL)isAnimated;
- (void)hideTabBar:(ZYSlideDirection)direction animated:(BOOL)isAnimated;

@end
