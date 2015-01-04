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
- (RACSignal *)requestSongListWithChannel:(NSUInteger)channelId;

- (NSDictionary *)getSongByIndex:(NSInteger)index;

@end
