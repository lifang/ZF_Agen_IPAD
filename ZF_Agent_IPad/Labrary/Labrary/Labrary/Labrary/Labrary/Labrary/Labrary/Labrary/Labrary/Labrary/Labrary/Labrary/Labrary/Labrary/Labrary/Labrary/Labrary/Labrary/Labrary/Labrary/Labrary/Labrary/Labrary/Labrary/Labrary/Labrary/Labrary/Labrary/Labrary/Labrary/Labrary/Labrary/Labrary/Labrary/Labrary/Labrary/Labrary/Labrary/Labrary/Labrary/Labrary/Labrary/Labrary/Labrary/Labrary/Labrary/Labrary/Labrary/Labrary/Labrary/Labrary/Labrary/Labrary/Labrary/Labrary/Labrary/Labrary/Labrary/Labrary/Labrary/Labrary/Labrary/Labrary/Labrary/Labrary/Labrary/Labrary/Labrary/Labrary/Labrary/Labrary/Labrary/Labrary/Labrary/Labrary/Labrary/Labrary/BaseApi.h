//
//  BaseApi.h
//  iPadff
//
//  Created by wufei on 15/3/19.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseApi : NSObject

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size;
+(void)EndEditing;

@end
