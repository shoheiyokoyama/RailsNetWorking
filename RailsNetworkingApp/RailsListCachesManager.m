//
//  RailsListCachesManager.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/16.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RailsListCachesManager.h"

@interface RailsListCachesManager()
@property NSArray *array;
@end

@implementation RailsListCachesManager

static RailsListCachesManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[RailsListCachesManager alloc]init];
    });
    return sharedManager;
}

- (void)addData:(NSMutableArray *)array
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
    }
}

- (NSMutableArray *)getData
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!array) {
        NSLog(@"%@", @"データが存在しません。");
    }
    return array;
}

@end
