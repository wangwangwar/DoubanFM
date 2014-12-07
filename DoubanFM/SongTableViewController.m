//
//  SongTableTableViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/7.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "SongTableViewController.h"
#import "ArrayDataSource.h"
#import "SongStore.h"

NSString *CELL_IDENTIFIER = @"SongCell";

@interface SongTableViewController ()

@property (nonatomic, strong) ArrayDataSource *ads;

@end

@implementation SongTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell identifier for later using
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CELL_IDENTIFIER];
    
    // Set song table view data source
    
    self.ads = [[ArrayDataSource alloc] initWithItems:@[]
                                       cellIdentifier:CELL_IDENTIFIER
                                   configureCellBlock:^(UITableViewCell *cell, NSDictionary *song) {
                                       cell.textLabel.text = song[@"title"];
                                   }];
    self.tableView.dataSource = self.ads;
    
    [self.ads setItems:[SongStore sharedStore].songs];
    [self.tableView reloadData];
    [[SongStore sharedStore] loadWithDataRefreshBlock:^(NSArray *songArray) {
        [self.ads setItems:songArray];
    }
                                      completionBlock:^{
                                          [self.tableView reloadData];
                                      }];
}

@end
