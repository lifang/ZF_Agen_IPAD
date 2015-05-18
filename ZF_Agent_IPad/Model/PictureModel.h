//
//  PictureModel.h
//  iPadff
//
//  Created by comdosoft on 15/5/15.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject
@property (nonatomic, strong) NSString *pictureName;

@property (nonatomic, strong) NSString *pictureId;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
