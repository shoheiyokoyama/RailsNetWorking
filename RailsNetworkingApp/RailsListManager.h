//
//  RailsListManager.h
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailsListManager : NSObject
typedef void (^PostRemoteCompletionHandler)(NSError *error);
typedef void (^GetRemoteCompletionHandler)(NSMutableArray *posts, NSError *error);

+ (instancetype)sharedManager;
- (void)postJsonData:(NSString*)text completionHandler:(PostRemoteCompletionHandler)completionHandler;
- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler;
@end
