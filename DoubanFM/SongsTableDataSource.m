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
        _channelId = 0;
    }

    return self;
}

- (void)getSongs {
    NSString *urlString = [NSString stringWithFormat:@"http://www.douban.com/j/app/radio/people?version=100&app_name=radio_desktop_win&type=n&channel=%lu", self.channelId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSDictionary *channels = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:nil];
                        NSLog(@"%@", channels);
                        
                        if (self.completionHandler) {
                            self.completionHandler();
                        }
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
