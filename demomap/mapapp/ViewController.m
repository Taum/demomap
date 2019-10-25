//
//  ViewController.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-23.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic) NSArray *annotations;

@end



@implementation ViewController


static NSString *ANNOTATION_PIN_ID = @"ANNOTATION_PIN";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    [self.mapView registerClass:[MKPinAnnotationView class] forAnnotationViewWithReuseIdentifier:ANNOTATION_PIN_ID];
    
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
    
    [self addAnnotationsWithFeedItems:self.feedData];
}

- (void)addAnnotationsWithFeedItems:(NSArray*)items {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *item in items) {
        MyAnnotation *annotation = [[MyAnnotation alloc] initWithFeedItem:item];
        [array addObject:annotation];
    }
    
    self.annotations = array;
    [self.mapView addAnnotations:self.annotations];
}

//#pragma mark - Map View Delegate methods

- (MKAnnotationView*)mapView:(MKMapView*)mv viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
          return nil;
    }
    
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_PIN_ID
    forAnnotation:annotation];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_PIN_ID];
        view.pinTintColor = MKPinAnnotationView.redPinColor;
        view.animatesDrop = YES;
        view.canShowCallout = YES;
    }
    else {
        view.annotation = annotation;
    }
    return view;
    
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"WillStartLoadingMap");
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"DidFinishLoadingMap");
}

@end
