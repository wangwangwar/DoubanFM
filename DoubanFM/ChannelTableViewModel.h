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

- (NSString *)titleAtIndexPath:(NSIndexPath *)path;
- (NSUInteger)channelIdAtIndexPath:(NSIndexPath *)path;

@end
