//
//  ViewController.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-23.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "ViewController.h"
#import "MyAnnotation.h"

#import "UIImage+ColorChange.h"
#import "UIColor+Utility.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic) NSArray *annotations;
@property (nonatomic) UIImage *basePinImage;
@property (nonatomic) NSMutableDictionary *pinImagesByColor;

@end



@implementation ViewController


static NSString *ANNOTATION_PIN_ID = @"ANNOTATION_PIN";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.basePinImage = [UIImage imageNamed:@"pin"];
    self.pinImagesByColor = [NSMutableDictionary dictionary];
    
    self.mapView.delegate = self;
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:ANNOTATION_PIN_ID];
    
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
    
    MKAnnotationView *view = (MKAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_PIN_ID
    forAnnotation:annotation];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_PIN_ID];
    }
    else {
        view.annotation = annotation;
    }

    view.image = [self imageForAnnotation:annotation];
//    view.tint = [UIColor greenColor];
    view.canShowCallout = YES;
    
    return view;
    
}

- (UIImage*)imageForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation respondsToSelector:@selector(countryCode)]) {
        MyAnnotation *myAnn = (MyAnnotation*)annotation;

        
//        Pin colors:
//         - Canada: #f44336
//         - United-State: #e040fb
//         - France: #3f51b5
//         - United Kingdom: #8bc34a
//         - Germany: #ffc107
//         - Other country: #00bcd4
        
        NSString *countryCode = myAnn.countryCode;
        
        NSDictionary *colors = @{
            @"CA": @"#f44336",
            @"US": @"#e040fb",
            @"FR": @"#3f51b5",
            @"GB": @"#8bc34a",
            @"DE": @"#ffc107",
        };
        NSString *fallbackColorStr = @"#00bcd4";
        
        NSString *colorStr = colors[countryCode];
        if (!colorStr) {
            colorStr = fallbackColorStr;
        }
        
        UIImage *image = [_pinImagesByColor objectForKey:colorStr];
        if (!image) {
            UIColor *color = [UIColor colorWithHexString:colorStr];
            image = [self.basePinImage imageByChangingColorTo:color];
            [_pinImagesByColor setObject:image forKey:colorStr];
        }
        
        return image;
    }
    else {
        return nil;
    }
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"WillStartLoadingMap");
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"DidFinishLoadingMap");
}

@end
