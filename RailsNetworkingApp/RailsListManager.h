//
//  RailsListManager.h
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/10.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface RailsListManager : AFHTTPSessionManager
+ (instancetype)shared;
@end
