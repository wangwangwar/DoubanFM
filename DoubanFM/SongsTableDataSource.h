//
//  SongsTableDataSource.h
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongsTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSUInteger channelId;
@property (nonatomic, strong) void (^completionHandler)();

- (void)getSongs;

@end
