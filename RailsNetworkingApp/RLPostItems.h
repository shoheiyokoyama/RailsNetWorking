//
//  RLPostItems.h
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/16.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLPostItems : NSObject
- (instancetype)initWithData:(NSDictionary *)dictionary;
@property (nonatomic) NSString *text;
@property (nonatomic) NSNumber *postId;
@property (nonatomic) NSString *url;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end
