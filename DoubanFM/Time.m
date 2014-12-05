//
//  Time.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/26.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "Time.h"

@implementation Time

+ (NSString *)timeStringWithCMTime:(CMTime)time {
    int t = (int)(time.value / (double)time.timescale);
    return [[NSString alloc] initWithFormat:@"%02d:%02d", (t / 60), (t % 60)];
}

+ (int)secondsWithCMTime:(CMTime)time {
    return (int)(time.value / (double)time.timescale);
}

@end
