//
//  Song.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface SongStore : NSObject

@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic) NSUInteger channelId;

+ (instancetype)sharedStore;

- (void)changeChannel:(NSUInteger)channelId;
- (void)refreshWithDataRefreshBlock:(void (^)(NSArray *songArray))dataRefreshBlock
                    completionBlock:(void (^)())completionBlock;
// give data using dataRefreshBlock. If having no data, using
// `refreshWithDataRefreshBlock:completionBlock` to retrieve data and give.
- (void)loadWithDataRefreshBlock:(void (^)(NSArray *songArray))dataRefreshBlock
                 completionBlock:(void (^)())completionBlock;
- (void)preloadImages;
- (NSDictionary *)getSongByIndex:(NSInteger)index;

@end
