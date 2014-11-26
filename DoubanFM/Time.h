//
//  Time.h
//  DoubanFM
//
//  Created by wangwangwar on 14/11/26.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Time : NSObject

+ (NSString *)timeStringWithCMTime:(CMTime)time;

@end
