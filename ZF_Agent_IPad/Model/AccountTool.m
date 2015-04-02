//
//  AccountTool.m
//  iPadff
//
//  Created by 黄含章 on 15/3/25.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#define HHZAccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"userInfo"]

#import "AccountTool.h"

@implementation AccountTool
+ (NSString *)lastestUserPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kLastestPath];
}

+ (void)save:(AccountModel *)account {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account forKey:kLastestFile];
        [archiver finishEncoding];
        [data writeToFile:[[self class] lastestUserPath] atomically:YES];
    });
}

+ (AccountModel *)userModel {
    NSString *userPath = [[self class] lastestUserPath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchiver decodeObjectForKey:kLastestFile];
}
@end
