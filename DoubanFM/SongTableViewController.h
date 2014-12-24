//
//  SongTableTableViewController.h
//  DoubanFM
//
//  Created by wangwangwar on 14/12/7.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrayDataSource.h"

@interface SongTableViewController : UITableViewController

@property (nonatomic, strong) ArrayDataSource *ads;

@end
