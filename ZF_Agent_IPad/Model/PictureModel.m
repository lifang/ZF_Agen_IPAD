//
//  PictureModel.m
//  iPadff
//
//  Created by comdosoft on 15/5/15.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"urlPath"]) {
            _pictureName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"urlPath"]];
        }
        if ([dict objectForKey:@"id"]) {
            _pictureId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
    }
    return self;
}

@end
