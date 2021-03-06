//
//  ChannelTableViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/23.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "ChannelTableViewController.h"
#import "ArrayDataSource.h"
#import "SongStore.h"
#import "PageViewController.h"
#import "SongTableViewController.h"
#import <ReactiveCocoa.h>

static NSString *CELL_IDENTIFIER = @"ChannelCell";

@interface ChannelTableViewController ()

@end

@implementation ChannelTableViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell identifier for later using
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CELL_IDENTIFIER];
    
    @weakify(self);
    [[RACObserve(self.viewModel, channelList)
      deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(id x) {
          @strongify(self);
          [self.tableView reloadData];
      }];
    
    [RACObserve(self.viewModel, currentChannelIndex) subscribeNext:^(NSNumber *index) {
        @strongify(self)
        NSUInteger channelId = [self.viewModel channelIdAtIndex:index.integerValue];
        NSLog(@"channelId: %lu", (unsigned long)channelId);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.currentChannelIndex = @(indexPath.row);
    [self.tableView reloadData];
    //
    NSUInteger channelId = [self.viewModel channelIdAtIndex:indexPath.row];
    [[SongStore sharedStore] changeChannel:channelId];
}

#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.viewModel titleAtIndex:indexPath.row];
    // Current channel cell has a checkmark
    BOOL isCurrentChannel = indexPath.row == self.viewModel.currentChannelIndex.integerValue;
    cell.accessoryType = isCurrentChannel ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
