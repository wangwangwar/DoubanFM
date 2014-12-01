//
//  Song.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, strong) NSArray *songs;

- (instancetype)initWithChannelId:(NSUInteger)channelId;
- (void)refreshWithCompletionBlock:(void (^)())completionBlock;
- (void)preloadImages;

@end
