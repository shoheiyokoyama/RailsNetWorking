//
//  RailsListManager.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RailsListManager.h"
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

- (void)postJsonData:(NSString*)text
{
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:text forKey:@"top[name]"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:LISTURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"success: %@", responseObject);
              
              if(self.completionHandlerPostRemote){
                  self.completionHandlerPostRemote(nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"error: %@", error);
              
              if(self.completionHandlerPostRemote){
                  self.completionHandlerPostRemote(error);
              }
          }];
}

- (void)getJsonData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:LISTURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"success: %@", responseObject);
             _posts = [NSMutableArray array];
             
             for (NSDictionary *jsonObject in responseObject) {
                 [_posts addObject:[jsonObject objectForKey:@"name"]];
             }
             
             if (self.completionHandlerGetRemote) {
                 self.completionHandlerGetRemote(_posts, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
             NSLog(@"error: %@", error);
             if (self.completionHandlerGetRemote) {
                 self.completionHandlerGetRemote(nil, error);
             }
         }];

}

@end
