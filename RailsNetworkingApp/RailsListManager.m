//
//  RailsListManager.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RailsListManager.h"
#import "RLPostItems.h"
#import <AFNetworking.h>

#define LISTURL @"http://localhost:3000/tops.json"
@interface RailsListManager()
@property (nonatomic) NSMutableArray *posts;
@end

@implementation RailsListManager

static RailsListManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[RailsListManager alloc] init];
    });
    return sharedManager;
}

- (void)postJsonData:(NSString*)text completionHandler:(PostRemoteCompletionHandler)completionHandler
{
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:text forKey:@"top[name]"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:LISTURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"success: %@", responseObject);
              
              if (completionHandler) {
                  completionHandler(nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"error: %@", error);
              
              if (completionHandler) {
                  completionHandler(error);
              }
          }];
}

- (void)deleteJsonData:(RLPostItems *)post completionHandler:(PostRemoteCompletionHandler)completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    NSDictionary *params = [NSDictionary dictionaryWithObject:post.postId forKey:@"top[id]"];
    [manager DELETE:LISTURL
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
            }];
}

- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:LISTURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"success: %@", responseObject);//key name id, name, url
             _posts = [NSMutableArray array];
             
             for (NSDictionary *jsonObject in responseObject) {
                 RLPostItems *lists = [[RLPostItems alloc]initWithData:jsonObject];
                 [_posts addObject:lists];
             }
             if (completionHandler) {
                 completionHandler(_posts, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

@end
