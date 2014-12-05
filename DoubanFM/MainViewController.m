//
//  MainViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <FXBlurView/FXBlurView.h>
#import "MainViewController.h"
#import "ArrayDataSource.h"
#import "Song.h"
#import "ImageStore.h"
#import "Time.h"

NSString *CELL_IDENTIFIER = @"SongCell";

@interface MainViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *authorAndAlbumName;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) Song *song;
@property (nonatomic, strong) NSDictionary *currentSong;
@property (nonatomic) ArrayDataSource *ads;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) NSTimer *timer;

@end

@implementation MainViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initial `Song` class
    _song = [[Song alloc] initWithChannelId:0];
    
    // Get songs
    [_song refreshWithDataRefreshBlock:nil
                       completionBlock:^{
                           [self changeSong:[_song getSongByIndex:0]];
                       }];
    
    // Blur the background image
    _bgImageView.image = [self getBlurredImage:_bgImageView.image];
}

#pragma mark - Operations

- (void)changeSong:(NSDictionary *)song {
    NSLog(@"Change song");
    
    self.currentSong = song;
    
    // Set time label update timer
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(updateAll:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    // Set bg and album image
    [self setImageByURLString:song[@"picture"]];
    
    // Set song title, singer and album name
    _songTitle.text = song[@"title"];
    _authorAndAlbumName.text = [NSString stringWithFormat:@"%@ - %@",
                                song[@"artist"], song[@"albumtitle"]];
    
    // Play!
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:song[@"url"]]];
    [self.player play];
}

#pragma mark - Actions

- (void)updateAll:(id)sender {
    [self updateTimeLabel:sender];
    [self updateProgress:sender];
}

- (void)updateTimeLabel:(id)sender {
    self.timeLabel.text = [Time timeStringWithCMTime:self.player.currentTime];
}

- (void)updateProgress:(id)sender {
    _progressBar.progress = [Time secondsWithCMTime:self.player.currentTime] / (double)[self.currentSong[@"length"] intValue];
}

#pragma mark - Assists

- (UIImage *)getBlurredImage:(UIImage *)image {
    return [image blurredImageWithRadius:10.0
                              iterations:5
                               tintColor:[UIColor blackColor]];
}

- (void)setImageByURLString:(NSString *)urlString {
    [[ImageStore sharedStore] loadImageByURLString:urlString
                                   completionBlock:^(UIImage *image) {
                                       _bgImageView.image = [self getBlurredImage:image];
                                       _albumImageView.image = image;
                                   }];
}

@end
