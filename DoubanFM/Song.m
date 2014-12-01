//
//  Song.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "Song.h"
#import "ImageStore.h"


NSString *SONG_URL = @"http://www.douban.com/j/app/radio/people?version=100&app_name=radio_desktop_win&type=n&channel=%lu";

@interface Song ()

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSArray *items;
@property (nonatomic) NSUInteger channelId;

@end

@implementation Song

#pragma mark - Initialization

- (instancetype)initWithChannelId:(NSUInteger)channelId {
    self = [super init];
    if (self) {
        // Initial network
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        
        // Initial channel
        _channelId = channelId;
    }
    
    return self;
}

#pragma mark - Properties

- (NSArray *)songs {
    return _items;
}

#pragma mark - Operations

- (void)refreshWithCompletionBlock:(void (^)())completionBlock {
    NSString *urlString = [NSString stringWithFormat:SONG_URL, (unsigned long)self.channelId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSDictionary *songsData = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:0
                                                                                    error:nil];
                        self.songs = songsData[@"song"];
                        
                        if (completionBlock) {
                            // View related operations must execute in main queue!
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                completionBlock();
                            });
                        }
                        
                        // Preload Album Images
                        [self preloadImages];
                    }];
    [dataTask resume];
}

- (void)preloadImages {
    for (NSDictionary *song in self.songs) {
        NSString *imgURLString = song[@"picture"];
        [[ImageStore sharedStore] loadImageByURLString:imgURLString
                                     completionHandler:nil];
    }
}

@end
