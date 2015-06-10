//
//  RailsListManager.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RailsListManager.h"
#import <AFNetworking.h>
#import "AFHTTPRequestOperationManager.h"

@interface RailsListManager()
//@property (nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation RailsListManager

//+ (RailsListManager *)sharedManager
//{
//    @synchronized(self) {
//        if (!manager) {
//            manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[[NSURL alloc] initWithString:@"http://example.com"]]];
//            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//            [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//            [manager.requestSerializer setValue:[Util userAgent] forHTTPHeaderField:@"User-Agent"];
//        }
//    }
//    return manager;
//}

+ (instancetype)shared
{
    static RailsListManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

@end
