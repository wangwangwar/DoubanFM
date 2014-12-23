//
//  ChannelTableViewModel.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/23.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "ChannelTableViewModel.h"
#import <AFNetworking-RACExtensions/AFHTTPSessionManager+RACSupport.h>

NSString *CHANNEL_URL = @"http://www.douban.com/j/app/radio/channels";

@interface ChannelTableViewModel ()
@end

@implementation ChannelTableViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        RAC(self, channelList) = [self requestChannelList];
    }
    return self;
}

- (RACSignal *)requestChannelList {
    return [[[AFHTTPSessionManager manager]
            rac_GET:CHANNEL_URL parameters:nil]
            map:^id(NSDictionary *response) {
                return response[@"channels"];
            }];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)path {
    return _channelList[path.row][@"name"];
}

- (NSUInteger)channelIdAtIndexPath:(NSIndexPath *)path {
    return (NSUInteger)_channelList[path.row][@"channel_id"];
}

@end
