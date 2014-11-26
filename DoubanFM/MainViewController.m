//
//  MainViewController.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/25.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "MainViewController.h"
#import "SongsTableDataSource.h"
#import <AVFoundation/AVFoundation.h>

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
    UITableView *tv = self.songTable;
    self.sds.completionHandler = ^{
        [tv reloadData];
    };
    self.songTable.dataSource = self.sds;
    self.songTable.delegate = self;
    
    [self.sds getSongs];
}

#pragma mark - 

- (void)playMusicByURL:(NSURL *)url {
    NSLog(@"Play");
    self.player = [[AVPlayer alloc] initWithURL:url];
    [self.player play];
}

- (void)setImageByURL:(NSURL *)url {
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        UIImage *image = [UIImage imageWithData:data];
                        self.imageView.image = image;
                    }];
    [dataTask resume];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *song = self.sds.songs[indexPath.row];
    NSURL *songUrl = [NSURL URLWithString:song[@"url"]];
    NSURL *imgUrl = [NSURL URLWithString:song[@"picture"]];
    [self setImageByURL:imgUrl];
    [self playMusicByURL:songUrl];
}

@end
