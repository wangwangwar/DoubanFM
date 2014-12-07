//
//  PageViewController.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/7.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *viewControllers;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
