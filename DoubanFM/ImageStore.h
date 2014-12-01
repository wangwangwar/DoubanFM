//
//  ImageManager.h
//  DoubanFM
//
//  Created by wangwangwar on 14/11/26.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+ (instancetype)sharedStore;
- (void)loadImageByURLString:(NSString *)urlString
           completionBlock:(void (^)(UIImage *))completionBlock;

@end
