//
//  MainViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MainViewController.h"
#import "SongsTableDataSource.h"
#import "ImageStore.h"

@interface MainViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UITableView *songTable;
@property (nonatomic) SongsTableDataSource *sds;
@property (nonatomic) AVPlayer *player;

@end

@implementation MainViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.songTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"SongCell"];
    
    // Set song table view data source
    self.sds = [[SongsTableDataSource alloc] init];
    self.songTable.dataSource = self.sds;
    self.songTable.delegate = self;
    
    UITableView *tv = self.songTable;
    [self.sds getSongsWithCompletionHandler:^{
        [tv reloadData];
    }];
}

#pragma mark - Operations

- (void)playMusicByURL:(NSURL *)url {
    NSLog(@"Play");
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
}

- (void)setImageByURLString:(NSString *)urlString {
    [[ImageStore sharedStore] loadImageByURLString:urlString
                                 completionHandler:^(UIImage *image) {
                                     self.imageView.image = image;
                                 }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *song = self.sds.songs[indexPath.row];
    NSURL *songUrl = [NSURL URLWithString:song[@"url"]];
    [self setImageByURLString:song[@"picture"]];
    [self playMusicByURL:songUrl];
}

@end
