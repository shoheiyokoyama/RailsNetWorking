//
//  RailsListCachesManager.h
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/16.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailsListCachesManager : NSObject
+ (instancetype)sharedManager;
- (void)addData:(NSMutableArray *)array;
- (NSMutableArray *)getData;
@end
