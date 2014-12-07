//
//  Song.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongStore : NSObject

@property (nonatomic, strong, readonly) NSArray *songs;

+ (instancetype)sharedStore;
- (void)refreshWithDataRefreshBlock:(void (^)(NSArray *songArray))dataRefreshBlock
                    completionBlock:(void (^)())completionBlock;
- (void)preloadImages;
- (NSDictionary *)getSongByIndex:(NSInteger)index;

@end
