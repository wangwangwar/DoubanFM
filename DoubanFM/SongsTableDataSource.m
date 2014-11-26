//
//  SongsTableDataSource.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "SongsTableDataSource.h"
#import "ImageStore.h"

@interface SongsTableDataSource ()

@property (nonatomic) NSURLSession *session;

@end

@implementation SongsTableDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        _channelId = 0;
    }

    return self;
}

- (void)getSongsWithCompletionHandler:(void (^)())completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://www.douban.com/j/app/radio/people?version=100&app_name=radio_desktop_win&type=n&channel=%lu", (unsigned long)self.channelId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSDictionary *songsData = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:0
                                                                                    error:nil];
                        self.songs = songsData[@"song"];
                        
                        if (completionHandler) {
                            // View related operations must execute in main queue!
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                completionHandler();
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

#pragma mark - Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell"
                                                            forIndexPath:indexPath];
    NSDictionary *song = self.songs[indexPath.row];
    cell.textLabel.text = song[@"title"];
    
    return cell;
}

@end
