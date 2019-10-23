//
//  ViewController.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-23.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}


- (void)loadData {
    NSString *feedPath = [[NSBundle mainBundle] pathForResource:@"feed" ofType:@"json"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:feedPath options:NSDataReadingMapped error:&error];
    if (error) {
        NSLog(@"Error loading feed data: %@", error);
        return;
    }
    
    NSDictionary *jsonRoot = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Error parsing feed data: %@", error);
        return;
    }
    
    self.feedData = [jsonRoot valueForKey:@"feeds"];
    
    NSLog(@"Parsed feed data with %ld entries", [self.feedData count]);
    
}


@end
