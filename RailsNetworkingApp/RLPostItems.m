//
//  RLPostItems.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/16.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RLPostItems.h"

@interface RLPostItems()<NSCoding>
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.postId = [aDecoder decodeObjectForKey:@"id"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.postId forKey:@"id"];
    [encoder encodeObject:self.url forKey:@"url"];
}

@end
