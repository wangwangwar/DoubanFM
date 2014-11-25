//
//  SongsTableDataSource.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "SongsTableDataSource.h"

@interface SongsTableDataSource ()

@property (nonatomic) NSArray *songs;
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
        _songs = @[@1, @2, @3];
    }

    return self;
}

- (void)getSongsByChannel:(NSUInteger)channel {
    NSURL *url = [NSURL URLWithString:@"http://www.douban.com/j/app/radio/channels"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSDictionary *channels = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:nil];
                        NSLog(@"%@", channels);
                    }];
    [dataTask resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"aa");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = @"AAA";
    
    return cell;
}

@end
