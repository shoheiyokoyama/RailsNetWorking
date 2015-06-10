//
//  RailsListManager.h
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailsListManager : NSObject
+ (instancetype)sharedManager;
- (void)postJsonData:(NSString*)text;
- (void)getJsonData;
@property (copy) void (^completionHandlerPostRemote)(NSError *error);
@property (copy) void (^completionHandlerGetRemote)(NSMutableArray *post, NSError *error);
@end
