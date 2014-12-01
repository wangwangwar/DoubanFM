//
//  MainViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MainViewController.h"
#import "ArrayDataSource.h"
#import "Song.h"
#import "ImageStore.h"
#import "Time.h"

NSString *CELL_IDENTIFIER = @"SongCell";

@interface MainViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) Song *song;
@property (nonatomic) ArrayDataSource *ads;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) NSTimer *timer;

@end

@implementation MainViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell identifier for later using
    [self.tv registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CELL_IDENTIFIER];
    
    // Initial `Song` class
    _song = [[Song alloc] initWithChannelId:0];
    
    // Set song table view data source
    self.ads = [[ArrayDataSource alloc] initWithItems:_song.songs
                                       cellIdentifier:CELL_IDENTIFIER
                                   configureCellBlock:^(UITableViewCell *cell, NSDictionary *song) {
                                       cell.textLabel.text = song[@"title"];
                                   }];
    self.tv.dataSource = self.ads;
    
    // Set song table view delegate
    self.tv.delegate = self;
    
    // Refresh song's data
    [_song refreshWithCompletionBlock:^{
        [self.tv reloadData];
    }];
}

#pragma mark - Operations

- (void)playMusicByURL:(NSURL *)url {
    NSLog(@"Play");
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
    
    // Set time label update timer
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(updateTimeLabel:)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)setImageByURLString:(NSString *)urlString {
    [[ImageStore sharedStore] loadImageByURLString:urlString
                                   completionBlock:^(UIImage *image) {
                                       self.imageView.image = image;
                                   }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *song = _song.songs[indexPath.row];
    NSURL *songUrl = [NSURL URLWithString:song[@"url"]];
    [self setImageByURLString:song[@"picture"]];
    [self playMusicByURL:songUrl];
}

#pragma mark - Actions

- (void)updateTimeLabel:(id)sender {
    self.timeLabel.text = [Time timeStringWithCMTime:self.player.currentTime];
}
@end
