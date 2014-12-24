//
//  SongTableTableViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/7.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "SongTableViewController.h"
#import "SongStore.h"
#import "PageViewController.h"
#import "MainViewController.h"

NSString *CELL_IDENTIFIER = @"SongCell";

@interface SongTableViewController ()

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
    
    @weakify(self)
    [[SongStore sharedStore] loadWithDataRefreshBlock:^(NSArray *songArray) {
        [self.ads setItems:songArray];
    }
                                      completionBlock:^{
                                          @strongify(self)
                                          [self.tableView reloadData];
                                      }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Select cell will change song
    NSDictionary *song = [[SongStore sharedStore] getSongByIndex:indexPath.row];
    PageViewController *pvc = self.parentViewController.parentViewController;
    MainViewController *mvc = pvc.viewControllers[1];
    [mvc changeSong:song];
}

#pragma mark - Interface

- (void)updateArrayDataSource:(NSArray *)array {
    [self.ads setItems:array];
    [self.tableView reloadData];
}

@end
