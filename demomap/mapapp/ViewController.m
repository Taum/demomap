//
//  ViewController.m
//  mapapp
//
//  Created by Thomas Brian on 2019-10-23.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import "ViewController.h"
#import "FeedsList.h"

#import "UIImage+ColorChange.h"
#import "UIColor+Utility.h"

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic) UIImage *basePinImage;
@property (nonatomic) NSMutableDictionary *pinImagesByColor;

@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end



@implementation ViewController


static void *ANNOTATIONS_CHANGE_CTX = @"ANNOTATIONS_CHANGE";
static NSString *ANNOTATION_PIN_ID = @"ANNOTATION_PIN";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.basePinImage = [UIImage imageNamed:@"pin"];
    self.pinImagesByColor = [NSMutableDictionary dictionary];
    
    self.mapView.delegate = self;
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:ANNOTATION_PIN_ID];
    
    FeedsList *list = [FeedsList sharedInstance];
    
    [list addObserver:self
           forKeyPath:@"annotations"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
              context:ANNOTATIONS_CHANGE_CTX];
}

- (void)dealloc {
    FeedsList *list = [FeedsList sharedInstance];
    [list removeObserver:self forKeyPath:@"annotations" context:@"annotationsChange"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context {
    if (context == ANNOTATIONS_CHANGE_CTX) {
        
        // Ideally we would check here for changes to the annotations array and only update those
        FeedsList *list = (FeedsList*)object;
        NSArray *annotations = list.annotations;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotations:annotations];
        });
    }
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


/*
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;

    float delay = 0.00;
    float increment = 1.0 / (float)MAX(views.count, 5);

    for (aV in views) {
        CGRect endFrame = aV.frame;

        aV.alpha = 0;
        delay = delay + increment;

        [UIView animateWithDuration:0.5
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            aV.alpha = 1.0;
        }
                         completion:nil];
    }
}
 */

@end
