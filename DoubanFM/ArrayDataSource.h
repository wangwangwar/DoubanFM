//
//  ArrayDataSource.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (void)setItems:(NSArray *)items;
- (instancetype)initWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(void (^)(id cell, id item))configureCell;

@end
