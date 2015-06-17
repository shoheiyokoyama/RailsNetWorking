//
//  RLPostItems.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/16.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RLPostItems.h"

@interface RLPostItems()
@end

@implementation RLPostItems

- (instancetype)initWithData:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary[@"name"]) {
            self.text = dictionary[@"name"];
        }
        if (dictionary[@"id"]) {
            self.postId = dictionary[@"id"];
        }
        if (dictionary[@"url"]) {
            self.url = dictionary[@"url"];
        }
        
    }
    return self;
}

@end
