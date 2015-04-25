//
//  BaseApi.m
//  iPadff
//
//  Created by wufei on 15/3/19.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "BaseApi.h"

@implementation BaseApi

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(void)EndEditing
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
}


@end
