//
//  ChannelTableViewModel.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/23.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <ReactiveViewModel.h>

@interface ChannelTableViewModel : RVMViewModel

@property (nonatomic, strong) NSArray *channelList;
@property (nonatomic) NSNumber *currentChannelIndex;

// Return title of channel at index path
- (NSString *)titleAtIndex:(NSUInteger)index;

// Return id of channel at index path
- (NSUInteger)channelIdAtIndex:(NSUInteger)index;

// Return channel's count
- (NSUInteger)count;

@end
