//
//  FeedsList.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-28.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "FeedsList.h"

@interface FeedsList ()

@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation FeedsList

+ (id)sharedInstance {
    static FeedsList *instance = nil;
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (void)registerDownloadHooks {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    [self downloadDataIfNeeded];
}

- (void)downloadDataIfNeeded {
    
    if (!self.downloadTask) {
        NSURL *url = [NSURL URLWithString:@"https://api.transitapp.com/v3/feeds?detailed=1"];
        NSURLSession *session = [NSURLSession sharedSession];
        self.downloadTask = [session downloadTaskWithURL:url
                                       completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            self.downloadTask = nil;
            if (error) {
                NSLog(@"Error during feed download: %@", error);
                [self loadFeedFromSavedData];
            }
            else {
                NSLog(@"Download finished");
                [self saveFeedData:location];
            }
        }];
        [self.downloadTask resume];
        NSLog(@"Starting download for %@", url);
    }
}

- (void)loadFeedFromSavedData {
    // TODO
}

- (void)saveFeedData:(NSURL*)location {
    // TODO save data
    [self updateFeedDataWithLocalFile:location];
}

- (void)updateFeedDataWithLocalFile:(NSURL*)location {
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:location options:NSDataReadingMapped error:&error];
    if (error) {
        NSLog(@"Error loading feed data: %@", error);
        return;
    }
    
    NSDictionary *jsonRoot = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Error parsing feed data: %@", error);
        return;
    }
    
    NSArray *feedItems = [jsonRoot valueForKey:@"feeds"];
    
    NSLog(@"Update feed data with %ld entries", feedItems.count);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *item in feedItems) {
        MyAnnotation *annotation = [[MyAnnotation alloc] initWithFeedItem:item];
        [array addObject:annotation];
    }
    
    self.annotations = array;
}


@end
