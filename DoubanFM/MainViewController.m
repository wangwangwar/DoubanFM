//
//  MainViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "MainViewController.h"
#import "SongsTableDataSource.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UITableView *songTable;
@property (nonatomic) SongsTableDataSource *sds;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.songTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"SongCell"];
    
    // Set song table view data source
    self.sds = [[SongsTableDataSource alloc] init];
    UITableView *tv = self.songTable;
    self.sds.completionHandler = ^{
        NSLog(@"Completioin Handler");
        [tv reloadData];
    };
    self.songTable.dataSource = self.sds;
    
    [self.sds getSongs];
}

@end
