//
//  ImageManager.m
//  DoubanFM
//
//  Created by wangwangwar on 14/11/26.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic) NSMutableDictionary *privateImages;
@property (nonatomic) NSURLSession *session;

@end

@implementation ImageStore

#pragma mark - Initialization

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ImageStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    
    if (self) {
        _privateImages = [[NSMutableDictionary alloc] init];
        
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

#pragma mark - RAC

- (RACSignal *)requestImageByURLString:(NSString *)urlString {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFImageResponseSerializer alloc] init];
    return [manager rac_GET:urlString parameters:nil];
}

#pragma mark - Class Method

+ (instancetype)sharedStore {
    static ImageStore *sharedStore = nil;
    
    // Thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

@end
