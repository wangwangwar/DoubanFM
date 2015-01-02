//
//  Song.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "SongStore.h"
#import "ImageStore.h"
#import "ArrayDataSource.h"
#import <RACAFNetworking.h>

NSString *SONG_URL = @"http://www.douban.com/j/app/radio/people?version=100&app_name=radio_desktop_win&type=n&channel=%lu";

@interface SongStore ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SongStore

#pragma mark - Class Method

+ (instancetype)sharedStore {
    static SongStore *sharedStore = nil;
    
    // Thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

#pragma mark - Initialization

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[SongStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        _channelId = 0;
        
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

#pragma mark - Operations

- (void)preloadImages {
    for (NSDictionary *song in self.songs) {
        NSString *imgURLString = song[@"picture"];
        [[ImageStore sharedStore] loadImageByURLString:imgURLString
                                       completionBlock:nil];
    }
}

- (NSDictionary *)getSongByIndex:(NSInteger)index {
    if (index < 0 || index >= [self.songs count]) {
        return nil;
    }
    
    // if last song, request new songs and append to `_songs`
    if ([self.songs count] - 1 == index) {
        [[self requestSongListWithChannel:self.channelId] subscribeNext:^(NSArray *songs) {
            [_songs addObjectsFromArray:songs];
        }];
    }
    return self.songs[index];
}

- (void)changeChannel:(NSUInteger)channelId {
    self.channelId = channelId;
    [[self requestSongListWithChannel:channelId] subscribeNext:^(NSArray *songs) {
        self.songs = [[NSMutableArray alloc] initWithArray:songs];
    }];
}

#pragma mark - RAC

- (RACSignal *)requestSongListWithChannel:(NSUInteger)channelId {
    return [[[[AFHTTPSessionManager manager]
              rac_GET:[NSString stringWithFormat:SONG_URL, channelId] parameters:nil]
              map:^id(NSDictionary *response) {
                  return response[@"song"];
              }]
              filter:^BOOL(NSArray *songList) {
                  return [songList count] > 0;
              }];
}

@end
