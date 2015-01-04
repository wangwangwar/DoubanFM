//
//  ImageManager.h
//  DoubanFM
//
//  Created by wangwangwar on 14/11/26.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RACAFNetworking.h>

@interface ImageStore : NSObject

+ (instancetype)sharedStore;

// Request image by url string
//
// Return a signal of the `UIImage` image data or error.
- (RACSignal *)requestImageByURLString:(NSString *)urlString;

@end
