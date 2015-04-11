//
//  UIImage+Extention.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "UIImage+Extention.h"

@implementation UIImage (Extention)

+(UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.self.size.width *0.5 topCapHeight:image.size.height *0.5];
}

@end
