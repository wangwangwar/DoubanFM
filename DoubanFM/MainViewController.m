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
#import "SongStore.h"
#import "ImageStore.h"
#import "Time.h"

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

@property (nonatomic, strong) NSDictionary *currentSong;
@property (nonatomic) int currentSongIndex;
@property (nonatomic) ArrayDataSource *ads;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) NSTimer *timer;

@end

@implementation MainViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SongStore sharedStore] loadWithDataRefreshBlock:nil
                                      completionBlock:^{
                                          self.currentSongIndex = 0;
                                          [self changeSong:[[SongStore sharedStore]
                                                            getSongByIndex:self.currentSongIndex]];
                                      }];
    
    // Blur the background image
    _bgImageView.image = [self getBlurredImage:_bgImageView.image];
    
    // Allow play in background
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //
    @weakify(self)
    [RACObserve([SongStore sharedStore], songs) subscribeNext:^(NSArray *songs) {
        @strongify(self)
        [self changeSong:songs[self.currentSongIndex]];
    }];
}

#pragma mark - Operations

- (void)changeSong:(NSDictionary *)song {
    NSLog(@"Change song: %@", song);
    
    if (!song) {
        return;
    }
    
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

- (IBAction)pause:(id)sender {
    if (self.player.rate == 1.0) {
        [self.player pause];
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [self.player play];
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)prev:(id)sender {
    NSDictionary *song = [[SongStore sharedStore] getSongByIndex:(self.currentSongIndex - 1)];
    if (song) {
        [self changeSong:song];
        self.currentSongIndex --;
    }
}

- (IBAction)next:(id)sender {
    NSDictionary *song = [[SongStore sharedStore] getSongByIndex:(self.currentSongIndex + 1)];
    if (song) {
        [self changeSong:song];
        self.currentSongIndex ++;
    }
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
